library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity init_sccb_top_tb is
end entity init_sccb_top_tb;

architecture RTL of init_sccb_top_tb is

  component init_sccb_top
    port (
      pClk         : in  std_logic;
      pReset       : in  std_logic;
      time_1ms     : in  std_logic;
      set_mode     : in  std_logic_vector(1 downto 0);
      --------
      init_req     : in  std_logic;
      init_done    : out std_logic;
      init_err     : out std_logic;
      I2CIO_BUSY   : out std_logic; --moni
      --------
      I2CIO_SIC    : out std_logic;
      I2CIO_SID_I  : in  std_logic;
      I2CIO_SID_O  : out std_logic;
      I2CIO_SID_D  : out std_logic;
    
      debug : out std_logic_vector(7 downto 0)
      );
  end component init_sccb_top;
  
  signal pClk        : std_logic := '0';
  signal pReset      : std_logic := '1';
  signal time_1ms    : std_logic := '1';
  signal set_mode    : std_logic_vector(1 downto 0) := "00";
  signal init_req    : std_logic := '0';
  signal init_done   : std_logic := '0';
  signal init_err    : std_logic := '0';
  signal I2CIO_BUSY  : std_logic := '0';
  signal I2CIO_SIC   : std_logic := '0';
  signal I2CIO_SID_I : std_logic := '0';
  signal I2CIO_SID_O : std_logic := '0';
  signal I2CIO_SID_D : std_logic := '0';
  signal sccb1_debug : std_logic_vector(7 downto 0);

  signal state_counter : unsigned(31 downto 0) := (others => '0');

begin

  process
  begin
    pClk <= not pClk;
    wait for 4ns;
  end process;

  process(pClk)
  begin
    if rising_edge(pClk) then
      
      if state_counter < 100000 then
        state_counter <= state_counter + 1;
      end if;
      
      if to_integer(state_counter) = 10 then
        pReset <= '0';
      end if;
      if to_integer(state_counter) = 11 then
        init_req <= '1';
      end if;
      if to_integer(state_counter) = 12 then
        init_req <= '0';
      end if;
      
    end if;
  end process;
    
  time_1ms <= '1';

  MIPI_SCCB1 : init_sccb_top
    port map(
      pClk         => pClk,
      pReset       => pReset,
      time_1ms     => time_1ms,
      set_mode     => set_mode,
      --------
      init_req     => init_req,
      init_done    => init_done,
      init_err     => init_err,
      I2CIO_BUSY   => I2CIO_BUSY,
      --------
      I2CIO_SIC    => I2CIO_SIC,
      I2CIO_SID_I  => I2CIO_SID_I,
      I2CIO_SID_O  => I2CIO_SID_O,
      I2CIO_SID_D  => I2CIO_SID_D,
      debug => sccb1_debug
      );
  
end RTL;
