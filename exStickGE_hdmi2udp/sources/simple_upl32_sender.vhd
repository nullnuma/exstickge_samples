library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_upl32_sender is
  port (
    
    clk   : in std_logic;
    reset : in std_logic;
    
    UPL_REQ  : out std_logic;
    UPL_ACK  : in  std_logic;
    UPL_EN   : out std_logic;
    UPL_DOUT : out std_logic_vector(31 downto 0);

    data_clk   : in  std_logic;
    data_din   : in  std_logic_vector(31 downto 0);
    data_we    : in  std_logic;
    data_full  : out std_logic;

    ctrl_clk   : in  std_logic;
    ctrl_din   : in  std_logic_vector(127 downto 0);
    ctrl_we    : in  std_logic;
    ctrl_full  : out std_logic
    );
end entity simple_upl32_sender;

architecture RTL of simple_upl32_sender is

  attribute MARK_DEBUG : string;
  attribute KEEP : string;

  component fifo_128_16_ft
    port (
      -- FIFO_WRITE
      full        : out std_logic;
      din         : in  std_logic_vector(127 downto 0);
      wr_en       : in  std_logic;
      prog_full   : out std_logic;
      -- FIFO_READ
      empty       : out std_logic;
      dout        : out std_logic_vector(127 downto 0);
      rd_en       : in  std_logic;
      valid       : out std_logic;
      -- ctrl/stat
      rst         : in  std_logic;
      wr_clk      : in  std_logic;
      rd_clk      : in  std_logic;
      wr_rst_busy : out std_logic;
      rd_rst_busy : out std_logic
    );
  end component fifo_128_16_ft;

  component fifo_32_2048
    port (
      -- FIFO_WRITE
      full        : out std_logic;
      din         : in  std_logic_vector(31 downto 0);
      wr_en       : in  std_logic;
      prog_full   : out std_logic;
      -- FIFO_READ
      empty       : out std_logic;
      dout        : out std_logic_vector(31 downto 0);
      rd_en       : in  std_logic;
      -- ctrl/stat
      rst         : in  std_logic;
      wr_clk      : in  std_logic;
      rd_clk      : in  std_logic;
      wr_rst_busy : out std_logic;
      rd_rst_busy : out std_logic
    );
  end component fifo_32_2048;

  signal ctrl_empty       : std_logic;
  signal ctrl_dout        : std_logic_vector(127 downto 0) := (others => '0');
  signal ctrl_rd          : std_logic := '0';
  signal ctrl_valid       : std_logic;
  signal ctrl_wr_rst_busy : std_logic;
  signal ctrl_rd_rst_busy : std_logic;
  
  signal data_empty       : std_logic;
  signal data_dout        : std_logic_vector(31 downto 0) := (others => '0');
  signal data_rd          : std_logic := '0';
  signal data_wr_rst_busy : std_logic;
  signal data_rd_rst_busy : std_logic;

  signal state_counter : unsigned(31 downto 0)          := (others => '0');
  signal ctrl_reg      : std_logic_vector(127 downto 0) := (others => '0');
  signal send_words    : unsigned(31 downto 0);

  
  attribute MARK_DEBUG of send_words : signal is "true";
  attribute MARK_DEBUG of data_dout  : signal is "true";
  attribute MARK_DEBUG of data_rd    : signal is "true";
  
  attribute KEEP of send_words : signal is "true";
  attribute KEEP of data_dout  : signal is "true";
  attribute KEEP of data_rd    : signal is "true";

begin

  U_CTRL : fifo_128_16_ft port map(
    -- FIFO_WRITE
    full        => open,
    din         => ctrl_din,
    wr_en       => ctrl_we,
    prog_full   => ctrl_full,
    -- FIFO_READ
    empty       => ctrl_empty,
    dout        => ctrl_dout,
    rd_en       => ctrl_rd,
    valid       => ctrl_valid,
    -- ctrl/stat
    rst         => reset,
    wr_clk      => ctrl_clk,
    rd_clk      => clk,
    wr_rst_busy => ctrl_wr_rst_busy,
    rd_rst_busy => ctrl_rd_rst_busy
    );

  U_DATA : fifo_32_2048 port map(
    -- FIFO_WRITE
    full        => open,
    din         => data_din,
    wr_en       => data_we,
    prog_full   => data_full,
    -- FIFO_READ
    empty       => data_empty,
    dout        => data_dout,
    rd_en       => data_rd,
    -- ctrl/stat
    rst         => reset,
    wr_clk      => data_clk,
    rd_clk      => clk,
    wr_rst_busy => data_wr_rst_busy,
    rd_rst_busy => data_rd_rst_busy
    );

  process(clk)
    variable tmp : unsigned(31 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state_counter <= (others => '0');
        UPL_REQ       <= '0';
        UPL_EN        <= '0';
        UPL_DOUT      <= (others => '0');
        data_rd       <= '0';
      else

        case to_integer(state_counter) is
          when 0 =>
            if ctrl_valid = '1' then
              ctrl_rd  <= '1';
              ctrl_reg <= ctrl_din;
              UPL_REQ  <= '1';
              tmp      := unsigned(ctrl_din(31 downto 0));
              if tmp > 0 then
                state_counter <= state_counter + 1;
                tmp           := "00" & tmp(31 downto 2);
                --if tmp(1 downto 0) > 0 then
                --  tmp := tmp + 1;
                --end if;
                send_words <= tmp;
              end if;
            else
              UPL_REQ <= '0';
              ctrl_rd <= '0';
            end if;
            data_rd <= '0';
          when 1 =>
            ctrl_rd <= '0';
            data_rd <= '0';
            if UPL_ACK = '1' then
              UPL_REQ       <= '0';
              UPL_DOUT      <= ctrl_reg(127 downto 96);
              UPL_EN        <= '1';
              state_counter <= state_counter + 1;
            else
              UPL_REQ <= '1';
            end if;
          when 2 =>
            UPL_EN        <= '1';
            UPL_DOUT      <= ctrl_reg(95 downto 64);
            state_counter <= state_counter + 1;
            data_rd       <= '0';
          when 3 =>
            UPL_EN        <= '1';
            UPL_DOUT      <= ctrl_reg(63 downto 32);
            state_counter <= state_counter + 1;
            data_rd       <= '1'; -- for next next
          when 4 =>
            UPL_EN        <= '1';
            UPL_DOUT      <= ctrl_reg(31 downto 0);
            state_counter <= state_counter + 1;
            if send_words >= 2 then -- for next
              data_rd       <= '1';
            else
              data_rd       <= '0';
            end if;
          when 5 =>
            if send_words = 0 then
              UPL_EN        <= '0';
              state_counter <= (others => '0');
            else
              send_words <= send_words - 1;
              if send_words >= 2 then -- for next
                data_rd <= '1';
              else
                data_rd <= '0';
              end if;
              UPL_EN   <= '1';
              UPL_DOUT <= data_dout;
            end if;
          when others =>
            null;
        end case;
        
      end if;
    end if;
  end process;
  
end RTL;
