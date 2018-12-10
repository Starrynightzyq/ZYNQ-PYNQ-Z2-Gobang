
`timescale 1 ns / 1 ps

	module gobang_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		input wire [11:0] pixel_x_i,				//VGA signal in
		input wire [11:0] pixel_y_i,
		input wire video_on_i,

		input wire hsync_i,
		input wire vsync_i,

	    output wire [23:0] vid_pData,
	    output reg vid_pHSync,
	    output reg vid_pVSync,
	    output reg vid_pVDE,

	    output wire start_page_o,
		
	    input wire [3:0] consider_i,         // Row considered by strategy/checker
	    input wire [3:0] consider_j,         // Column considered by s/c

	    input wire [11:0] dot_x_1,               //鼠标位置
	    input wire [11:0] dot_y_1,
	    input wire [11:0] dot_x_2,               //鼠标位置
	    input wire [11:0] dot_y_2,

	    input wire [3:0] point_btn_1,           //鼠标1指向
	    input wire [3:0] point_btn_2,			//鼠标2指向

	    output wire [8:0] black_i,            // Row information for s/c
	    output wire [8:0] black_j,            // Column information for s/c
	    output wire [8:0] black_ij,           // Main diagonal information for s/c
	    output wire [8:0] black_ji,           // Counter diagonal information for s/c
	    output wire [8:0] white_i,
	    output wire [8:0] white_j,
	    output wire [8:0] white_ij,
	    output wire [8:0] white_ji,
	    output wire [8:0] grid_i,
	    output wire [8:0] grid_j,
	    output wire [8:0] grid_ij,
	    output wire [8:0] grid_ji,
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
	gobang_v1_0_S_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
	) gobang_v1_0_S_AXI_inst (
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
		.S_AXI_RREADY(s_axi_rready),

		.pixel_x(pixel_x_i),
		.pixel_y(pixel_y_i),
		.video_on(video_on_i),
		.r_dout(r_dout),
		.g_dout(g_dout),
		.b_dout(b_dout),
		.start_page_o(start_page_o),

        .dot_x_1(dot_x_1),
        .dot_y_1(dot_y_1),
        .dot_x_2(dot_x_2),
        .dot_y_2(dot_y_2),

        .point_btn_1(point_btn_1),
        .point_btn_2(point_btn_2),

        .consider_i(consider_i),
        .consider_j(consider_j),
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
        .grid_ji(grid_ji)
	);

	// Add user logic here

    wire [3:0] r_dout;                // VGA red component
    wire [3:0] g_dout;                // VGA green component
    wire [3:0] b_dout;                 // VGA blue component

	assign vid_pData = {{2{r_dout}},{2{b_dout}},{2{g_dout}}};

	always @(posedge s_axi_aclk) begin
		vid_pHSync <= hsync_i;
		vid_pVSync <= vsync_i;
		vid_pVDE <= video_on_i;
	end
	// User logic ends

	endmodule
