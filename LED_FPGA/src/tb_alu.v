`timescale 1ns/1ps

module tb_alu;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_op;
    wire [31:0] y;
    wire zero;

    alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .y(y),
        .zero(zero)
    );

    initial begin
        a = 32'h0000_0007;
        b = 32'h0000_0003;
        alu_op = 4'b0000; // ALU_ADD

        #10 alu_op = 4'b0001; // ALU_SUB
        #10 alu_op = 4'b0010; // ALU_AND
        #10 alu_op = 4'b0011; // ALU_OR
        #10 alu_op = 4'b0100; // ALU_XOR
        #10 alu_op = 4'b0101; // ALU_SLL
        #10 alu_op = 4'b0110; // ALU_SRL
        #10 alu_op = 4'b0111; // ALU_SRA
        #10 alu_op = 4'b1000; // ALU_SLT
        #10 alu_op = 4'b1001; // ALU_SLTU
        #10 $finish;
    end
endmodule