library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi4m_to_fifo is

  generic (
    C_M_AXI_ID_WIDTH   : integer := 4;
    C_M_AXI_ADDR_WIDTH : integer := 32;
    C_M_AXI_DATA_WIDTH : integer := 128
    );

  port (
    clk : in std_logic;
    reset : in std_logic;

    kick      : in  std_logic;
    busy      : out std_logic;
    read_num  : in  std_logic_vector(31 downto 0);
    read_addr : in  std_logic_vector(31 downto 0);
    
    m_axi_arid    : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    m_axi_araddr  : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    m_axi_arlen   : out std_logic_vector(7 downto 0);
    m_axi_arsize  : out std_logic_vector(2 downto 0);
    m_axi_arburst : out std_logic_vector(1 downto 0);
    m_axi_arlock  : out std_logic_vector(0 downto 0);
    m_axi_arcache : out std_logic_vector(3 downto 0);
    m_axi_arprot  : out std_logic_vector(2 downto 0);
    m_axi_arvalid : out std_logic;
    m_axi_arready : in std_logic;
    
    m_axi_rready : out std_logic;
    m_axi_rid    : in  std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    m_axi_rdata  : in  std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_rresp  : in  std_logic_vector(1 downto 0);
    m_axi_rlast  : in  std_logic;
    m_axi_rvalid : in  std_logic;

    buf_dout : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    buf_we   : out std_logic
    );
  
end entity axi4m_to_fifo;

architecture RTL of axi4m_to_fifo is

  type StateType is (IDLE, EMIT_AR, RECV_DATA);

  signal state : StateType := IDLE;
    
  signal axi_arid    : std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
  signal axi_araddr  : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_arlen   : std_logic_vector(31 downto 0);
  signal axi_arsize  : std_logic_vector(2 downto 0);
  signal axi_arburst : std_logic_vector(1 downto 0);
  signal axi_arlock  : std_logic_vector(0 downto 0);
  signal axi_arcache : std_logic_vector(3 downto 0);
  signal axi_arprot  : std_logic_vector(2 downto 0);
  signal axi_arvalid : std_logic;
  signal axi_arready : std_logic;
    
  signal axi_rready : std_logic;
  signal axi_rid    : std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
  signal axi_rdata  : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
  signal axi_rresp  : std_logic_vector(1 downto 0);
  signal axi_rlast  : std_logic;
  signal axi_rvalid : std_logic;

  signal read_num_reg  : unsigned(31 downto 0);
  signal read_addr_reg : unsigned(31 downto 0);
  signal recv_num      : unsigned(31 downto 0);

  signal kick_d0 : std_logic := '0';
  signal kick_d1 : std_logic := '0';

begin

  m_axi_arvalid <= axi_arvalid;
  m_axi_arid    <= axi_arid;
  m_axi_araddr  <= axi_araddr;
  m_axi_arlen   <= std_logic_vector(to_unsigned(to_integer(unsigned(axi_arlen)-1), m_axi_arlen'length));
  m_axi_arsize  <= axi_arsize;
  m_axi_arburst <= axi_arburst;
  m_axi_arlock  <= axi_arlock;
  m_axi_arcache <= axi_arcache;
  m_axi_arprot  <= axi_arprot;

  axi_arready <= m_axi_arready;
  
  m_axi_rready <= axi_rready;
  axi_rid    <= m_axi_rid;
  axi_rdata  <= m_axi_rdata;
  axi_rresp  <= m_axi_rresp;
  axi_rlast  <= m_axi_rlast;
  axi_rvalid <= m_axi_rvalid;

  process(clk)
  begin
    if rising_edge(clk) then
      
      kick_d0 <= kick;
      kick_d1 <= kick_d0;
      
      if reset = '1' then
        busy       <= '0';
        buf_we     <= '0';
        axi_rready <= '0';
      else
        
        case state is
        
          when IDLE =>
            if kick_d1 = '1' then
              busy <= '1';
              if(unsigned(read_num) > 0) then
                state <= EMIT_AR;
                read_num_reg  <= unsigned(read_num);
                read_addr_reg <= unsigned(read_addr);
              end if;
            else
              busy <= '0';
            end if;
            buf_we <= '0';
            axi_rready <= '0';

          when EMIT_AR =>
            if read_num_reg > 16 then
              axi_arlen <= std_logic_vector(to_unsigned(16, axi_arlen'length));
              read_addr_reg <= read_addr_reg + (16 * C_M_AXI_DATA_WIDTH / 8);
            else
              axi_arlen <= std_logic_vector(read_num_reg);
            end if;

            axi_arid    <= (others => '0');
            axi_araddr  <= std_logic_vector(read_addr_reg);
            axi_arsize  <= std_logic_vector(to_unsigned(4, axi_arsize'length));  -- 2^4 = 16Bytes
            axi_arburst <= "01";        -- INCR
            axi_arlock  <= (others => '0');
            axi_arcache <= "0010";      -- non-cacheable
            axi_arprot  <= (others => '0');
            axi_arvalid <= '1';

            state    <= RECV_DATA;
            recv_num <= (others => '0');
            buf_we <= '0';
            axi_rready <= '0';

          when RECV_DATA =>
            axi_rready <= '1';

            if axi_arvalid = '1' and axi_arready = '1' then
              axi_arvalid <= '0';
            end if;

            buf_dout <= axi_rdata;
            buf_we   <= axi_rvalid;
            
            if axi_rvalid = '1' then
              if recv_num + 1 = to_integer(unsigned(axi_arlen)) then
                recv_num <= (others => '0');
                if read_num_reg - to_integer(unsigned(axi_arlen))  = 0 then
                  state <= IDLE;
                else
                  read_num_reg <= read_num_reg - to_integer(unsigned(axi_arlen));
                  state <= EMIT_AR;
                end if;
              else
                recv_num <= recv_num + 1;
              end if;
            end if;

          when others =>
            state      <= IDLE;
            buf_we     <= '0';
            axi_rready <= '0';
        
        end case;
      end if;
    end if;
  end process;

  
end RTL;
