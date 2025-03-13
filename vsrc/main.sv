
module main(
    input logic clk,
    output logic led,
    input logic button
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

    bram_dual_port #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEM_DEPTH(MEM_DEPTH)
    ) bram_inst (
        .i_clk(clk),
        .port_a(port_a.slave),  // Connect to BRAM as slave
        .port_b(port_b.slave)   // Connect to BRAM as slave
    );

    sdram_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) sdram_inst (
        .i_clk(clk),
        .bram_port(port_a.master), // Connect to BRAM as master
        .button(button)
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
