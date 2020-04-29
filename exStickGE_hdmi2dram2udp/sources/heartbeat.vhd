library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity heartbeat is
  generic(
    INDEX : integer := 24
    );
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic
  );
end entity heartbeat;

architecture RTL of heartbeat is
  
  signal counter : unsigned(31 downto 0) := (others => '0');
  
begin

  q <= std_logic(counter(INDEX));
    
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;
  
end RTL;
