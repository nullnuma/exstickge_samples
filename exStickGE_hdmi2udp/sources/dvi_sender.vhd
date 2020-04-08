library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dvi_sender is
  port(
    clk   : in std_logic;
    reset : in std_logic;

    de    : in std_logic;
    hsync : in std_logic;
    vsync : in std_logic;
    din   : in std_logic_vector(23 downto 0);

    full : in  std_logic;
    dout : out std_logic_vector(31 downto 0);
    we   : out std_logic;
    
    ctrl_dout : out std_logic_vector(127 downto 0);
    ctrl_we : out std_logic
    );
end entity dvi_sender;

architecture RTL of dvi_sender is

  attribute MARK_DEBUG : string;
  attribute KEEP : string;

  signal line_counter  : unsigned(31 downto 0) := (others => '0');
  signal pixel_counter : unsigned(31 downto 0) := (others => '0');

  signal de_d    : std_logic;
  signal hsync_d : std_logic;
  signal vsync_d : std_logic;
  signal din_d   : std_logic_vector(24*4-1 downto 0);

  signal send_flag : std_logic;

  function conv24to8 (v : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(7 downto 0);
    variable r : std_logic_vector(7 downto 0);
    variable g : std_logic_vector(7 downto 0);
    variable b : std_logic_vector(7 downto 0);
  begin
    r := v(23 downto 16);
    g := v(15 downto 8);
    b := v(7 downto 0);
    ret(7 downto 6) := "00";
    ret(5 downto 4) := r(7 downto 6);
    ret(3 downto 2) := g(7 downto 6);
    ret(1 downto 0) := b(7 downto 6);
    return ret;
  end function;
  
  attribute MARK_DEBUG of line_counter  : signal is "true";
  attribute MARK_DEBUG of pixel_counter : signal is "true";
  attribute MARK_DEBUG of de_d          : signal is "true";
  attribute MARK_DEBUG of hsync_d       : signal is "true";
  attribute MARK_DEBUG of vsync_d       : signal is "true";
  attribute MARK_DEBUG of din_d         : signal is "true";
  attribute MARK_DEBUG of send_flag     : signal is "true";

  attribute KEEP of line_counter  : signal is "true";
  attribute KEEP of pixel_counter : signal is "true";
  attribute KEEP of de_d          : signal is "true";
  attribute KEEP of hsync_d       : signal is "true";
  attribute KEEP of vsync_d       : signal is "true";
  attribute KEEP of din_d         : signal is "true";
  attribute KEEP of send_flag     : signal is "true";

begin

  process(clk)
    variable d0, d1, d2, d3 : std_logic_vector(23 downto 0);
  begin
    if rising_edge(clk) then
      if reset = '1' then
        line_counter <= (others => '0');
        send_flag    <= '0';
        we           <= '0';
        ctrl_we      <= '0';
      else
        hsync_d <= hsync;
        vsync_d <= vsync;
        de_d    <= de;
        din_d   <= din_d(24*3-1 downto 0) & din;
        
        if vsync_d = '1' and vsync = '0' then
          line_counter <= (others => '0');
        elsif de_d = '1' and de = '0' then
          line_counter  <= line_counter + 1;
        end if;

        if hsync = '1' then
          pixel_counter <= (others => '0');
        elsif de = '1' then
          pixel_counter <= pixel_counter + 1;
        end if;

        if de_d = '0' and de = '1' then
          ctrl_we <= '0';
          if full = '0' then
            send_flag <= '1';
            we        <= '1';
            dout      <= std_logic_vector(line_counter);
          else
            send_flag <= '0';
            we        <= '0';
          end if;
        elsif de_d = '1' and send_flag = '1' then
          ctrl_we <= '0';
          if pixel_counter(1 downto 0) = "00" and pixel_counter <= 1400 then
            we <= '1';
            d0 := din_d(24*4-1 downto 24*3);
            d1 := din_d(24*3-1 downto 24*2);
            d2 := din_d(24*2-1 downto 24*1);
            d3 := din_d(24*1-1 downto 24*0);
            dout(31 downto 24) <= conv24to8(d0);
            dout(23 downto 16) <= conv24to8(d1);
            dout(15 downto  8) <= conv24to8(d2);
            dout( 7 downto  0) <= conv24to8(d3);
          else
            we <= '0';
          end if;
        elsif de_d = '0' and de = '0' then
          if send_flag = '1' then
            ctrl_we <= '1';
            ctrl_dout(127 downto 96) <= X"0a000003";
            ctrl_dout(95 downto 64) <= X"0a000001";
            ctrl_dout(63 downto 32) <= X"40014001";
            if pixel_counter <= 1400 then
              ctrl_dout(31 downto 0) <= std_logic_vector((pixel_counter(31 downto 2)) & "00");
            else
              ctrl_dout(31 downto 0) <= std_logic_vector(to_unsigned(1400, 32));
            end if;
          else
            ctrl_we <= '0';
          end if;
          send_flag <= '0';
          we        <= '0';
        end if;
        
      end if;
    end if;
  end process;
  
end RTL;
