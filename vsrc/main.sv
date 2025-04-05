
module main(
    input logic clk,
    output logic led,
    input logic button,


    input logic psram_i_clk,
    input logic psram_chip_enable,
    input logic psram_output_enable,
    input logic psram_write_enable,
    input logic [16-1:0] psram_address,
    inout logic [16-1:0] psram_data
);

    // blinky test module
    // blinky blk(
    //     .i_clk(clk),
    //     .led(led)
    // );

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 10;
    localparam MEM_DEPTH  = 1 << ADDR_WIDTH;
    localparam CLK_PERIOD = 10;

    bram_port_if #(DATA_WIDTH, ADDR_WIDTH) port_a();
    bram_port_if #(DATA_WIDTH, ADDR_WIDTH) port_b();


    assign clk_b = ~clk;

    bram_dual_port #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEM_DEPTH(MEM_DEPTH)
    ) bram_inst (
        .i_clk_a(clk),
        .port_a(port_a.slave),  // Connect to BRAM as slave

        .i_clk_b(psram_i_clk),
        .port_b(port_b.slave)   // Connect to BRAM as slave
    );

    // sdram_controller #(
    //     .DATA_WIDTH(DATA_WIDTH),
    //     .ADDR_WIDTH(ADDR_WIDTH)
    // ) sdram_inst (
    //     .i_clk(clk),
    //     .bram_port(port_a.master), // Connect to BRAM as master
    //     .button(button)
    // );

    psram_slave_contoller #(
        .PSRAM_DATA_WIDTH(16),
        .PSRAM_ADDR_WIDTH(16),
        .MEM_DATA_WIDTH(DATA_WIDTH),
        .MEM_ADDR_WIDTH(ADDR_WIDTH)
    ) psram_inst (
        .i_clk(psram_i_clk),
        .chip_enable(psram_chip_enable),
        .output_enable(psram_output_enable),
        .write_enable(psram_write_enable),
        .address(psram_address),
        .data(psram_data),
        .bram_port(port_a.master)
    );

    blinky_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) blinky_inst(
        .i_clk(clk),
        .led(led),
        .bram_port(port_b.master)
    );

endmodule
