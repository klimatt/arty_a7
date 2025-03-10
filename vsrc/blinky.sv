
module blinky(
     input logic clk,
     output logic led,
     output logic [24:0] cnt
);

     logic [24:0] counter = 2;

     assign cnt = counter;

     assign led = counter[1];

     always_ff @( posedge clk ) begin
          counter <= counter + 1;
     end

endmodule
