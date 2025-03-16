
/// PSRAM Slave Controller Parrallel IMPLEMENTATION
module psram_slave_contoller #(
    parameter PSRAM_DATA_WIDTH = 16,
    parameter PSRAM_ADDR_WIDTH = 25,
    parameter MEM_DATA_WIDTH = 32,
    parameter MEM_ADDR_WIDTH = 10
) (
    input logic i_clk,
    input logic chip_enable,
    input logic output_enable,
    input logic write_enable,
    input logic [PSRAM_ADDR_WIDTH-1:0] address,
    inout logic [PSRAM_DATA_WIDTH-1:0] data,

    bram_port_if.master bram_port
);
    typedef enum {IDLE, ADDRESS, DATA} psram_state_t;
    typedef enum {LSB, MSB} psram_data_state_t;

    psram_state_t state;
    psram_data_state_t data_state;
    logic [MEM_DATA_WIDTH-1:0] mem_local_data;
    logic [PSRAM_ADDR_WIDTH-1:0] local_address;

    logic [PSRAM_DATA_WIDTH-1:0] local_psram_data;

    initial begin
        state = IDLE;
        data_state = LSB;
        mem_local_data = 0;
        local_address = 0;
    end

    always_comb begin
        data_state = !(address % 4) ? LSB : MSB;
    end

    assign data = output_enable ? local_psram_data : 'z; // Drive data or set to high-Z

    always_ff @(posedge i_clk) begin
        if (chip_enable) begin
            case (state)
                IDLE: begin
                    if (chip_enable) begin
                        state <= ADDRESS;
                    end
                end
                ADDRESS: begin
                    if (chip_enable) begin
                        local_address <= !(address % 4) ? address : local_address;
                        state <= DATA;
                    end else begin
                        state <= IDLE;
                    end
                end
                DATA: begin
                    if (chip_enable) begin
                        case(data_state)
                            LSB: begin
                                if (write_enable) begin
                                    mem_local_data[MEM_DATA_WIDTH/2-1:0] <= data;
                                end else if (output_enable) begin
                                    bram_port.we <= 0;
                                    bram_port.addr <= local_address;
                                    mem_local_data <= bram_port.dout;
                                    local_psram_data <= mem_local_data[MEM_DATA_WIDTH/2-1:0];
                                end
                            end
                            MSB: begin
                                if (write_enable) begin
                                    mem_local_data[MEM_DATA_WIDTH-1:MEM_DATA_WIDTH/2] <= data;
                                    bram_port.we <= 1;
                                    bram_port.addr <= local_address;
                                    bram_port.din <= mem_local_data;
                                end else if (output_enable) begin
                                    local_psram_data <= mem_local_data[MEM_DATA_WIDTH-1:MEM_DATA_WIDTH/2];
                                end
                            end
                        endcase
                    end
                    state <= IDLE;
                end
            endcase
        end
    end


endmodule
