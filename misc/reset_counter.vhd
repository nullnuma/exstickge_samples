library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_counter is
  generic (
    RESET_COUNT : integer := 1000
    );
  port (
    clk     : in  std_logic;
    reset_i : in  std_logic;
    reset_o : out std_logic := '0'
    );
end entity reset_counter;

architecture RTL of reset_counter is

  signal counter : unsigned(31 downto 0) := (others => '0');
  
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if reset_i = '1' then
        counter <= (others => '0');
        reset_o <= '1';
      else
        if counter < RESET_COUNT then
          counter <= counter + 1;
          reset_o <= '1';
        else
          reset_o <= '0';
        end if;
      end if;
    end if;
  end process;
  
end RTL;
