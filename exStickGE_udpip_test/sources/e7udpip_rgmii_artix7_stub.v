`default_nettype none

module e7udpip_rgmii_artix7#(parameter UPLCLOCKHZ=125)(
			    output wire        GEPHY_RST_N,
			    input wire 	       GEPHY_MAC_CLK,
			    input wire 	       GEPHY_MAC_CLK90,
			    // TX out
			    output wire [3:0]  GEPHY_TD,
			    output wire        GEPHY_TXEN_ER,
			    output wire        GEPHY_TCK,
			    // RX in
			    input wire [3:0]   GEPHY_RD,
			    input wire 	       GEPHY_RCK,
			    input wire 	       GEPHY_RXDV_ER,
			    //Management I/F
			    output wire        GEPHY_MDC,
			    inout wire	       GEPHY_MDIO,
			    input wire 	       GEPHY_INT_N,

			    // Asynchronous Reset
			    input wire 	       Reset_n,

			    // UPL interface
			    input wire 	       pUPLGlobalClk,

			    // UDP tx input
			    input wire [31:0]  pUdp0Send_Data,
			    input wire 	       pUdp0Send_Request,
			    output wire        pUdp0Send_Ack,
			    input wire 	       pUdp0Send_Enable,

			    input wire [31:0]  pUdp1Send_Data,
			    input wire 	       pUdp1Send_Request,
			    output wire        pUdp1Send_Ack,
			    input wire 	       pUdp1Send_Enable,

			    // UDP rx output
			    output wire [31:0] pUdp0Receive_Data,
			    output wire        pUdp0Receive_Request,
			    input wire 	       pUdp0Receive_Ack,
			    output wire        pUdp0Receive_Enable,

			    output wire [31:0] pUdp1Receive_Data,
			    output wire        pUdp1Receive_Request,
			    input wire 	       pUdp1Receive_Ack,
			    output wire        pUdp1Receive_Enable,

			    // MII interface
			    input wire [31:0]  pMIIInput_Data,
			    input wire 	       pMIIInput_Request,
			    output wire        pMIIInput_Ack,
			    input wire 	       pMIIInput_Enable,

			    output wire [31:0] pMIIOutput_Data,
			    output wire        pMIIOutput_Request,
			    input wire 	       pMIIOutput_Ack,
			    output wire        pMIIOutput_Enable,

			    // Setup
			    input wire [31:0]  pMyIpAddr,
			    input wire [47:0]  pMyMacAddr,
			    input wire [31:0]  pMyNetmask,
			    input wire [31:0]  pDefaultGateway,
			    input wire [31:0]  pTargetIPAddr,
			    input wire [15:0]  pMyUdpPort0,
			    input wire [15:0]  pMyUdpPort1,
			    input wire [4:0]   pPHYAddr,
			    input wire [3:0]   pPHYMode,
			    input wire [31:0]  pConfig_Core,

			    //Status
			    output wire [31:0] pStatus_RxByteCount,
			    output wire [31:0] pStatus_RxPacketCount,
			    output wire [15:0] pStatus_RxErrorPacketCount,
			    output wire [15:0] pStatus_RxDropPacketCount,
			    output wire [15:0] pStatus_RxARPRequestPacketCount,
			    output wire [15:0] pStatus_RxARPReplyPacketCount,
			    output wire [15:0] pStatus_RxICMPPacketCount,
			    output wire [15:0] pStatus_RxUDP0PacketCount,
			    output wire [15:0] pStatus_RxUDP1PacketCount,
			    output wire [15:0] pStatus_RxIPErrorPacketCount,
			    output wire [15:0] pStatus_RxUDPErrorPacketCount,

			    output wire [31:0] pStatus_TxByteCount,
			    output wire [31:0] pStatus_TxPacketCount,
			    output wire [15:0] pStatus_TxARPRequestPacketCount,
			    output wire [15:0] pStatus_TxARPReplyPacketCount,
			    output wire [15:0] pStatus_TxICMPReplyPacketCount,
			    output wire [15:0] pStatus_TxUDP0PacketCount,
			    output wire [15:0] pStatus_TxUDP1PacketCount,
			    output wire [15:0] pStatus_TxMulticastPacketCount,

			    output wire [15:0] pStatus_Phy,

			    output wire [63:0] pdebug
			    );

endmodule // e7udpip_rgmii_artix7

`default_nettype wire
