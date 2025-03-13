
module blinky(
     input logic i_clk,
     output logic led
);

     logic [24:0] counter = 0;

     assign led = counter[22];

     always_ff @( posedge i_clk ) begin
          counter <= counter + 1;
     end

endmodule
