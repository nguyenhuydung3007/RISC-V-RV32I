module ram # (
	parameter MEM_DEPTH = 1024	// Số word (1024 x 4 byte = 4KB)
)(
	input clk,
	input we,
	//input [3:0] wstrb,			// Write Strobe (Tín hiệu cho phép ghi từng byte riêng lẻ trong một word 32-bit)
	input [31:0] addr,			// Địa chỉ 32-bit từ CPU
	input [31:0] wdata,			// Dữ liệu CPU muốn ghi vào RAM
	output reg [31:0] rdata		// Dữ liệu RAM trả về cho CPU
);

	// ============================================================
	// Block RAM
	// Tổng dung lượng: 1024 x 4 byte = 4 KB
	// Sử dụng Block RAM vật lý trong FPGA (không dùng LUT logic)
	// ============================================================
	(* ramstyle = "M9K" *)
	reg [31:0] mem [0:MEM_DEPTH - 1];
	
	// ============================================================
	// Load Firmware
	// Nạp dữ liệu cho RAM (code.hex)
	// ============================================================
	initial begin
		$readmemh("code.hex", mem);
	end
	
	// ============================================================
	// Address Translation
	// CPU dùng add theo byte, RAM lưu trữ theo word
	// --> addr / 4
	// ============================================================
	wire [$clog2(MEM_DEPTH) - 1:0] word_addr;
	assign word_addr = addr[($clog2(MEM_DEPTH) + 1):2];
	
	// ============================================================
	// RAM
	// Khối điều khiển Read/Write
	// ============================================================
	always @(posedge clk) begin
		// Write
		if (we) begin
//			if (wstrb[0]) mem[word_addr][7:0] <= wdata[7:0];
//			if (wstrb[1]) mem[word_addr][15:8] <= wdata[15:8];
//			if (wstrb[2]) mem[word_addr][23:16] <= wdata[23:16];
//			if (wstrb[3]) mem[word_addr][31:24] <= wdata[31:24];
			mem[word_addr] <= wdata;
		end
		
		// Read
		rdata <= mem[word_addr];
		
	end
	
endmodule