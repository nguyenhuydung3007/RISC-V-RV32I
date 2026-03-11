// =====================================================================
// Module Alu dùng để thực hiện các phép toán của ISA RV32I
// + Lấy dữ liệu từ các thanh ghi để tạo ra kết quả cho instruction
// + Số lượng instruction của ALU phụ thuộc vào ISA
// =====================================================================
module alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_op,
    output reg [31:0] y,
    output  zero
);

    // Định nghĩa các mã lệnh ALU
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLL = 4'b0101;  // Dịch trái logic
    localparam ALU_SRL = 4'b0110;  // Dịch phải logic
    localparam ALU_SRA = 4'b0111;  // Dịch phải số học (Giữ nguyên bit dấu)
    localparam ALU_SLT = 4'b1000;  // So sánh 2 số (Lấy số bé hơn)
    localparam ALU_SLTU = 4'b1001; // Set Less Than Unsigned

    // Thực hiện phép toán dựa trên mã lệnh ALU
    always @(*) begin
        case (alu_op)
            ALU_ADD: y = a + b;
            ALU_SUB: y = a - b;
            ALU_AND: y = a & b;
            ALU_OR:  y = a | b;
            ALU_XOR: y = a ^ b;
            ALU_SLL: y = a << b[4:0];
            ALU_SRL: y = a >> b[4:0];
            ALU_SRA: y = $signed(a) >>> b[4:0];
            ALU_SLT: y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            ALU_SLTU: y = (a < b) ? 1 : 0; 
            default: y = 32'b0;
        endcase
		  
    end

    assign zero = (y == 32'b0) ? 1 : 0;
endmodule