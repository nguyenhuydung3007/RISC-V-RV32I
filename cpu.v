module cpu (
    input  wire        clk,
    input  wire        reset_n,

    input  wire [31:0] mem_rdata,

    output reg  [31:0] mem_addr,
    output reg         mem_we,
    output reg  [31:0] mem_wdata
);

    // ============================================================
    // Program Counter
    // ============================================================

    reg [31:0] pc;			// Thanh ghi lưu trữ địa chỉ của Instrucion
    wire [31:0] pc_next;		// Giá trị kế tiếp của pc

    assign pc_next = pc + 4;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            pc <= 32'd0;
        else
            pc <= pc_next;
    end


    // ============================================================
    // Instruction Register
    // ============================================================

    reg [31:0] instr;

    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)
            instr <= 32'd0;
        else
            instr <= mem_rdata;
    end


    // ============================================================
    // Decode fields
    // ============================================================

    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];


    // ============================================================
    // Immediate
    // ============================================================
	 
	 // I-Type (ADDI, LW)

    wire [31:0] imm_i = {{20{instr[31]}}, instr[31:20]};
	 
	 // S-Type (SW)
	 wire [31:0] imm_s = {{20{instr[31]}}, instr[31:25], instr[11:7]};


    // ============================================================
    // Control Signals
    // ============================================================

    reg        reg_we;
    reg        alu_src;
    reg [3:0]  alu_op;
    reg        mem_to_reg;
	 reg			mem_write;

    always @(*) begin

        reg_we     = 0;
        alu_src    = 0;
        alu_op     = 4'b0000;
        mem_write  = 0;
        mem_to_reg = 0;

        case (opcode)

            // R-type
            7'b0110011: begin
                reg_we  = 1;
                alu_src = 0;

                if (funct7 == 7'b0000000)
                    alu_op = 4'b0000;   // ADD
                else if (funct7 == 7'b0100000)
                    alu_op = 4'b0001;   // SUB
            end


            // ADDI
            7'b0010011: begin
                reg_we  = 1;
                alu_src = 1;
                alu_op  = 4'b0000;
            end


            // LW
            7'b0000011: begin
                reg_we     = 1;
                alu_src    = 1;
                alu_op     = 4'b0000;
                mem_to_reg = 1;
            end


            // SW
            7'b0100011: begin
                alu_src = 1;
                alu_op  = 4'b0000;
                mem_write  = 1;
            end

        endcase
    end


    // ============================================================
    // Register File
    // ============================================================

    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;
    wire [31:0] reg_wdata;

    regfile rf (
        .clk(clk),
        .reset_n(reset_n),
        .we(reg_we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wdata(reg_wdata),
        .rdata1(reg_rdata1),
        .rdata2(reg_rdata2)
    );


    // ============================================================
    // ALU
    // ============================================================

    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire        zero;

    assign alu_b = (alu_src) ? imm_i : reg_rdata2;

    alu alu_inst (
        .a(reg_rdata1),
        .b(alu_b),
        .alu_op(alu_op),
        .y(alu_result),
        .zero(zero)
    );


    // ============================================================
    // Memory Interface
    // ============================================================

    always @(*) begin

        mem_addr  = pc;
        mem_wdata = reg_rdata2;
		  mem_we    = 0;
		  
		  // Load
        if (opcode == 7'b0000011) begin
            mem_addr = alu_result;
		  end
		  
		  // Store
		  if (opcode == 7'b0100011) begin
				mem_addr = reg_rdata1 + imm_s;
				mem_we   = 1;
		  end

    end


    // ============================================================
    // Write Back
    // ============================================================

    assign reg_wdata =
        (mem_to_reg) ? mem_rdata : alu_result;

endmodule