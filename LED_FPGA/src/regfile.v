// =====================================================================
// Module regfile là khối lưu trữ các thanh ghi của CPU
// + CPU lấy dữ liệu đầu vào cho ALU ở regfile
// + CPU ghi kết quả thu được của ALU vào regfile
// =====================================================================

module regfile (
	input clk,
	input reset_n,
	input we,				// write enable
	input [4:0] rs1,		// Địa chỉ của thanh ghi nguồn 1
	input [4:0] rs2,		// Địa chỉ của thanh ghi nguồn 2
	input [4:0] rd,		// Địa chỉ của thanh ghi đích
	input [31:0] wdata,	// Kết quả tính toán của ALU (sau đó được ghi vào rd)
	output [31:0] rdata1,// Giá trị đọc ra từ thanh ghi nguồn 1
	output [31:0] rdata2 // Giá trị đọc ra từ thanh ghi nguồn 2
);

	reg [31:0] regs[31:0];		// 32 thanh ghi của bộ nhớ
	integer i;
	
	assign rdata1 = (rs1 == 0) ? 32'd0 : regs[rs1];
	assign rdata2 = (rs2 == 0) ? 32'd0 : regs[rs2];
	
	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			for (i = 0; i < 32; i = i + 1) begin
				regs[i] <= 32'd0;
			end
		end
		else begin
			if (we && rd != 0) begin
				regs[rd] <= wdata;
			end
		end
		
	end
	
endmodule