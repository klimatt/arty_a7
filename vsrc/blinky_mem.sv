module blinky_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
     input logic i_clk,
     output logic led,
     bram_port_if.master bram_port
);

     logic [DATA_WIDTH-1:0] counter = 0;

     assign led = counter[0];

     assign bram_port.we = 0;
     assign bram_port.addr = 0;
     always_ff @( posedge i_clk ) begin
        counter <= bram_port.dout;
    end

endmodule
