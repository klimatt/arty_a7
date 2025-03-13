module sdram_controller #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
) (
    input logic i_clk,
    bram_port_if.master bram_port,
    //TEST only!!!!
    input logic button
);
    //TEST only!!!!
    logic [DATA_WIDTH-1:0] test_data = 0;

    assign bram_port.din = test_data;
    assign bram_port.addr = 0;

    //TEST only!!!!
    always_ff @(posedge i_clk) begin
        if (button) begin
            bram_port.we <= 1;
            test_data <= test_data + 1;
        end else begin
            bram_port.we <= 0;
        end
    end

endmodule
