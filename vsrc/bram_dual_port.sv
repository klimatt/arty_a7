

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 10;
parameter MEM_DEPTH  = 1 << ADDR_WIDTH;

interface bram_port_if #(
    parameter DATA_WIDTH = DATA_WIDTH,
    parameter ADDR_WIDTH = ADDR_WIDTH
);
    logic                  we;       // Write enable
    logic [ADDR_WIDTH-1:0] addr;     // Address
    logic [DATA_WIDTH-1:0] din;      // Data input
    logic [DATA_WIDTH-1:0] dout;     // Data output

    // Define modports to specify signal directions
    modport master (input dout, output we, addr, din);
    modport slave  (output dout, input we, addr, din);
endinterface

module bram_dual_port #(
    parameter DATA_WIDTH = DATA_WIDTH,
    parameter ADDR_WIDTH = ADDR_WIDTH,
    parameter MEM_DEPTH  = MEM_DEPTH
) (
    input logic      i_clk,

    bram_port_if.slave port_a,
    bram_port_if.slave port_b
);

    //BLOCK RAM
    (* ram_style = "block" *) logic [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

    initial begin
        for (int i = 0; i < MEM_DEPTH; i++) begin
            mem[i] = 0;
        end
    end

    logic conflict_detected = 0;
    logic port_a_priority = 0;

    always_comb begin
        conflict_detected = (port_a.we && port_b.we && port_a.addr == port_b.addr);
        port_a_priority = conflict_detected;  // Prioritize Port A over Port B
    end

   always_ff @(posedge i_clk) begin
        if (port_a.we) begin
            mem[port_a.addr] <= port_a.din;
        end

        if (port_b.we && !port_a_priority) begin
            mem[port_b.addr] <= port_b.din;
        end

        port_a.dout <= mem[port_a.addr];

        port_b.dout <= mem[port_b.addr];
    end

endmodule
