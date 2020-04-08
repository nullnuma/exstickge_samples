library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity top is
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
    TMDS_TX_SDA    : out std_logic;

    TMDS_RX_Clk_p  : in    std_logic;
    TMDS_RX_Clk_n  : in    std_logic;
    TMDS_RX_Data_p : in    std_logic_vector(2 downto 0);
    TMDS_RX_Data_n : in    std_logic_vector(2 downto 0);
    TMDS_RX_HPD    : out   std_logic;
    TMDS_RX_OUT_EN : out   std_logic;
    TMDS_RX_SCL    : inout std_logic;
    TMDS_RX_SDA    : inout std_logic;

    -- ETHER PHY
    GEPHY_TD      : out std_logic_vector(3 downto 0);
    GEPHY_TXEN_ER : out std_logic;
    GEPHY_TCK     : out std_logic;
    GEPHY_RD      : in  std_logic_vector(3 downto 0);
    GEPHY_RCK     : in  std_logic;
    GEPHY_RXDV_ER : in  std_logic;

    GEPHY_MDC   : out   std_logic;
    GEPHY_MDIO  : inout std_logic;
    GEPHY_INT_N : in    std_logic;
    GEPHY_PMEB  : in    std_logic;
    GEPHY_RST_N : out   std_logic;

    -- DDR3
    ddr3_dq      : inout std_logic_vector(7 downto 0);
    ddr3_dqs_p   : inout std_logic_vector(0 downto 0);
    ddr3_dqs_n   : inout std_logic_vector(0 downto 0);
    ddr3_addr    : out   std_logic_vector(13 downto 0);
    ddr3_ba      : out   std_logic_vector(2 downto 0);
    ddr3_ras_n   : out   std_logic;
    ddr3_cas_n   : out   std_logic;
    ddr3_we_n    : out   std_logic;
    ddr3_reset_n : out   std_logic;
    ddr3_ck_p    : out   std_logic_vector(0 downto 0);
    ddr3_ck_n    : out   std_logic_vector(0 downto 0);
    ddr3_cke     : out   std_logic_vector(0 downto 0);
    ddr3_cs_n    : out   std_logic_vector(0 downto 0);
    ddr3_dm      : out   std_logic_vector(0 downto 0);
    ddr3_odt     : out   std_logic_vector(0 downto 0);

    LED : out std_logic_vector(2 downto 0)
    );
end entity top;
  
architecture RTL of top is
  
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

  component dvi2rgb
   Generic (
      kEmulateDDC : boolean := true; --will emulate a DDC EEPROM with basic EDID, if set to yes 
      kRstActiveHigh : boolean := true; --true, if active-high; false, if active-low
      kAddBUFG : boolean := true; --true, if PixelClk should be re-buffered with BUFG 
      kClkRange : natural := 2;  -- MULT_F = kClkRange*5 (choose >=120MHz=1, >=60MHz=2, >=40MHz=3)
      kEdidFileName : string := "900p_edid.data";  -- Select EDID file to use
      -- 7-series specific
      kIDLY_TapValuePs : natural := 78; --delay in ps per tap
      kIDLY_TapWidth : natural := 5); --number of bits for IDELAYE2 tap counter   
   Port (
      -- DVI 1.0 TMDS video interface
      TMDS_Clk_p : in std_logic;
      TMDS_Clk_n : in std_logic;
      TMDS_Data_p : in std_logic_vector(2 downto 0);
      TMDS_Data_n : in std_logic_vector(2 downto 0);
      
      -- Auxiliary signals 
      RefClk : in std_logic; --200 MHz reference clock for IDELAYCTRL, reset, lock monitoring etc.
      aRst : in std_logic; --asynchronous reset; must be reset when RefClk is not within spec
      aRst_n : in std_logic; --asynchronous reset; must be reset when RefClk is not within spec
      
      -- Video out
      vid_pData : out std_logic_vector(23 downto 0);
      vid_pVDE : out std_logic;
      vid_pHSync : out std_logic;
      vid_pVSync : out std_logic;
      
      PixelClk : out std_logic; --pixel-clock recovered from the DVI interface
      
      SerialClk : out std_logic; -- advanced use only; 5x PixelClk
      aPixelClkLckd : out std_logic; -- advanced use only; PixelClk and SerialClk stable
      
      -- Optional DDC port
      DDC_SDA_I : in std_logic;
      DDC_SDA_O : out std_logic;
      DDC_SDA_T : out std_logic;
      DDC_SCL_I : in std_logic;
      DDC_SCL_O : out std_logic; 
      DDC_SCL_T : out std_logic;
      
      pRst : in std_logic; -- synchronous reset; will restart locking procedure
      pRst_n : in std_logic -- synchronous reset; will restart locking procedure
   );
  end component dvi2rgb;

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

  component e7udpip_rgmii_artix7
    port(
      GEPHY_RST_N     : out   std_logic;  -- 
      GEPHY_MAC_CLK   : in    std_logic;  -- 
      GEPHY_MAC_CLK90 : in    std_logic;  -- 
      -- TX out
      GEPHY_TD        : out   std_logic_vector(3 downto 0);  -- 
      GEPHY_TXEN_ER   : out   std_logic;
      GEPHY_TCK       : out   std_logic;  -- 
      -- RX in
      GEPHY_RD        : in    std_logic_vector(3 downto 0);  -- 
      GEPHY_RCK       : in    std_logic;  -- 10M=>2.5MHz, 100M=>25MHz, 1G=>125MHz
      GEPHY_RXDV_ER   : in    std_logic;
      -- Management I/F
      GEPHY_MDC       : out   std_logic;
      GEPHY_MDIO      : inout std_logic;
      GEPHY_INT_N     : in    std_logic;
      
      -- Asynchronous Reset
      Reset_n         : in  std_logic;
      
      -- UPL interface
      pUPLGlobalClk   : in  std_logic;
      
      -- UDP tx input
      pUdp0Send_Data       : in  std_logic_vector( 31 downto 0 );
      pUdp0Send_Request    : in  std_logic;
      pUdp0Send_Ack        : out std_logic;
      pUdp0Send_Enable     : in  std_logic;
      
      pUdp1Send_Data       : in  std_logic_vector( 31 downto 0 );
      pUdp1Send_Request    : in  std_logic;
      pUdp1Send_Ack        : out std_logic;
      pUdp1Send_Enable     : in  std_logic;
      
      -- UDP rx output
      pUdp0Receive_Data       : out std_logic_vector( 31 downto 0 );
      pUdp0Receive_Request    : out std_logic;
      pUdp0Receive_Ack        : in  std_logic;
      pUdp0Receive_Enable     : out std_logic;
      
      pUdp1Receive_Data       : out std_logic_vector( 31 downto 0 );
      pUdp1Receive_Request    : out std_logic;
      pUdp1Receive_Ack        : in  std_logic;
      pUdp1Receive_Enable     : out std_logic;
      
      -- MII interface
      pMIIInput_Data       : in  std_logic_vector( 31 downto 0 );
      pMIIInput_Request    : in  std_logic;
      pMIIInput_Ack        : out std_logic;
      pMIIInput_Enable     : in  std_logic;
      
      pMIIOutput_Data       : out std_logic_vector( 31 downto 0 );
      pMIIOutput_Request    : out std_logic;
      pMIIOutput_Ack        : in  std_logic;
      pMIIOutput_Enable     : out std_logic;
      
      -- Setup
      pMyIpAddr       : in std_logic_vector( 31 downto 0 );
      pMyMacAddr      : in std_logic_vector( 47 downto 0 );
      pMyNetmask      : in std_logic_vector( 31 downto 0 );
      pDefaultGateway : in std_logic_vector( 31 downto 0 );
      pTargetIPAddr   : in std_logic_vector( 31 downto 0 );
      pMyUdpPort0     : in std_logic_vector( 15 downto 0 );
      pMyUdpPort1     : in std_logic_vector( 15 downto 0 );
      pPHYAddr        : in std_logic_vector( 4 downto 0 );
      pPHYMode        : in std_logic_vector( 3 downto 0 );
      pConfig_Core    : in std_logic_vector( 31 downto 0 );
      
      -- Status
      pStatus_RxByteCount             : out std_logic_vector( 31 downto 0 );
      pStatus_RxPacketCount           : out std_logic_vector( 31 downto 0 );
      pStatus_RxErrorPacketCount      : out std_logic_vector( 15 downto 0 );
      pStatus_RxDropPacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxARPRequestPacketCount : out std_logic_vector( 15 downto 0 );
      pStatus_RxARPReplyPacketCount   : out std_logic_vector( 15 downto 0 );
      pStatus_RxICMPPacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxUDP0PacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxUDP1PacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_RxIPErrorPacketCount    : out std_logic_vector( 15 downto 0 );
      pStatus_RxUDPErrorPacketCount   : out std_logic_vector( 15 downto 0 );
      
      pStatus_TxByteCount             : out std_logic_vector( 31 downto 0 );
      pStatus_TxPacketCount           : out std_logic_vector( 31 downto 0 );
      pStatus_TxARPRequestPacketCount : out std_logic_vector( 15 downto 0 );
      pStatus_TxARPReplyPacketCount   : out std_logic_vector( 15 downto 0 );
      pStatus_TxICMPReplyPacketCount  : out std_logic_vector( 15 downto 0 );
      pStatus_TxUDP0PacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_TxUDP1PacketCount       : out std_logic_vector( 15 downto 0 );
      pStatus_TxMulticastPacketCount  : out std_logic_vector( 15 downto 0 );
      
      pStatus_Phy : out std_logic_vector(15 downto 0);
      
      pdebug : out std_logic_vector(63 downto 0)
      );
  end component;

  component mig_7series_0
    port(
      ddr3_dq                   : inout std_logic_vector(7 downto 0);
      ddr3_dqs_p                : inout std_logic_vector(0 downto 0);
      ddr3_dqs_n                : inout std_logic_vector(0 downto 0);
      
      ddr3_addr                 : out   std_logic_vector(13 downto 0);
      ddr3_ba                   : out   std_logic_vector(2 downto 0);
      ddr3_ras_n                : out   std_logic;
      ddr3_cas_n                : out   std_logic;
      ddr3_we_n                 : out   std_logic;
      ddr3_reset_n              : out   std_logic;
      ddr3_ck_p                 : out   std_logic_vector(0 downto 0);
      ddr3_ck_n                 : out   std_logic_vector(0 downto 0);
      ddr3_cke                  : out   std_logic_vector(0 downto 0);
      ddr3_cs_n                 : out   std_logic_vector(0 downto 0);
      ddr3_dm                   : out   std_logic_vector(0 downto 0);
      ddr3_odt                  : out   std_logic_vector(0 downto 0);
      app_addr                  : in    std_logic_vector(27 downto 0);
      app_cmd                   : in    std_logic_vector(2 downto 0);
      app_en                    : in    std_logic;
      app_wdf_data              : in    std_logic_vector(31 downto 0);
      app_wdf_end               : in    std_logic;
      app_wdf_mask              : in    std_logic_vector(3 downto 0);
      app_wdf_wren              : in    std_logic;
      app_rd_data               : out   std_logic_vector(31 downto 0);
      app_rd_data_end           : out   std_logic;
      app_rd_data_valid         : out   std_logic;
      app_rdy                   : out   std_logic;
      app_wdf_rdy               : out   std_logic;
      app_sr_req                : in    std_logic;
      app_ref_req               : in    std_logic;
      app_zq_req                : in    std_logic;
      app_sr_active             : out   std_logic;
      app_ref_ack               : out   std_logic;
      app_zq_ack                : out   std_logic;
      ui_clk                    : out   std_logic;
      ui_clk_sync_rst           : out   std_logic;
      init_calib_complete       : out   std_logic;
      -- System Clock Ports
      sys_clk_i                 : in    std_logic;
      -- Reference Clock Ports
      clk_ref_i                 : in    std_logic;
      device_temp               : out std_logic_vector(11 downto 0);
      sys_rst                   : in std_logic
      );
  end component mig_7series_0;

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

  component dvi_sender
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
  end component dvi_sender;

  component simple_upl32_sender
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
  end component simple_upl32_sender;

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
  
  ------------------------------------------------------------------------------
  -- DVI RX/TX
  ------------------------------------------------------------------------------
  u_e7udpip : e7udpip_rgmii_artix7
    port map(
      -- GMII PHY
      GEPHY_RST_N     => GEPHY_RST_N,
      GEPHY_MAC_CLK   => CLK125M,
      GEPHY_MAC_CLK90 => CLK125M_90,
      -- TX out
      GEPHY_TD        => GEPHY_TD,
      GEPHY_TXEN_ER   => GEPHY_TXEN_ER,
      GEPHY_TCK       => GEPHY_TCK,
      -- RX in
      GEPHY_RD        => GEPHY_RD,
      GEPHY_RCK       => GEPHY_RCK,
      GEPHY_RXDV_ER   => GEPHY_RXDV_ER,

      GEPHY_MDC   => GEPHY_MDC,
      GEPHY_MDIO  => GEPHY_MDIO,
      GEPHY_INT_N => GEPHY_INT_N,

      -- Asynchronous Reset
      Reset_n => CLK_LOCKED,

      -- UPL interface
      pUPLGlobalClk => CLK125M,

      -- UDP tx input
      pUdp0Send_Data    => pUdp0Send_Data,
      pUdp0Send_Request => pUdp0Send_Request,
      pUdp0Send_Ack     => pUdp0Send_Ack,
      pUdp0Send_Enable  => pUdp0Send_Enable,

      pUdp1Send_Data    => pUdp1Send_Data,
      pUdp1Send_Request => pUdp1Send_Request,
      pUdp1Send_Ack     => pUdp1Send_Ack,
      pUdp1Send_Enable  => pUdp1Send_Enable,

      -- UDP rx output
      pUdp0Receive_Data    => pUdp0Receive_Data,
      pUdp0Receive_Request => pUdp0Receive_Request,
      pUdp0Receive_Ack     => pUdp0Receive_Ack,
      pUdp0Receive_Enable  => pUdp0Receive_Enable,

      pUdp1Receive_Data    => pUdp1Receive_Data,
      pUdp1Receive_Request => pUdp1Receive_Request,
      pUdp1Receive_Ack     => pUdp1Receive_Ack,
      pUdp1Receive_Enable  => pUdp1Receive_Enable,

      -- MII interface
      pMIIInput_Data    => pMIIInput_Data,
      pMIIInput_Request => pMIIInput_Request,
      pMIIInput_Ack     => pMIIInput_Ack,
      pMIIInput_Enable  => pMIIInput_Enable,

      pMIIOutput_Data    => pMIIOutput_Data,
      pMIIOutput_Request => pMIIOutput_Request,
      pMIIOutput_Ack     => pMIIOutput_Ack,
      pMIIOutput_Enable  => pMIIOutput_Enable,

      -- Setup
      pMyIpAddr       => X"0a000003",
      pMyMacAddr      => X"001b1affffff",
      pMyNetmask      => X"ff000000",
      pDefaultGateway => X"0a0000fe",
      pTargetIPAddr   => X"0a000001",
      pMyUdpPort0     => X"4000",
      pMyUdpPort1     => X"4001",
      pPHYAddr        => "00001",
      pPHYMode        => "1000",
      pConfig_Core    => X"00000000",

      pStatus_RxByteCount             => open,
      pStatus_RxPacketCount           => open,
      pStatus_RxErrorPacketCount      => open,
      pStatus_RxDropPacketCount       => open,
      pStatus_RxARPRequestPacketCount => open,
      pStatus_RxARPReplyPacketCount   => open,
      pStatus_RxICMPPacketCount       => open,
      pStatus_RxUDP0PacketCount       => open,
      pStatus_RxUDP1PacketCount       => open,
      pStatus_RxIPErrorPacketCount    => open,
      pStatus_RxUDPErrorPacketCount   => open,

      pStatus_TxByteCount             => open,
      pStatus_TxPacketCount           => open,
      pStatus_TxARPRequestPacketCount => open,
      pStatus_TxARPReplyPacketCount   => open,
      pStatus_TxICMPReplyPacketCount  => open,
      pStatus_TxUDP0PacketCount       => open,
      pStatus_TxUDP1PacketCount       => open,
      pStatus_TxMulticastPacketCount  => open,

      pStatus_Phy => status_phy
      );

  pUdp0Send_Data    <= pUdp0Receive_Data;
  pUdp0Send_Request <= pUdp0Receive_Request;
  pUdp0Receive_Ack  <= pUdp0Send_Ack;
  pUdp0Send_Enable  <= pUdp0Receive_Enable;

--  pUdp1Send_Data    <= pUdp1Receive_Data;
--  pUdp1Send_Request <= pUdp1Receive_Request;
--  pUdp1Receive_Ack  <= pUdp1Send_Ack;
--  pUdp1Send_Enable  <= pUdp1Receive_Enable;
  pUdp1Receive_Ack  <= '1';

  pMIIInput_Data    <= X"00000000";
  pMIIInput_Request <= '0';
  pMIIInput_Enable  <= '0';
  pMIIOutput_Ack <= '1';

  U_DVI_SENDER : dvi_sender
    port map(
      clk   => dvi2rgb_pixel_clk,
      reset => dvi2rgb_reset,

      de    => dvi2rgb_de,
      hsync => dvi2rgb_hsync,
      vsync => dvi2rgb_vsync,
      din   => dvi2rgb_data,

      full => simple_upl32_sender_data_full,
      dout => simple_upl32_sender_data_din,
      we   => simple_upl32_sender_data_we,
      
      ctrl_dout => simple_upl32_sender_ctrl_din,
      ctrl_we   => simple_upl32_sender_ctrl_we
      );

  U_UPL_SENDER : simple_upl32_sender
    port map(
      
      clk   => CLK125M,
      reset => reset_CLK125M,
      
      UPL_REQ  => pUdp1Send_Request,
      UPL_ACK  => pUdp1Send_Ack,
      UPL_EN   => pUdp1Send_Enable,
      UPL_DOUT => pUdp1Send_Data,

      data_clk   => dvi2rgb_pixel_clk,
      data_din   => simple_upl32_sender_data_din,
      data_we    => simple_upl32_sender_data_we,
      data_full  => simple_upl32_sender_data_full,

      ctrl_clk   => dvi2rgb_pixel_clk,
      ctrl_din   => simple_upl32_sender_ctrl_din,
      ctrl_we    => simple_upl32_sender_ctrl_we,
      ctrl_full  => simple_upl32_sender_ctrl_full
      );

  u_mig_7series_0 : mig_7series_0
    port map (
      -- Memory interface ports
      ddr3_addr           => ddr3_addr,
      ddr3_ba             => ddr3_ba,
      ddr3_cas_n          => ddr3_cas_n,
      ddr3_ck_n           => ddr3_ck_n,
      ddr3_ck_p           => ddr3_ck_p,
      ddr3_cke            => ddr3_cke,
      ddr3_ras_n          => ddr3_ras_n,
      ddr3_reset_n        => ddr3_reset_n,
      ddr3_we_n           => ddr3_we_n,
      ddr3_dq             => ddr3_dq,
      ddr3_dqs_n          => ddr3_dqs_n,
      ddr3_dqs_p          => ddr3_dqs_p,
      init_calib_complete => init_calib_complete,
      device_temp         => device_temp,
      ddr3_cs_n           => ddr3_cs_n,
      ddr3_dm             => ddr3_dm,
      ddr3_odt            => ddr3_odt,

      -- Application interface ports
      app_addr          => app_addr,
      app_cmd           => app_cmd,
      app_en            => app_en,
      app_wdf_data      => app_wdf_data,
      app_wdf_end       => app_wdf_end,
      app_wdf_wren      => app_wdf_wren,
      app_rd_data       => app_rd_data,
      app_rd_data_end   => app_rd_data_end,
      app_rd_data_valid => app_rd_data_valid,
      app_rdy           => app_rdy,
      app_wdf_rdy       => app_wdf_rdy,
      app_sr_req        => '0',
      app_ref_req       => '0',
      app_zq_req        => '0',
      app_sr_active     => app_sr_active,
      app_ref_ack       => app_ref_ack,
      app_zq_ack        => app_zq_ack,
      ui_clk            => ui_clk,
      ui_clk_sync_rst   => ui_clk_sync_rst,
      app_wdf_mask      => app_wdf_mask,

      -- System Clock Ports
      sys_clk_i => CLK310M,
      -- Reference Clock Ports
      clk_ref_i => CLK200M,
      sys_rst   => sys_rst_i
      );
  
  sys_rst_i <= CLK_LOCKED;
  
end RTL;
