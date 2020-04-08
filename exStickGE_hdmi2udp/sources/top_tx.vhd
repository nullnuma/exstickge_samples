library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity top_tx is
  port (
    SYS_CLK_P : in std_logic;
    SYS_CLK_N : in std_logic;
    sys_rst   : in std_logic;

    -- HDMI
    TMDS_TX_Clk_p  : out std_logic;
    TMDS_TX_Clk_n  : out std_logic;
    TMDS_TX_Data_p : out std_logic_vector(2 downto 0);
    TMDS_TX_Data_n : out std_logic_vector(2 downto 0);
    TMDS_TX_HPD    : in  std_logic;
    TMDS_TX_OUT_EN : out std_logic;
    TMDS_TX_SCL    : out std_logic;
    TMDS_TX_SDA    : out std_logic

    LED : out std_logic_vector(2 downto 0)
    );
end entity top_tx;
  
architecture RTL of top_tx is
  
  attribute MARK_DEBUG : string;
  attribute KEEP : string;

  component rgb2dvi
    Generic (
      kGenerateSerialClk : boolean := true;
      kClkPrimitive      : string  := "PLL";  -- "MMCM" or "PLL" to instantiate, if kGenerateSerialClk true
      kClkRange          : natural := 1;      -- MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)      
      kRstActiveHigh     : boolean := true;   --true, if active-high; false, if active-low
      kD0Swap            : boolean := false;  -- P/N Swap Options
      kD1Swap            : boolean := false;
      kD2Swap            : boolean := false;
      kClkSwap           : boolean := false); 
    Port (
      -- DVI 1.0 TMDS video interface
      TMDS_Clk_p  : out std_logic;
      TMDS_Clk_n  : out std_logic;
      TMDS_Data_p : out std_logic_vector(2 downto 0);
      TMDS_Data_n : out std_logic_vector(2 downto 0);

      -- Auxiliary signals 
      aRst   : in std_logic;  --asynchronous reset; must be reset when RefClk is not within spec
      aRst_n : in std_logic;  --asynchronous reset; must be reset when RefClk is not within spec

      -- Video in
      vid_pData  : in std_logic_vector(23 downto 0);
      vid_pVDE   : in std_logic;
      vid_pHSync : in std_logic;
      vid_pVSync : in std_logic;
      PixelClk   : in std_logic;  --pixel-clock recovered from the DVI interface

      SerialClk : in std_logic); -- 5x PixelClk
  end component rgb2dvi;

  component clk_wiz_0
    port (
      clk_out1 : out STD_LOGIC;
      clk_out2 : out STD_LOGIC;
      reset    : in  STD_LOGIC;
      locked   : out STD_LOGIC;
      clk_in1  : in  STD_LOGIC
      );
  end component clk_wiz_0;

  component clk_wiz_1
    port (
      clk_out1 : out STD_LOGIC;
      clk_out2 : out STD_LOGIC;
      clk_out3 : out STD_LOGIC;
      clk_out4 : out STD_LOGIC;
      reset    : in  STD_LOGIC;
      locked   : out STD_LOGIC;
      clk_in1  : in  STD_LOGIC
      );
  end component clk_wiz_1;

  component reset_counter
    generic (
      RESET_COUNT : integer := 1000
      );
    port (
      clk     : in  std_logic;
      reset_i : in  std_logic;
      reset_o : out std_logic := '0'
      );
  end component reset_counter;

  component heartbeat
    generic(
      INDEX : integer := 24
      );
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      q     : out std_logic
      );
  end component heartbeat;

  signal RESET : std_logic;
  signal nRESET : std_logic;
  
  signal GCLK_LOCKED : std_logic := '0';
  signal CLK_LOCKED  : std_logic := '0';
  signal CLK310M     : std_logic;
  signal CLK200M     : std_logic;
  signal CLK125M     : std_logic;
  signal CLK125M_90  : std_logic;
  signal CLK65M      : std_logic;
  
  signal reset_CLK200M       : std_logic := '0';
  signal reset_CLK125M       : std_logic := '0';
  signal reset_CLK65M        : std_logic := '0';

  signal rgb2dvi_data      : std_logic_vector(23 downto 0);
  signal rgb2dvi_en        : std_logic := '0';
  signal rgb2dvi_hsync     : std_logic;
  signal rgb2dvi_vsync     : std_logic;
  signal rgb2dvi_pixel_clk : std_logic;
  signal rgb2dvi_reset     : std_logic;

  signal dvi2rgb_data       : std_logic_vector(23 downto 0);
  signal dvi2rgb_de         : std_logic;
  signal dvi2rgb_hsync      : std_logic;
  signal dvi2rgb_vsync      : std_logic;
  signal dvi2rgb_pixel_clk  : std_logic;
  signal dvi2rgb_serial_clk : std_logic;
  signal dvi2rgb_clk_locked : std_logic;
  signal dvi2rgb_reset      : std_logic;
  
  signal dvi2rgb_ddc_sda_i  : std_logic;
  signal dvi2rgb_ddc_sda_o  : std_logic;
  signal dvi2rgb_ddc_sda_t  : std_logic;
  signal dvi2rgb_ddc_scl_i  : std_logic;
  signal dvi2rgb_ddc_scl_o  : std_logic;
  signal dvi2rgb_ddc_scl_t  : std_logic;
  
  attribute MARK_DEBUG of dvi2rgb_data  : signal is "true";
  attribute MARK_DEBUG of dvi2rgb_de    : signal is "true";
  attribute MARK_DEBUG of dvi2rgb_hsync : signal is "true";
  attribute MARK_DEBUG of dvi2rgb_vsync : signal is "true";

  attribute KEEP of dvi2rgb_data  : signal is "true";
  attribute KEEP of dvi2rgb_de    : signal is "true";
  attribute KEEP of dvi2rgb_hsync : signal is "true";
  attribute KEEP of dvi2rgb_vsync : signal is "true";
  
  signal pUdp0Send_Data       : std_logic_vector( 31 downto 0 );
  signal pUdp0Send_Request    : std_logic;
  signal pUdp0Send_Ack        : std_logic;
  signal pUdp0Send_Enable     : std_logic;

  signal pUdp1Send_Data       : std_logic_vector( 31 downto 0 );
  signal pUdp1Send_Request    : std_logic;
  signal pUdp1Send_Ack        : std_logic;
  signal pUdp1Send_Enable     : std_logic;

  -- UDP rx output
  signal pUdp0Receive_Data    : std_logic_vector( 31 downto 0 );
  signal pUdp0Receive_Request : std_logic;
  signal pUdp0Receive_Ack     : std_logic;
  signal pUdp0Receive_Enable  : std_logic;

  signal pUdp1Receive_Data    : std_logic_vector( 31 downto 0 );
  signal pUdp1Receive_Request : std_logic;
  signal pUdp1Receive_Ack     : std_logic;
  signal pUdp1Receive_Enable  : std_logic;

  -- MII interface
  signal pMIIInput_Data       : std_logic_vector( 31 downto 0 );
  signal pMIIInput_Request    : std_logic;
  signal pMIIInput_Ack        : std_logic;
  signal pMIIInput_Enable     : std_logic;

  signal pMIIOutput_Data      : std_logic_vector( 31 downto 0 );
  signal pMIIOutput_Request   : std_logic;
  signal pMIIOutput_Ack       : std_logic;
  signal pMIIOutput_Enable    : std_logic;
  
  signal status_phy : std_logic_vector(15 downto 0);

  signal simple_upl32_sender_data_din  : std_logic_vector(31 downto 0);
  signal simple_upl32_sender_data_we   : std_logic;
  signal simple_upl32_sender_data_full : std_logic;

  signal simple_upl32_sender_ctrl_din  : std_logic_vector(127 downto 0);
  signal simple_upl32_sender_ctrl_we   : std_logic;
  signal simple_upl32_sender_ctrl_full : std_logic;

  attribute MARK_DEBUG of simple_upl32_sender_data_din  : signal is "true";
  attribute MARK_DEBUG of simple_upl32_sender_data_we   : signal is "true";
  attribute MARK_DEBUG of simple_upl32_sender_data_full : signal is "true";

  attribute KEEP of simple_upl32_sender_data_din  : signal is "true";
  attribute KEEP of simple_upl32_sender_data_we   : signal is "true";
  attribute KEEP of simple_upl32_sender_data_full : signal is "true";

  attribute MARK_DEBUG of simple_upl32_sender_ctrl_din  : signal is "true";
  attribute MARK_DEBUG of simple_upl32_sender_ctrl_we   : signal is "true";
  attribute MARK_DEBUG of simple_upl32_sender_ctrl_full : signal is "true";

  attribute KEEP of simple_upl32_sender_ctrl_din  : signal is "true";
  attribute KEEP of simple_upl32_sender_ctrl_we   : signal is "true";
  attribute KEEP of simple_upl32_sender_ctrl_full : signal is "true";

  attribute MARK_DEBUG of pUdp1Send_Data    : signal is "true";
  attribute MARK_DEBUG of pUdp1Send_Request : signal is "true";
  attribute MARK_DEBUG of pUdp1Send_Ack     : signal is "true";
  attribute MARK_DEBUG of pUdp1Send_Enable  : signal is "true";

  attribute KEEP of pUdp1Send_Data    : signal is "true";
  attribute KEEP of pUdp1Send_Request : signal is "true";
  attribute KEEP of pUdp1Send_Ack     : signal is "true";
  attribute KEEP of pUdp1Send_Enable  : signal is "true";

  signal app_addr            : std_logic_vector(27 downto 0) := (others => '0');
  signal app_cmd             : std_logic_vector(2 downto 0)  := (others => '0');
  signal app_en              : std_logic                     := '0';
  signal app_wdf_data        : std_logic_vector(31 downto 0) := (others => '0');
  signal app_wdf_end         : std_logic                     := '0';
  signal app_wdf_mask        : std_logic_vector(3 downto 0)  := (others => '0');
  signal app_wdf_wren        : std_logic                     := '0';
  signal app_rd_data         : std_logic_vector(31 downto 0) := (others => '0');
  signal app_rd_data_end     : std_logic                     := '0';
  signal app_rd_data_valid   : std_logic                     := '0';
  signal app_rdy             : std_logic                     := '0';
  signal app_wdf_rdy         : std_logic                     := '0';
  signal app_sr_req          : std_logic                     := '0';
  signal app_ref_req         : std_logic                     := '0';
  signal app_zq_req          : std_logic                     := '0';
  signal app_sr_active       : std_logic                     := '0';
  signal app_ref_ack         : std_logic                     := '0';
  signal app_zq_ack          : std_logic                     := '0';
  signal init_calib_complete : std_logic                     := '0';
  signal device_temp         : std_logic_vector(11 downto 0) := (others => '0');
  signal ui_clk              : std_logic                     := '0';
  signal ui_clk_sync_rst     : std_logic                     := '0';

  attribute KEEP of init_calib_complete : signal is "true";
  attribute KEEP of device_temp         : signal is "true";
  
  attribute MARK_DEBUG of init_calib_complete : signal is "true";
  attribute MARK_DEBUG of device_temp         : signal is "true";

  signal SYS_CLK   : std_logic;
  signal sys_rst_i : std_logic;

begin

  ------------------------------------------------------------------------------
  -- System Common
  ------------------------------------------------------------------------------
  nRESET <= sys_rst;
  RESET  <= not nRESET;

  TMDS_RX_OUT_EN <= '0';
  TMDS_RX_HPD    <= '1';

  TMDS_TX_OUT_EN <= '1';
  TMDS_TX_SCL    <= '1';
  TMDS_TX_SDA    <= '1';

  u_ibufds : IBUFDS
    port map (
      O  => SYS_CLK,
      I  => SYS_CLK_P,
      IB => SYS_CLK_N
      );

  u_clk_wiz_0 : clk_wiz_0
  port map(
    clk_out1 => CLK310M,
    clk_out2 => open,
    locked   => GCLK_LOCKED,
    reset    => RESET,
    clk_in1  => SYS_CLK
    );

  u_clk_wiz_1 : clk_wiz_1
    port map(
      clk_out1 => CLK200M,
      clk_out2 => CLK125M,
      clk_out3 => CLK125M_90,
      clk_out4 => CLK65M,
      reset    => RESET,
      locked   => CLK_LOCKED,
      clk_in1  => SYS_CLK
      );

  RESET_COUNTER_200M : reset_counter
    generic map( RESET_COUNT => 1000 )
    port map( clk => CLK200M, reset_i => RESET, reset_o => reset_CLK200M);
  RESET_COUNTER_125M : reset_counter
    generic map( RESET_COUNT => 1000 )
    port map( clk => CLK125M, reset_i => RESET, reset_o => reset_CLK125M);
  RESET_COUNTER_65M : reset_counter
    generic map( RESET_COUNT => 1000 )
    port map( clk => CLK65M, reset_i => RESET, reset_o => reset_CLK65M);

  HEARTBEAT_65M : heartbeat
    generic map(INDEX => 24)
    port map(clk => CLK200M, reset => reset_CLK200M, q => LED(2));
  HEARTBEAT_PIXEL_CLK : heartbeat
    generic map(INDEX => 24)
    port map(clk => rgb2dvi_pixel_clk, reset => rgb2dvi_reset, q => LED(1));
  LED(0) <= '0';

  ------------------------------------------------------------------------------
  -- DVI RX/TX
  ------------------------------------------------------------------------------
  U_RGB2DVI : rgb2dvi
    generic map(
      kClkRange => 2  -- MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)      
      )
    port map(
      -- DVI 1.0 TMDS video interface
      TMDS_Clk_p  => TMDS_TX_CLK_p,
      TMDS_Clk_n  => TMDS_TX_Clk_n,
      TMDS_Data_p => TMDS_TX_Data_p,
      TMDS_Data_n => TMDS_TX_Data_n,

      -- Auxiliary signals 
      aRst   => rgb2dvi_reset,
      aRst_n => not rgb2dvi_reset,

      -- Video in
      vid_pData  => rgb2dvi_data,
      vid_pVDE   => rgb2dvi_en,
      vid_pHSync => rgb2dvi_hsync,
      vid_pVSync => rgb2dvi_vsync,
      PixelClk   => rgb2dvi_pixel_clk,
      
      -- Video in
      SerialClk => '0'
      );
  
  rgb2dvi_data      <= dvi2rgb_data;
  rgb2dvi_en        <= dvi2rgb_de;
  rgb2dvi_hsync     <= dvi2rgb_hsync;
  rgb2dvi_vsync     <= dvi2rgb_vsync;
  rgb2dvi_pixel_clk <= dvi2rgb_pixel_clk;

  RESET_RGB2DVI : reset_counter
    generic map(RESET_COUNT => 120000000)
    --port map(clk => rgb2dvi_pixel_clk, reset_i => not TMDS_TX_HPD, reset_o => rgb2dvi_reset);
    port map(clk => rgb2dvi_pixel_clk, reset_i => not CLK_LOCKED, reset_o => rgb2dvi_reset);

  U_DVI2RGB : dvi2rgb
    Generic map(
      kEmulateDDC      => true,  --will emulate a DDC EEPROM with basic EDID, if set to yes 
      kRstActiveHigh   => true,  --true, if active-high; false, if active-low
      kAddBUFG         => true,  --true, if PixelClk should be re-buffered with BUFG 
      kClkRange        => 2,  -- MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)
      kEdidFileName    => "900p_edid.data",  -- Select EDID file to use
      -- 7-series specific
      kIDLY_TapValuePs => 78,  --delay in ps per tap
      kIDLY_TapWidth   => 5    --number of bits for IDELAYE2 tap counter   
      ) 
    Port map(
      -- DVI 1.0 TMDS video interface
      TMDS_Clk_p  => TMDS_RX_Clk_p,
      TMDS_Clk_n  => TMDS_RX_Clk_n,
      TMDS_Data_p => TMDS_RX_Data_p,
      TMDS_Data_n => TMDS_RX_Data_n,

      -- Auxiliary signals 
      RefClk => CLK200M,
      aRst   => reset_CLK200M,
      aRst_n => not reset_CLK200M,

      -- Video out
      vid_pData  => dvi2rgb_data,
      vid_pVDE   => dvi2rgb_de,
      vid_pHSync => dvi2rgb_hsync,
      vid_pVSync => dvi2rgb_vsync,
      PixelClk   => dvi2rgb_pixel_clk,

      SerialClk     => dvi2rgb_serial_clk,
      aPixelClkLckd => dvi2rgb_clk_locked,

      -- Optional DDC port
      DDC_SDA_I => dvi2rgb_ddc_sda_i,
      DDC_SDA_O => dvi2rgb_ddc_sda_o,
      DDC_SDA_T => dvi2rgb_ddc_sda_t,
      DDC_SCL_I => dvi2rgb_ddc_scl_i,
      DDC_SCL_O => dvi2rgb_ddc_scl_o,
      DDC_SCL_T => dvi2rgb_ddc_scl_t,

      pRst   => reset_CLK200M,
      pRst_n => not reset_CLK200M
      );
  DVI2RGB_RESET_COUNTER : reset_counter
    generic map( RESET_COUNT => 1000 )
    port map( clk => dvi2rgb_pixel_clk, reset_i => not CLK_LOCKED, reset_o => dvi2rgb_reset);

  i_scl : IOBUF
    generic map (DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
    port map (O => dvi2rgb_ddc_scl_i, IO => TMDS_RX_SCL, I => dvi2rgb_ddc_scl_o, T => dvi2rgb_ddc_scl_t);

  i_sda : IOBUF
    generic map (DRIVE => 12, IOSTANDARD => "DEFAULT", SLEW => "SLOW")
    port map (O => dvi2rgb_ddc_sda_i, IO => TMDS_RX_SDA, I => dvi2rgb_ddc_sda_o, T => dvi2rgb_ddc_sda_t);
  
end RTL;
