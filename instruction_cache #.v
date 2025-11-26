// Instruction Cache / ROM for RV32I (fixed)
module instruction_cache #(
    parameter CACHE_SIZE = 256        // 256 words (1KB)
)(
    input  wire [31:0] addr,          // word-aligned PC
    output reg  [31:0] instruction    // instruction output
);

    reg [7:0] cache_mem [CACHE_SIZE-1:0];
  

initial begin $readmemh("instructions.hex",cache_mem); end
assign instruction = {cache_mem[addr+3], cache_mem[addr+2], cache_mem[addr+1], cache_mem[addr+0]};
endmodule

