/*
    Top module cho RISC-V SoC
    chạy trên DE10-Lite
*/

module top(
    input  wire        CLOCK_50,
    input  wire [1:0]  KEY,
    output wire [9:0]  LEDR
);

    // ==========================================================
    // Clock & Reset
    // ==========================================================

    wire clk;
    wire reset_n;

    assign clk     = CLOCK_50;
    assign reset_n = KEY[0];


    // ==========================================================
    // CPU <-> BUS signals
    // ==========================================================

    wire [31:0] mem_addr;
    wire        mem_we;
    wire [31:0] mem_wdata;
    wire [31:0] mem_rdata;


    // ==========================================================
    // RAM signals
    // ==========================================================

    wire [31:0] ram_rdata;
    wire        ram_we;

    assign ram_we = mem_we && (mem_addr < 32'h00001000);


    // ==========================================================
    // GPIO signals
    // ==========================================================

    wire [31:0] gpio_rdata;
    wire        gpio_we;
    wire        gpio_re;
    wire [7:0]  gpio_led;

    assign gpio_we = mem_we && (mem_addr == 32'h00001000);
    assign gpio_re = !mem_we && (mem_addr == 32'h00001000);


    // ==========================================================
    // CPU
    // ==========================================================

    cpu cpu_inst(
        .clk(clk),
        .reset_n(reset_n),

        .mem_rdata(mem_rdata),

        .mem_addr(mem_addr),
        .mem_we(mem_we),
        .mem_wdata(mem_wdata)
    );


    // ==========================================================
    // RAM
    // ==========================================================

    ram ram_inst(
        .clk(clk),
        .we(ram_we),
        .addr(mem_addr),
        .wdata(mem_wdata),
        .rdata(ram_rdata)
    );


    // ==========================================================
    // GPIO
    // ==========================================================

    gpio #(
        .BASE_ADDR(32'h00001000)
    ) gpio_inst (
        .clk(clk),
        .reset_n(reset_n),

        .we(gpio_we),
        .re(gpio_re),
        .addr(mem_addr),
        .wdata(mem_wdata),
        .rdata(gpio_rdata),

        .led(gpio_led)
    );


    // ==========================================================
    // BUS READ MUX
    // ==========================================================

    assign mem_rdata =
        (mem_addr < 32'h00001000) ? ram_rdata :
                                    gpio_rdata;


    // ==========================================================
    // LED output
    // ==========================================================

    assign LEDR[7:0] = gpio_led;
    assign LEDR[9:8] = 2'b00;

endmodule
