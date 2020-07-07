library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_to_axi4m is
  port(
    clk   : in std_logic;
    reset : in std_logic;

    data_in      : in  std_logic_vector(32+4-1 downto 0);  -- data + strb
    data_we      : in  std_logic;
    data_in_full : out std_logic;
    ctrl_in      : in  std_logic_vector(32+8-1 downto 0);  -- len + addr
    ctrl_we      : in  std_logic;
    ctrl_in_full : out std_logic;

    m_axi_clk : in std_logic;
    m_axi_rst : in std_logic;

    m_axi_awid    : out std_logic_vector(4-1 downto 0);
    m_axi_awaddr  : out std_logic_vector(32-1 downto 0);
    m_axi_awlen   : out std_logic_vector(7 downto 0);
    m_axi_awsize  : out std_logic_vector(2 downto 0);
    m_axi_awburst : out std_logic_vector(1 downto 0);
    m_axi_awlock  : out std_logic_vector(0 downto 0);
    m_axi_awcache : out std_logic_vector(3 downto 0);
    m_axi_awprot  : out std_logic_vector(2 downto 0);
    m_axi_awvalid : out std_logic;
    m_axi_awready : in std_logic;
    
    m_axi_wdata  : out std_logic_vector(32-1 downto 0);
    m_axi_wstrb  : out std_logic_vector((32/8)-1 downto 0);
    m_axi_wlast  : out std_logic;
    m_axi_wvalid : out std_logic;
    m_axi_wready : in std_logic;
    
    m_axi_bready : out std_logic;
    m_axi_bid    : in  std_logic_vector(4-1 downto 0);
    m_axi_bresp  : in  std_logic_vector(1 downto 0);
    m_axi_bvalid : in  std_logic
  );
end entity fifo_to_axi4m;

architecture RTL of fifo_to_axi4m is

  attribute mark_debug : string;
  attribute keep       : string;

  component fifo_40_32_ft
    PORT (
      rst       : IN  STD_LOGIC;
      wr_clk    : IN  STD_LOGIC;
      rd_clk    : IN  STD_LOGIC;
      din       : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);
      wr_en     : IN  STD_LOGIC;
      rd_en     : IN  STD_LOGIC;
      dout      : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);
      full      : OUT STD_LOGIC;
      empty     : OUT STD_LOGIC;
      valid     : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC
      );
  end component fifo_40_32_ft;
  
  component fifo_36_1000
    PORT (
      rst       : IN  STD_LOGIC;
      wr_clk    : IN  STD_LOGIC;
      rd_clk    : IN  STD_LOGIC;
      din       : IN  STD_LOGIC_VECTOR(35 DOWNTO 0);
      wr_en     : IN  STD_LOGIC;
      rd_en     : IN  STD_LOGIC;
      dout      : OUT STD_LOGIC_VECTOR(35 DOWNTO 0);
      full      : OUT STD_LOGIC;
      empty     : OUT STD_LOGIC;
      valid     : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC
      );
  end component fifo_36_1000;
  
  component fifo_37_1000_ft
    PORT (
      rst       : IN  STD_LOGIC;
      wr_clk    : IN  STD_LOGIC;
      rd_clk    : IN  STD_LOGIC;
      din       : IN  STD_LOGIC_VECTOR(36 DOWNTO 0);
      wr_en     : IN  STD_LOGIC;
      rd_en     : IN  STD_LOGIC;
      dout      : OUT STD_LOGIC_VECTOR(36 DOWNTO 0);
      full      : OUT STD_LOGIC;
      empty     : OUT STD_LOGIC;
      valid     : OUT STD_LOGIC;
      prog_full : OUT STD_LOGIC
      );
  end component fifo_37_1000_ft;

  signal ctrl_in_rd    : std_logic := '0';
  signal ctrl_in_dout  : std_logic_vector(39 downto 0) := (others => '0');
  signal ctrl_in_valid : std_logic := '0';
  --signal ctrl_in_full  : std_logic := '0';

  signal data_in_rd    : std_logic := '0';
  signal data_in_dout  : std_logic_vector(32+4-1 downto 0) := (others => '0');
  signal data_in_valid : std_logic := '0';
  --signal data_in_full  : std_logic := '0';

  signal ctrl_out_din  : std_logic_vector(39 downto 0) := (others => '0');
  signal ctrl_out_wr   : std_logic := '0';
  signal ctrl_out_rd   : std_logic := '0';
  signal ctrl_out_dout : std_logic_vector(39 downto 0) := (others => '0');
  signal ctrl_out_valid : std_logic := '0';
  signal ctrl_out_full : std_logic := '0';

  signal data_out_din  : std_logic_vector(32+4+1-1 downto 0) := (others => '0');
  signal data_out_wr   : std_logic := '0';
  signal data_out_rd   : std_logic := '0';
  signal data_out_dout : std_logic_vector(32+4+1-1 downto 0) := (others => '0');
  signal data_out_valid : std_logic := '0';
  signal data_out_full : std_logic := '0';

  type StateType is (IDLE, DATA_SEND, DATA_SEND_PRE);
  signal state : StateType := IDLE;

  signal base_addr : unsigned(31 downto 0);
  signal data_num : unsigned(31 downto 0);

  signal send_num : unsigned(31 downto 0);
  signal data_counter : unsigned(31 downto 0);

begin

  ctrl_out_rd   <= m_axi_awready and ctrl_out_valid;
  m_axi_awvalid <= ctrl_out_valid;
  m_axi_awlen   <= std_logic_vector(unsigned(ctrl_out_dout(39 downto 32))-1); -- awlen should be -1
  m_axi_awaddr  <= ctrl_out_dout(31 downto 0);
  m_axi_awid    <= (others => '0');
  m_axi_awsize  <= "010"; -- 2^2 = 4Bytes
  m_axi_awburst <= "01"; -- INCR
  m_axi_awlock  <= (others => '0');
  m_axi_awcache <= "0010"; -- non-cacheable
  m_axi_awprot  <= (others => '0');
    
  m_axi_wdata  <= data_out_dout(31 downto 0);
  m_axi_wstrb  <= data_out_dout(35 downto 32);
  m_axi_wlast  <= data_out_dout(36) and data_out_valid;
  m_axi_wvalid <= data_out_valid;
  data_out_rd  <= m_axi_wready and data_out_valid;
    
  m_axi_bready <= '1';

  process(clk)
  begin
    if rising_edge(clk) then
      case state is
        
        when IDLE =>
        
          if ctrl_in_valid = '1' then
            base_addr <= unsigned(ctrl_in_dout(31 downto 0));
            data_num <= unsigned(X"000000" & ctrl_in_dout(39 downto 32));
            if unsigned(ctrl_in_dout(39 downto 32)) > 0 then
              state <= DATA_SEND_PRE;
              data_in_rd <= '1'; -- for next next
            end if;
          else
            data_in_rd <= '0';
          end if;
          data_out_wr <= '0';
          ctrl_out_wr <= '0';

        when DATA_SEND_PRE =>

          state <= DATA_SEND;
          if data_num > 16 then
            send_num <= to_unsigned(16, data_counter'length);
          else
            send_num <= data_num;
          end if;
          data_counter <= (others => '0');
          if data_num > 1 then
            data_in_rd <= '1';
          else
            data_in_rd <= '0';
          end if;
          data_out_wr <= '0';
          ctrl_out_wr <= '0';

        when DATA_SEND =>

          if send_num = data_counter + 1 then
            data_out_din(36) <= '1'; -- last data
            ctrl_out_wr <= '1';
            ctrl_out_din(39 downto 32) <= std_logic_vector(send_num(7 downto 0));
            ctrl_out_din(31 downto 0) <= std_logic_vector(base_addr);
            if data_num = send_num then
              state <= IDLE;
              data_in_rd <= '0';
            else
              base_addr <= base_addr + to_integer(send_num & "00"); -- + send_num * 4
              data_num <= data_num - send_num;
              state <= DATA_SEND_PRE;
              data_in_rd <= '1';
            end if;
            data_counter <= (others => '0');
          else
            data_out_din(36) <= '0';
            ctrl_out_wr <= '0';
            if send_num > data_counter + 2 then
              data_in_rd <= '1';
            else
              data_in_rd <= '0';
            end if;
            data_counter <= data_counter + 1;
          end if;
          
          data_out_wr <= '1';
          data_out_din(35 downto 0) <= data_in_dout;

        when others =>
          state       <= IDLE;
          ctrl_out_wr <= '0';
          data_out_wr <= '0';
          
      end case;
    end if;
  end process;

  ctrl_in_rd <= '1' when ctrl_in_valid = '1' and state = IDLE else '0';
  
  ctrl_in_buf : fifo_40_32_ft
    PORT map(
      rst       => reset,
      wr_clk    => clk,
      rd_clk    => clk,
      din       => ctrl_in,
      wr_en     => ctrl_we,
      rd_en     => ctrl_in_rd,
      dout      => ctrl_in_dout,
      full      => open,
      empty     => open,
      valid     => ctrl_in_valid,
      prog_full => ctrl_in_full
      );
  
  data_in_buf : fifo_36_1000
    PORT map(
      rst       => reset,
      wr_clk    => clk,
      rd_clk    => clk,
      din       => data_in,
      wr_en     => data_we,
      rd_en     => data_in_rd,
      dout      => data_in_dout,
      full      => open,
      empty     => open,
      valid     => data_in_valid,
      prog_full => data_in_full
      );
  
  ctrl_out_buf : fifo_40_32_ft
    PORT map(
      rst       => reset,
      wr_clk    => clk,
      rd_clk    => m_axi_clk,
      din       => ctrl_out_din,
      wr_en     => ctrl_out_wr,
      rd_en     => ctrl_out_rd,
      dout      => ctrl_out_dout,
      full      => open,
      empty     => open,
      valid     => ctrl_out_valid,
      prog_full => ctrl_out_full
      );

  data_out_buf : fifo_37_1000_ft
    PORT map(
      rst       => reset,
      wr_clk    => clk,
      rd_clk    => m_axi_clk,
      din       => data_out_din,
      wr_en     => data_out_wr,
      rd_en     => data_out_rd,
      dout      => data_out_dout,
      full      => open,
      empty     => open,
      valid     => data_out_valid,
      prog_full => data_out_full
      );

end RTL;
