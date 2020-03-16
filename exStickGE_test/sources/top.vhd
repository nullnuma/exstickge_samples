library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity top is
  port (
    
    -- DDR3
    -- Inouts
    ddr3_dq    : inout std_logic_vector(7 downto 0);
    ddr3_dqs_p : inout std_logic_vector(0 downto 0);
    ddr3_dqs_n : inout std_logic_vector(0 downto 0);
    
    -- Outputs
    ddr3_addr    : out std_logic_vector(13 downto 0);
    ddr3_ba      : out std_logic_vector(2 downto 0);
    ddr3_ras_n   : out std_logic;
    ddr3_cas_n   : out std_logic;
    ddr3_we_n    : out std_logic;
    ddr3_reset_n : out std_logic;
    ddr3_ck_p    : out std_logic_vector(0 downto 0);
    ddr3_ck_n    : out std_logic_vector(0 downto 0);
    ddr3_cke     : out std_logic_vector(0 downto 0);
    ddr3_cs_n    : out std_logic_vector(0 downto 0);
    ddr3_dm      : out std_logic_vector(0 downto 0);
    ddr3_odt     : out std_logic_vector(0 downto 0);
    
    -- ETHER PHY
    GEPHY_TD      : out   std_logic_vector(3 downto 0);
    GEPHY_TXEN_ER : out   std_logic;
    GEPHY_TCK     : out   std_logic;
    GEPHY_RD      : in    std_logic_vector(3 downto 0);
    GEPHY_RCK     : in    std_logic; 
    GEPHY_RXDV_ER : in    std_logic;
    GEPHY_MAC_CLK : in    std_logic;
    
    GEPHY_MDC     : out   std_logic;
    GEPHY_MDIO    : inout std_logic;
    GEPHY_INT_N   : in    std_logic;
    GEPHY_PMEB    : in  std_logic;
    GEPHY_RST_N   : out std_logic;
    
    -- GPIO
    GPIO00 : inout std_logic;
    GPIO01 : inout std_logic;
    GPIO02 : inout std_logic;
    GPIO03 : inout std_logic;
    GPIO04 : inout std_logic;
    GPIO05 : inout std_logic;
    GPIO06 : inout std_logic;
    GPIO07 : inout std_logic;
    GPIO10 : inout std_logic;
    GPIO11 : inout std_logic;
    GPIO12 : inout std_logic;
    GPIO13 : inout std_logic;
    
    GPIO14 : inout std_logic;
    GPIO15 : inout std_logic;
    
    GPIO20 : inout std_logic;
    GPIO21 : inout std_logic;
    GPIO22 : inout std_logic;
    GPIO23 : inout std_logic;
    GPIO24 : inout std_logic;
    GPIO25 : inout std_logic;
    GPIO26 : inout std_logic;
    GPIO27 : inout std_logic;
    GPIO30 : inout std_logic;
    GPIO31 : inout std_logic;
    GPIO32 : inout std_logic;
    GPIO33 : inout std_logic;
    GPIO34 : inout std_logic;
    GPIO35 : inout std_logic;
    
    GPIO40 : inout std_logic;
    GPIO41 : inout std_logic;
    GPIO42 : inout std_logic;
    GPIO43 : inout std_logic;
    GPIO44 : inout std_logic;
    GPIO45 : inout std_logic;
    GPIO46 : inout std_logic;
    GPIO47 : inout std_logic;
    GPIO50 : inout std_logic;
    GPIO51 : inout std_logic;
    GPIO52 : inout std_logic;
    GPIO53 : inout std_logic;
    
    GPIO54 : inout std_logic;
    GPIO55 : inout std_logic;
    
    GPIO60 : inout std_logic;
    GPIO61 : inout std_logic;
    GPIO62 : inout std_logic;
    GPIO63 : inout std_logic;
    GPIO64 : inout std_logic;
    GPIO65 : inout std_logic;
    GPIO66 : inout std_logic;
    GPIO67 : inout std_logic;
    GPIO70 : inout std_logic;
    GPIO71 : inout std_logic;
    GPIO72 : inout std_logic;
    GPIO73 : inout std_logic;
    GPIO74 : inout std_logic;
    GPIO75 : inout std_logic;
    
    HDMI0_D0_P : inout std_logic;
    HDMI0_D0_N : inout std_logic;
    HDMI0_D1_P : inout std_logic;
    HDMI0_D1_N : inout std_logic;
    HDMI0_D2_P : inout std_logic;
    HDMI0_D2_N : inout std_logic;
    HDMI0_SCL  : inout std_logic;
    HDMI0_SDA  : inout std_logic;
    HDMI0_CLK_P : inout std_logic;
    HDMI0_CLK_N : inout std_logic;
    
    HDMI1_D0_P : inout std_logic;
    HDMI1_D0_N : inout std_logic;
    HDMI1_D1_P : inout std_logic;
    HDMI1_D1_N : inout std_logic;
    HDMI1_D2_P : inout std_logic;
    HDMI1_D2_N : inout std_logic;
    HDMI1_SCL  : inout std_logic;
    HDMI1_SDA  : inout std_logic;
    HDMI1_CLK_P : inout std_logic;
    HDMI1_CLK_N : inout std_logic;
    
    Pmod : inout std_logic_vector(4 downto 1);
    
    -- DEBUG
    led0 : out std_logic;
    led1 : out std_logic;
    led2 : out std_logic;
    
    -- Single-ended system clock
    sys_clk_p : in std_logic;
    sys_clk_n : in std_logic;
    sys_rst_n : in std_logic
    );

end entity top;

architecture RTL of top is

  component mig_7series_0
    port(
      ddr3_dq    : inout std_logic_vector(7 downto 0);
      ddr3_dqs_p : inout std_logic_vector(0 downto 0);
      ddr3_dqs_n : inout std_logic_vector(0 downto 0);

      ddr3_addr    : out std_logic_vector(13 downto 0);
      ddr3_ba      : out std_logic_vector(2 downto 0);
      ddr3_ras_n   : out std_logic;
      ddr3_cas_n   : out std_logic;
      ddr3_we_n    : out std_logic;
      ddr3_reset_n : out std_logic;
      ddr3_ck_p    : out std_logic_vector(0 downto 0);
      ddr3_ck_n    : out std_logic_vector(0 downto 0);
      ddr3_cke     : out std_logic_vector(0 downto 0);
      ddr3_cs_n    : out std_logic_vector(0 downto 0);
      ddr3_dm      : out std_logic_vector(0 downto 0);
      ddr3_odt     : out std_logic_vector(0 downto 0);

      app_sr_req    : in  std_logic;
      app_ref_req   : in  std_logic;
      app_zq_req    : in  std_logic;
      app_sr_active : out std_logic;
      app_ref_ack   : out std_logic;
      app_zq_ack    : out std_logic;

      s_axi_awid    : in  std_logic_vector(4-1 downto 0);
      s_axi_awaddr  : in  std_logic_vector(32-1 downto 0);
      s_axi_awlen   : in  std_logic_vector(7 downto 0);
      s_axi_awsize  : in  std_logic_vector(2 downto 0);
      s_axi_awburst : in  std_logic_vector(1 downto 0);
      s_axi_awlock  : in  std_logic_vector(0 downto 0);
      s_axi_awcache : in  std_logic_vector(3 downto 0);
      s_axi_awprot  : in  std_logic_vector(2 downto 0);
      s_axi_awqos   : in  std_logic_vector(3 downto 0);
      s_axi_awvalid : in  std_logic;
      s_axi_awready : out std_logic;
      s_axi_wdata   : in  std_logic_vector(32-1 downto 0);
      s_axi_wstrb   : in  std_logic_vector((32/8)-1 downto 0);
      s_axi_wlast   : in  std_logic;
      s_axi_wvalid  : in  std_logic;
      s_axi_wready  : out std_logic;
      -- Slave Interface Write Response Ports
      s_axi_bready  : in  std_logic;
      s_axi_bid     : out std_logic_vector(4-1 downto 0);
      s_axi_bresp   : out std_logic_vector(1 downto 0);
      s_axi_bvalid  : out std_logic;
      -- Slave Interface Read Address Ports
      s_axi_arid    : in  std_logic_vector(4-1 downto 0);
      s_axi_araddr  : in  std_logic_vector(32-1 downto 0);
      s_axi_arlen   : in  std_logic_vector(7 downto 0);
      s_axi_arsize  : in  std_logic_vector(2 downto 0);
      s_axi_arburst : in  std_logic_vector(1 downto 0);
      s_axi_arlock  : in  std_logic_vector(0 downto 0);
      s_axi_arcache : in  std_logic_vector(3 downto 0);
      s_axi_arprot  : in  std_logic_vector(2 downto 0);
      s_axi_arqos   : in  std_logic_vector(3 downto 0);
      s_axi_arvalid : in  std_logic;
      s_axi_arready : out std_logic;
      -- Slave Interface Read Data Ports
      s_axi_rready  : in  std_logic;
      s_axi_rid     : out std_logic_vector(4-1 downto 0);
      s_axi_rdata   : out std_logic_vector(32-1 downto 0);
      s_axi_rresp   : out std_logic_vector(1 downto 0);
      s_axi_rlast   : out std_logic;
      s_axi_rvalid  : out std_logic;

      ui_clk              : out std_logic;
      ui_clk_sync_rst     : out std_logic;
      mmcm_locked         : out std_logic;
      init_calib_complete : out std_logic;
      aresetn             : in  std_logic;
      -- System Clock Ports
      sys_clk_i           : in  std_logic;
      -- Reference Clock Ports
      clk_ref_i           : in  std_logic;
      device_temp         : out std_logic_vector(11 downto 0);
      sys_rst             : in  std_logic
      );
  end component mig_7series_0;

  component clk_wiz_0
    port(
      clk_out1 : out std_logic;
      clk_out2 : out std_logic;
      locked   : out std_logic;
      reset    : in  std_logic;
      clk_in1  : in  std_logic
      );
  end component clk_wiz_0;
  
  component clk_wiz_1
    port(
      -- Clock in ports
      -- Clock out ports
      clk_out1 : out std_logic;
      clk_out2 : out std_logic;
      clk_out3 : out std_logic;
      -- Status and control signals
      reset    : in  std_logic;
      locked   : out std_logic;
      clk_in1  : in  std_logic
      );
  end component;

  -- Signal declarations

  signal sys_clk : std_logic;
  
  signal init_calib_complete : std_logic;

  signal clk : std_logic;
  signal rst : std_logic;

  signal device_temp : std_logic_vector(11 downto 0);
  
  signal locked_i                   : std_logic;
  signal clk310M                    : std_logic;

  -- ETHER TEST
  component e7udpip_rgmii_artix7
    port(
      GEPHY_RST_N     : out   std_logic;
      GEPHY_MAC_CLK   : in    std_logic;
      GEPHY_MAC_CLK90 : in    std_logic;
      -- TX out
      GEPHY_TD        : out   std_logic_vector(3 downto 0);
      GEPHY_TXEN_ER   : out   std_logic;
      GEPHY_TCK       : out   std_logic;
      -- RX in
      GEPHY_RD        : in    std_logic_vector(3 downto 0);
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
      pUdp0Send_Data    : in  std_logic_vector(31 downto 0);
      pUdp0Send_Request : in  std_logic;
      pUdp0Send_Ack     : out std_logic;
      pUdp0Send_Enable  : in  std_logic;
      
      pUdp1Send_Data    : in  std_logic_vector(31 downto 0);
      pUdp1Send_Request : in  std_logic;
      pUdp1Send_Ack     : out std_logic;
      pUdp1Send_Enable  : in  std_logic;
      
      -- UDP rx output
      pUdp0Receive_Data    : out std_logic_vector(31 downto 0);
      pUdp0Receive_Request : out std_logic;
      pUdp0Receive_Ack     : in  std_logic;
      pUdp0Receive_Enable  : out std_logic;
      
      pUdp1Receive_Data    : out std_logic_vector(31 downto 0);
      pUdp1Receive_Request : out std_logic;
      pUdp1Receive_Ack     : in  std_logic;
      pUdp1Receive_Enable  : out std_logic;
      
      -- MII interface
      pMIIInput_Data    : in  std_logic_vector(31 downto 0);
      pMIIInput_Request : in  std_logic;
      pMIIInput_Ack     : out std_logic;
      pMIIInput_Enable  : in  std_logic;
      
      pMIIOutput_Data    : out std_logic_vector(31 downto 0);
      pMIIOutput_Request : out std_logic;
      pMIIOutput_Ack     : in  std_logic;
      pMIIOutput_Enable  : out std_logic;
      
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

  signal pEtherSend0_Data    : std_logic_vector(31 downto 0);
  signal pEtherSend0_Request : std_logic;
  signal pEtherSend0_Ack     : std_logic;
  signal pEtherSend0_Enable  : std_logic;

  signal pEtherReceive_Data    : std_logic_vector(7 downto 0);
  signal pEtherReceive_Request : std_logic;
  signal pEtherReceive_Ack     : std_logic;
  signal pEtherReceive_Enable  : std_logic;
  
  signal reset_n    : std_logic;
  signal clk200M    : std_logic;
  signal clk125M    : std_logic;
  signal clk125M_90 : std_logic;
  signal locked     : std_logic;
  signal reset125M  : std_logic := '1';

  signal pUdp0Send_Data    : std_logic_vector(31 downto 0);
  signal pUdp0Send_Request : std_logic;
  signal pUdp0Send_Ack     : std_logic;
  signal pUdp0Send_Enable  : std_logic;

  signal pUdp1Send_Data    : std_logic_vector(31 downto 0);
  signal pUdp1Send_Request : std_logic;
  signal pUdp1Send_Ack     : std_logic;
  signal pUdp1Send_Enable  : std_logic;

  -- UDP rx output
  signal pUdp0Receive_Data    : std_logic_vector(31 downto 0);
  signal pUdp0Receive_Request : std_logic;
  signal pUdp0Receive_Ack     : std_logic;
  signal pUdp0Receive_Enable  : std_logic;

  signal pUdp1Receive_Data    : std_logic_vector( 31 downto 0 );
  signal pUdp1Receive_Request : std_logic;
  signal pUdp1Receive_Ack     : std_logic;
  signal pUdp1Receive_Enable  : std_logic;

  -- MII interface
  signal pMIIInput_Data    : std_logic_vector(31 downto 0);
  signal pMIIInput_Request : std_logic;
  signal pMIIInput_Ack     : std_logic;
  signal pMIIInput_Enable  : std_logic;

  signal pMIIOutput_Data    : std_logic_vector(31 downto 0);
  signal pMIIOutput_Request : std_logic;
  signal pMIIOutput_Ack     : std_logic;
  signal pMIIOutput_Enable  : std_logic;

  signal status_phy : std_logic_vector(15 downto 0);

  signal counter_clk125 : unsigned(31 downto 0) := (others => '0');

  constant C_S_AXI_ID_WIDTH : integer := 4;
                                        -- Width of all master and slave ID signals.
                                        -- # = >= 1.
  constant C_S_AXI_ADDR_WIDTH : integer := 32;
                                        -- Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                        -- M_AXI_ARADDR for all SI/MI slots.
                                        -- # = 32.
  constant C_S_AXI_DATA_WIDTH : integer := 32;
                                        -- Width of WDATA and RDATA on SI slot.
                                        -- Must be <= APP_DATA_WIDTH.
                                        -- # = 32, 64, 128, 256.
  constant C_S_AXI_SUPPORTS_NARROW_BURST : integer := 0;
                                        -- Indicates whether to instatiate upsizer
                                        -- Range: 0, 1

  signal s_axi_awid    : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_awaddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_awlen   : std_logic_vector(7 downto 0) := (others => '0');
  signal s_axi_awsize  : std_logic_vector(2 downto 0) := (others => '0');
  signal s_axi_awburst : std_logic_vector(1 downto 0) := (others => '0');
  signal s_axi_awlock  : std_logic_vector(0 downto 0) := (others => '0');
  signal s_axi_awcache : std_logic_vector(3 downto 0) := (others => '0');
  signal s_axi_awprot  : std_logic_vector(2 downto 0) := (others => '0');
  signal s_axi_awvalid : std_logic := '0';
  signal s_axi_awready : std_logic := '0';
  signal s_axi_wdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_wstrb   : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0) := (others => '0');
  signal s_axi_wlast   : std_logic := '0';
  signal s_axi_wvalid  : std_logic := '0';
  signal s_axi_wready  : std_logic := '0';
  -- Slave Interface Write Response Ports
  signal s_axi_bready  : std_logic := '0';
  signal s_axi_bid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_bresp   : std_logic_vector(1 downto 0) := (others => '0');
  signal s_axi_bvalid  : std_logic := '0';
  -- Slave Interface Read Address Ports
  signal s_axi_arid    : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_araddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_arlen   : std_logic_vector(7 downto 0) := (others => '0');
  signal s_axi_arsize  : std_logic_vector(2 downto 0) := (others => '0');
  signal s_axi_arburst : std_logic_vector(1 downto 0) := (others => '0');
  signal s_axi_arlock  : std_logic_vector(0 downto 0) := (others => '0');
  signal s_axi_arcache : std_logic_vector(3 downto 0) := (others => '0');
  signal s_axi_arprot  : std_logic_vector(2 downto 0) := (others => '0');
  signal s_axi_arvalid : std_logic := '0';
  signal s_axi_arready : std_logic := '0';
  -- Slave Interface Read Data Ports
  signal s_axi_rready  : std_logic := '0';
  signal s_axi_rid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
  signal s_axi_rresp   : std_logic_vector(1 downto 0) := (others => '0');
  signal s_axi_rlast   : std_logic := '0';
  signal s_axi_rvalid  : std_logic := '0';

  component ila_0
    port(
      clk    : in std_logic;
      probe0 : in std_logic_vector(0 downto 0);
      probe1 : in std_logic_vector(58 downto 0);
      probe2 : in std_logic_vector(58 downto 0);
      probe3 : in std_logic_vector(38 downto 0);
      probe4 : in std_logic_vector(7 downto 0);
      probe5 : in std_logic_vector(40 downto 0);
      probe6 : in std_logic_vector(32 downto 0)
      );
  end component ila_0;

  signal probe0 : std_logic_vector(0 downto 0);
  signal probe1 : std_logic_vector(58 downto 0);
  signal probe2 : std_logic_vector(58 downto 0);
  signal probe3 : std_logic_vector(38 downto 0);
  signal probe4 : std_logic_vector(7 downto 0);
  signal probe5 : std_logic_vector(40 downto 0);
  signal probe6 : std_logic_vector(32 downto 0);

  component axi4m_to_fifo
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
  end component axi4m_to_fifo;

  component fifo_to_axi4m
    port(
      clk   : in std_logic;
      reset : in std_logic;

      data_in : in std_logic_vector(32+4-1 downto 0); -- data + strb
      data_we : in std_logic;
      ctrl_in : in std_logic_vector(32+8-1 downto 0); -- len + addr
      ctrl_we : in std_logic;

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
  end component fifo_to_axi4m;

  signal vio_data_in      : std_logic_vector(32+4-1 downto 0);  -- data + strb
  signal vio_data_we      : std_logic;
  signal vio_data_we_d    : std_logic;
  signal vio_data_we_trig : std_logic;
  signal vio_ctrl_in      : std_logic_vector(32+8-1 downto 0);  -- len + addr
  signal vio_ctrl_we      : std_logic;
  signal vio_ctrl_we_d    : std_logic;
  signal vio_ctrl_we_trig : std_logic;

  signal vio_kick      : std_logic;
  signal vio_kick_d    : std_logic;
  signal vio_kick_trig : std_logic;
  signal vio_busy      : std_logic;
  signal vio_read_num  : std_logic_vector(31 downto 0);
  signal vio_read_addr : std_logic_vector(31 downto 0);
      
  signal buf_dout : std_logic_vector(31 downto 0);
  signal buf_we   : std_logic;

  component vio_0
    port(
      clk        : in  std_logic;
      probe_in0  : in  std_logic_vector(0 downto 0);
      probe_out0 : out std_logic_vector(35 downto 0);
      probe_out1 : out std_logic_vector(0 downto 0);
      probe_out2 : out std_logic_vector(39 downto 0);
      probe_out3 : out std_logic_vector(0 downto 0);
      probe_out4 : out std_logic_vector(0 downto 0);
      probe_out5 : out std_logic_vector(31 downto 0);
      probe_out6 : out std_logic_vector(31 downto 0)
      );
  end component vio_0;

begin

  GPIO00 <= '0';
  GPIO01 <= '0';
  GPIO02 <= '0';
  GPIO03 <= '0';
  GPIO04 <= '0';
  GPIO05 <= '0';
  GPIO06 <= '0';
  GPIO07 <= '0';
  GPIO10 <= '0';
  GPIO11 <= '0';
  GPIO12 <= '0';
  GPIO13 <= '0';
  
  GPIO14 <= '0';
  GPIO15 <= '0';

  GPIO20 <= '0';
  GPIO21 <= '0';
  GPIO22 <= '0';
  GPIO23 <= '0';
  GPIO24 <= '0';
  GPIO25 <= '0';
  GPIO26 <= '0';
  GPIO27 <= '0';
  GPIO30 <= '0';
  GPIO31 <= '0';
  GPIO32 <= '0';
  GPIO33 <= '0';
  GPIO34 <= '0';
  GPIO35 <= '0';

  GPIO40 <= '0';
  GPIO41 <= '0';
  GPIO42 <= '0';
  GPIO43 <= '0';
  GPIO44 <= '0';
  GPIO45 <= '0';
  GPIO46 <= '0';
  GPIO47 <= '0';
  GPIO50 <= '0';
  GPIO51 <= '0';
  GPIO52 <= '0';
  GPIO53 <= '0';
  
  GPIO54 <= '0';
  GPIO55 <= '0';
  
  GPIO60 <= '0';
  GPIO61 <= '0';
  GPIO62 <= '0';
  GPIO63 <= '0';
  GPIO64 <= '0';
  GPIO65 <= '0';
  GPIO66 <= '0';
  GPIO67 <= '0';
  GPIO70 <= '0';
  GPIO71 <= '0';
  GPIO72 <= '0';
  GPIO73 <= '0';
  GPIO74 <= '0';
  GPIO75 <= '0';

  HDMI0_D0_P <= '0';
  HDMI0_D0_N <= '0';
  HDMI0_D1_P <= '0';
  HDMI0_D1_N <= '0';
  HDMI0_D2_P <= '0';
  HDMI0_D2_N <= '0';
  HDMI0_SCL  <= '0';
  HDMI0_SDA  <= '0';
  HDMI0_CLK_P <= '0';
  HDMI0_CLK_N <= '0';
  
  HDMI1_D0_P <= '0';
  HDMI1_D0_N <= '0';
  HDMI1_D1_P <= '0';
  HDMI1_D1_N <= '0';
  HDMI1_D2_P <= '0';
  HDMI1_D2_N <= '0';
  HDMI1_SCL  <= '0';
  HDMI1_SDA  <= '0';
  HDMI1_CLK_P <= '0';
  HDMI1_CLK_N <= '0';

  Pmod <= (others => '0');
  
  --led0 <= status_phy(0);
  --led1 <= init_calib_complete;
  --led2 <= std_logic(counter_clk125(22));
  led0 <= '0';
  led1 <= '0';
  led2 <= '0';

  sys_clk_buf : IBUFDS port map (
    I  => sys_clk_p,
    IB => sys_clk_n,
    O  => sys_clk
    );

  u_clk_wiz_0 : clk_wiz_0
    port map(
      clk_out1 => clk310M,
      clk_out2 => clk200M,
      locked   => locked_i,
      reset    => '0',
      clk_in1  => sys_clk
      );

  clock_gen : clk_wiz_1
    port map(
      clk_out1 => open,
      clk_out2 => clk125M,
      clk_out3 => clk125M_90,
      -- Status and con
      reset    => '0',
      locked   => locked,
      -- Clock in ports
      clk_in1  => sys_clk
      );

  u_mig_7series_0 : mig_7series_0
    port map(
      ddr3_addr           => ddr3_addr,
      ddr3_ba             => ddr3_ba,
      ddr3_cas_n          => ddr3_cas_n,
      ddr3_ck_n           => ddr3_ck_n,
      ddr3_ck_p           => ddr3_ck_p,
      ddr3_cke            => ddr3_cke,
      ddr3_ras_n          => ddr3_ras_n,
      ddr3_we_n           => ddr3_we_n,
      ddr3_dq             => ddr3_dq,
      ddr3_dqs_n          => ddr3_dqs_n,
      ddr3_dqs_p          => ddr3_dqs_p,
      ddr3_reset_n        => ddr3_reset_n,
      init_calib_complete => init_calib_complete,

      ddr3_cs_n => ddr3_cs_n,
      ddr3_dm   => ddr3_dm,
      ddr3_odt  => ddr3_odt,

      ui_clk => clk,
      ui_clk_sync_rst => rst,

      mmcm_locked   => open,
      aresetn       => '1',
      app_sr_req    => '0',
      app_ref_req   => '0',
      app_zq_req    => '0',
      app_sr_active => open,
      app_ref_ack   => open,
      app_zq_ack    => open,

      s_axi_awid    => s_axi_awid,
      s_axi_awaddr  => s_axi_awaddr,
      s_axi_awlen   => s_axi_awlen,
      s_axi_awsize  => s_axi_awsize,
      s_axi_awburst => s_axi_awburst,
      s_axi_awlock  => s_axi_awlock,
      s_axi_awcache => s_axi_awcache,
      s_axi_awprot  => s_axi_awprot,
      s_axi_awqos   => "0000",
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awready => s_axi_awready,
      
      s_axi_wdata => s_axi_wdata,
      s_axi_wstrb => s_axi_wstrb,
      s_axi_wlast => s_axi_wlast,
      s_axi_wvalid => s_axi_wvalid,
      s_axi_wready => s_axi_wready,
      s_axi_bid => s_axi_bid,
      s_axi_bresp => s_axi_bresp,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_bready => s_axi_bready,
      
      s_axi_arid    => s_axi_arid,
      s_axi_araddr  => s_axi_araddr,
      s_axi_arlen   => s_axi_arlen,
      s_axi_arsize  => s_axi_arsize,
      s_axi_arburst => s_axi_arburst,
      s_axi_arlock  => s_axi_arlock,
      s_axi_arcache => s_axi_arcache,
      s_axi_arprot  => s_axi_arprot,
      s_axi_arqos   => "0000",
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arready => s_axi_arready,
      
      s_axi_rid    => s_axi_rid,
      s_axi_rdata  => s_axi_rdata,
      s_axi_rresp  => s_axi_rresp,
      s_axi_rlast  => s_axi_rlast,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_rready => s_axi_rready,

      --  System Clock Ports
      sys_clk_i => clk310M,
      -- Reference Clock Ports
      clk_ref_i => clk200M,
      device_temp => device_temp,

      sys_rst => locked_i
      );

  process(clk125M)
  begin
    if rising_edge(clk125M) then
      counter_clk125 <= counter_clk125 + 1;
      if counter_clk125 > 1000 then
        reset125M <= '0';
      end if;
    end if;
  end process;
  reset_n <= not reset125M;
  GEPHY_RST_N <= reset_n;
  
  u_e7udpip: e7udpip_rgmii_artix7
    port map(
      -- GMII PHY
      GEPHY_RST_N    => open,
      GEPHY_MAC_CLK  => clk125M,
      GEPHY_MAC_CLK90 => clk125M_90,
      -- TX out
      GEPHY_TD      => GEPHY_TD,
      GEPHY_TXEN_ER => GEPHY_TXEN_ER,
      GEPHY_TCK     => GEPHY_TCK,
      -- RX in
      GEPHY_RD      => GEPHY_RD,
      GEPHY_RCK     => GEPHY_RCK,
      GEPHY_RXDV_ER => GEPHY_RXDV_ER,
      
      GEPHY_MDC     => GEPHY_MDC,
      GEPHY_MDIO    => GEPHY_MDIO,
      GEPHY_INT_N   => GEPHY_INT_N,
      
      -- Asynchronous Reset
      Reset_n        => reset_n,
      
      -- UPL interface
      pUPLGlobalClk => clk125M,
      
      -- UDP tx input
      pUdp0Send_Data       => pUdp0Send_Data,
      pUdp0Send_Request    => pUdp0Send_Request,
      pUdp0Send_Ack        => pUdp0Send_Ack,
      pUdp0Send_Enable     => pUdp0Send_Enable,
      
      pUdp1Send_Data       => pUdp1Send_Data,
      pUdp1Send_Request    => pUdp1Send_Request,
      pUdp1Send_Ack        => pUdp1Send_Ack,
      pUdp1Send_Enable     => pUdp1Send_Enable,
      
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
      pMIIInput_Data       => pMIIInput_Data,
      pMIIInput_Request    => pMIIInput_Request,
      pMIIInput_Ack        => pMIIInput_Ack,
      pMIIInput_Enable     => pMIIInput_Enable,
      
      pMIIOutput_Data      => pMIIOutput_Data,
      pMIIOutput_Request   => pMIIOutput_Request,
      pMIIOutput_Ack       => pMIIOutput_Ack,
      pMIIOutput_Enable    => pMIIOutput_Enable,
      
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
      
      -- Status
      -- pStatus_RxByteCount             : out std_logic_vector( 31 downto 0 );
      -- pStatus_RxPacketCount           : out std_logic_vector( 31 downto 0 );
      -- pStatus_RxErrorPacketCount      : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxDropPacketCount       : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxARPRequestPacketCount : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxARPReplyPacketCount   : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxICMPPacketCount       : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxUDP0PacketCount       : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxUDP1PacketCount       : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxIPErrorPacketCount    : out std_logic_vector( 15 downto 0 );
      -- pStatus_RxUDPErrorPacketCount   : out std_logic_vector( 15 downto 0 );
      
      -- pStatus_TxByteCount             : out std_logic_vector( 31 downto 0 );
      -- pStatus_TxPacketCount           : out std_logic_vector( 31 downto 0 );
      -- pStatus_TxARPRequestPacketCount : out std_logic_vector( 15 downto 0 );
      -- pStatus_TxARPReplyPacketCount   : out std_logic_vector( 15 downto 0 );
      -- pStatus_TxICMPReplyPacketCount  : out std_logic_vector( 15 downto 0 );
      -- pStatus_TxUDP0PacketCount       : out std_logic_vector( 15 downto 0 );
      -- pStatus_TxUDP1PacketCount       : out std_logic_vector( 15 downto 0 );
      -- pStatus_TxMulticastPacketCount  : out std_logic_vector( 15 downto 0 );
      
      pStatus_Phy => status_phy
      
     -- pdebug : out std_logic_vector(63 downto 0)
      );

  pUdp0Send_Data    <= pUdp0Receive_Data;
  pUdp0Send_Request <= pUdp0Receive_Request;
  pUdp0Receive_Ack  <= pUdp0Send_Ack;
  pUdp0Send_Enable  <= pUdp0Receive_Enable;

  pUdp1Send_Data    <= pUdp1Receive_Data;
  pUdp1Send_Request <= pUdp1Receive_Request;
  pUdp1Receive_Ack  <= pUdp1Send_Ack;
  pUdp1Send_Enable  <= pUdp1Receive_Enable;

  pMIIInput_Data    <= X"00000000";
  pMIIInput_Request <= '0';
  pMIIInput_Enable  <= '0';

  pMIIOutput_Ack <= '1';

  u_fifo_to_axi4m : fifo_to_axi4m
    port map(
      clk   => clk125M,
      reset => rst,

      data_in => vio_data_in,
      data_we => vio_data_we_trig,
      ctrl_in => vio_ctrl_in,
      ctrl_we => vio_ctrl_we_trig,

      m_axi_clk => clk,
      m_axi_rst => rst,

      m_axi_awid    => s_axi_awid,
      m_axi_awaddr  => s_axi_awaddr,
      m_axi_awlen   => s_axi_awlen,
      m_axi_awsize  => s_axi_awsize,
      m_axi_awburst => s_axi_awburst,
      m_axi_awlock  => s_axi_awlock,
      m_axi_awcache => s_axi_awcache,
      m_axi_awprot  => s_axi_awprot,
      m_axi_awvalid => s_axi_awvalid,
      m_axi_awready => s_axi_awready,
      
      m_axi_wdata  => s_axi_wdata,
      m_axi_wstrb  => s_axi_wstrb,
      m_axi_wlast  => s_axi_wlast,
      m_axi_wvalid => s_axi_wvalid,
      m_axi_wready => s_axi_wready,
      
      m_axi_bready => s_axi_bready,
      m_axi_bid    => s_axi_bid,
      m_axi_bresp  => s_axi_bresp,
      m_axi_bvalid => s_axi_bvalid
      );
  
  u_axi4m_to_fifo : axi4m_to_fifo
    generic map(
      C_M_AXI_ID_WIDTH   => 4,
      C_M_AXI_ADDR_WIDTH => 32,
      C_M_AXI_DATA_WIDTH => 32
      )
    port map(
      clk   => clk,
      reset => rst,

      kick      => vio_kick_trig,
      busy      => vio_busy,
      read_num  => vio_read_num,
      read_addr => vio_read_addr,

      m_axi_arid    => s_axi_arid,
      m_axi_araddr  => s_axi_araddr,
      m_axi_arlen   => s_axi_arlen,
      m_axi_arsize  => s_axi_arsize,
      m_axi_arburst => s_axi_arburst,
      m_axi_arlock  => s_axi_arlock,
      m_axi_arcache => s_axi_arcache,
      m_axi_arprot  => s_axi_arprot,
      m_axi_arvalid => s_axi_arvalid,
      m_axi_arready => s_axi_arready,

      m_axi_rready => s_axi_rready,
      m_axi_rid    => s_axi_rid,
      m_axi_rdata  => s_axi_rdata,
      m_axi_rresp  => s_axi_rresp,
      m_axi_rlast  => s_axi_rlast,
      m_axi_rvalid => s_axi_rvalid,

      buf_dout => buf_dout,
      buf_we   => buf_we
      );
  
  probe0(0) <= init_calib_complete;
  probe1 <= s_axi_awid & s_axi_awaddr & s_axi_awlen & s_axi_awsize
            & s_axi_awburst & s_axi_awlock & s_axi_awcache & s_axi_awprot
            & s_axi_awvalid & s_axi_awready;
  probe2 <= s_axi_arid & s_axi_araddr & s_axi_arlen & s_axi_awsize
            & s_axi_arburst & s_axi_arlock & s_axi_arcache & s_axi_awprot
            & s_axi_arvalid & s_axi_arready;
  probe3 <= s_axi_wdata & s_axi_wstrb & s_axi_wlast
            & s_axi_wvalid & s_axi_wready;
  probe4 <= s_axi_bready & s_axi_bid & s_axi_bresp & s_axi_bvalid;
  probe5 <= s_axi_rready & s_axi_rid & s_axi_rdata
            & s_axi_rresp & s_axi_rlast & s_axi_rvalid;
  probe6 <= buf_we & buf_dout;
  
  u_ila_0 : ila_0
    port map(
      clk    => clk,
      probe0 => probe0,
      probe1 => probe1,
      probe2 => probe2,
      probe3 => probe3,
      probe4 => probe4,
      probe5 => probe5,
      probe6 => probe6
      );

  process(clk)
  begin
    if rising_edge(clk) then
      vio_data_we_d <= vio_data_we;
      if vio_data_we_d = '0' and vio_data_we = '1' then
        vio_data_we_trig <= '1';
      else
        vio_data_we_trig <= '0';
      end if;
      
      vio_ctrl_we_d <= vio_ctrl_we;
      if vio_ctrl_we_d = '0' and vio_ctrl_we = '1' then
        vio_ctrl_we_trig <= '1';
      else
        vio_ctrl_we_trig <= '0';
      end if;
      
      vio_kick_d <= vio_kick;
      if vio_kick_d = '0' and vio_kick = '1' then
        vio_kick_trig <= '1';
      else
        vio_kick_trig <= '0';
      end if;
    end if;
  end process;

  u_vio_0 : vio_0
    port map(
      clk           => clk,
      probe_in0(0)  => vio_busy,
      probe_out0    => vio_data_in,
      probe_out1(0) => vio_data_we,
      probe_out2    => vio_ctrl_in,
      probe_out3(0) => vio_ctrl_we,
      probe_out4(0) => vio_kick,
      probe_out5    => vio_read_num,
      probe_out6    => vio_read_addr
      );

end architecture RTL;
