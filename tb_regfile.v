`timescale 1ns/1ps

module tb_regfile;
	reg clk;
	reg reset_n;
	reg we;
	reg [4:0] rs1;
	reg [4:0] rs2;
	reg [4:0] rd;
	reg [31:0] wdata;
	wire [31:0] rdata1;
	wire [31:0] rdata2;
	
	regfile dut (
		.clk(clk),
		.reset_n(reset_n),
		.we(we),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.wdata(wdata),
		.rdata1(rdata1),
		.rdata2(rdata2)
	);
	
	initial begin
		clk = 0;
		forever #10 clk = ~clk;
	end
	
	initial begin
		reset_n = 0;
		we = 0;
		rs1 = 0;
		rs2 = 0;
		rd = 0;
		wdata = 0;
		
		#10 we = 1; rd = 5; wdata = 32'h0000_0FAD;
		#10 we = 0; rs1 = 5;
		
		#10 we = 1; rd = 2; wdata = 32'h0000_FFFF;
		#10 we = 0; rs2 = 2;
		
		#10 $finish;
	end
	
endmodule