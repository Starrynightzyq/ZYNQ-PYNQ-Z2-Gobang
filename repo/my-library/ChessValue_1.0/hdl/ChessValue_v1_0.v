
`timescale 1 ns / 1 ps

	module ChessValue_v1_0 #
	(
		// Users to add parameters here
	    parameter live_Five = 2500,
	    parameter live_Four = 216,
	    parameter sleep_Four = 36,
	    parameter live_Three = 36,
	    parameter live_Two = 6,
	    parameter live_One = 1,
	    parameter un_known = 0, //全为空或者未知
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
	    input wire random,                     // Random signal
	    
	    input wire [8:0] black_i,              // Row information
	    input wire [8:0] black_j,              // Column information
	    input wire [8:0] black_ij,             // Main diagonal information
	    input wire [8:0] black_ji,             // Counter diagonal information
	    input wire [8:0] white_i,
	    input wire [8:0] white_j,
	    input wire [8:0] white_ij,
	    input wire [8:0] white_ji,
	    input wire [8:0] grid_i,
	    input wire [8:0] grid_j,
	    input wire [8:0] grid_ij,
	    input wire [8:0] grid_ji,
	    
	    output wire [3:0] get_i,                // Current row considered
	    output wire [3:0] get_j,                // Current column considered

	    output wire data_valued,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXI
		input wire  s_axi_aclk,
		input wire  s_axi_aresetn,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
		input wire [2 : 0] s_axi_awprot,
		input wire  s_axi_awvalid,
		output wire  s_axi_awready,
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
		input wire  s_axi_wvalid,
		output wire  s_axi_wready,
		output wire [1 : 0] s_axi_bresp,
		output wire  s_axi_bvalid,
		input wire  s_axi_bready,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
		input wire [2 : 0] s_axi_arprot,
		input wire  s_axi_arvalid,
		output wire  s_axi_arready,
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
		output wire [1 : 0] s_axi_rresp,
		output wire  s_axi_rvalid,
		input wire  s_axi_rready
	);
// Instantiation of Axi Bus Interface S_AXI
	ChessValue_v1_0_S_AXI # ( 
		.live_Five(live_Five),
		.live_Four(live_Four),
		.sleep_Four(sleep_Four),
		.live_Three(live_Three),
		.live_Two(live_Two),
		.live_One(live_One),
		.un_known(un_known), //全为空或者未知
		.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
	) ChessValue_v1_0_S_AXI_inst (
        .random(random),
        .black_i(black_i),
        .black_j(black_j),
        .black_ij(black_ij),
        .black_ji(black_ji),
        .white_i(white_i),
        .white_j(white_j),
        .white_ij(white_ij),
        .white_ji(white_ji),
        .grid_i(grid_i),
        .grid_j(grid_j),
        .grid_ij(grid_ij),
        .grid_ji(grid_ji),
        .get_i(get_i),
        .get_j(get_j),
        .data_valued(data_valued),

		.S_AXI_ACLK(s_axi_aclk),
		.S_AXI_ARESETN(s_axi_aresetn),
		.S_AXI_AWADDR(s_axi_awaddr),
		.S_AXI_AWPROT(s_axi_awprot),
		.S_AXI_AWVALID(s_axi_awvalid),
		.S_AXI_AWREADY(s_axi_awready),
		.S_AXI_WDATA(s_axi_wdata),
		.S_AXI_WSTRB(s_axi_wstrb),
		.S_AXI_WVALID(s_axi_wvalid),
		.S_AXI_WREADY(s_axi_wready),
		.S_AXI_BRESP(s_axi_bresp),
		.S_AXI_BVALID(s_axi_bvalid),
		.S_AXI_BREADY(s_axi_bready),
		.S_AXI_ARADDR(s_axi_araddr),
		.S_AXI_ARPROT(s_axi_arprot),
		.S_AXI_ARVALID(s_axi_arvalid),
		.S_AXI_ARREADY(s_axi_arready),
		.S_AXI_RDATA(s_axi_rdata),
		.S_AXI_RRESP(s_axi_rresp),
		.S_AXI_RVALID(s_axi_rvalid),
		.S_AXI_RREADY(s_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
