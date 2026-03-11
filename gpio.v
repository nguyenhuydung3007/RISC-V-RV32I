module gpio #(
    parameter BASE_ADDR = 32'h00001000
)(
    input  wire        clk,
    input  wire        reset_n,
    
    // Bus interface
    input  wire        we,          // write enable
    input  wire        re,          // read enable
    input  wire [31:0] addr,        // address
    input  wire [31:0] wdata,       // write data
    output reg  [31:0] rdata,       // read data

    // Physical I/O
    output reg  [7:0]  led
);

    // ============================
    // Address Decode
    // ============================
    wire sel;
    assign sel = (addr == BASE_ADDR);

    // ============================
    // LED Register
    // ============================
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            led <= 8'd0;
        end
        else if (we && sel) begin
            led <= wdata[7:0];
        end
    end

    // ============================
    // Read logic
    // ============================
    always @(*) begin
        if (re && sel) begin
            rdata = {24'd0, led};
		  end
		  else begin
				rdata = 32'd0;
		  end
    end

endmodule