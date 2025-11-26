// Simple Data Memory: Sync RAM for RV32I load/store (1KB word-aligned)
module data_mem (
    input wire clk, we,  // Clock, write enable
    input wire [31:0] addr, write_data,  // Address, data in
    output reg [31:0] read_data  // Data out
);

reg [31:0] mem [0:255];  // 256 words (1KB)

always @(posedge clk) begin
    if (we) mem[addr[31:2]] <= write_data;  // Word write (>>2)
    read_data <= mem[addr[31:2]];  // Sync read
end

endmodule
