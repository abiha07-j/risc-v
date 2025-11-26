// Immediate Generator: Extracts and sign-extends imm from RV32I instr formats
// Supports all base types; combo logic for decode stage
module imm_gen #(
    parameter WIDTH = 32  // Word width (parameter for modularity)
)(
    input wire [WIDTH-1:0] instr,  // 32-bit instruction
    output reg [WIDTH-1:0] imm     // Sign-extended immediate
);

wire [6:0] opcode = instr[6:0];

always @(*) begin
    case (opcode)
        7'b0010011, 7'b0000011, 7'b1100111:  // I-type (ADDI, Load, JALR: bits 31:20)
            imm = {{(WIDTH-12){instr[31]}}, instr[31:20]};
        7'b0100011:                          // S-type (Store: {31:25,11:7})
            imm = {{(WIDTH-12){instr[31]}}, instr[31:25], instr[11:7]};
        7'b1100011:                          // B-type (Branch: {31,7,30:25,11:8,0}; LSB=0)
            imm = {{(WIDTH-13){instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        7'b0110111, 7'b0010111:              // U-type (LUI/AUIPC: bits 31:12 <<12)
            imm = {instr[31:12], 12'b0};     // Unsigned pad (no sign extend)
        7'b1101111:                          // J-type (JAL: {31,19:12,20,30:21,11,0}; LSB=0)
            imm = {{(WIDTH-21){instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        default:                             // Invalid: 0 (safe NOP)
            imm = {WIDTH{1'b0}};
    endcase
end

endmodule