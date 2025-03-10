
module main(
    input logic clk,
    output logic led,
    output logic [24:0] cnt
);

    blinky blk(clk, led, cnt);

endmodule
