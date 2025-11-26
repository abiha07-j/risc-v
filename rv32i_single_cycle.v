// ============================================
// FILE: rv32i_single_cycle.v
// RV32I Single Cycle Processor - Top Module
// ============================================

module rv32i_single_cycle (
    input wire clk,
    input wire reset
);

// ============================================
// Internal Wires
// ============================================

// PC signals
wire [31:0] pc_current;
wire [31:0] pc_next;
wire [31:0] pc_plus4;

// Instruction
wire [31:0] instruction;

// Decode signals
wire [6:0] opcode;
wire [4:0] rs1_addr, rs2_addr, rd_addr;
wire [2:0] funct3;
wire [6:0] funct7;

// Register file
wire [31:0] rs1_data, rs2_data;
wire [31:0] wb_data;

// Immediate
wire [31:0] imm;

// Control signals
wire RegWrite, ALUSrc, MemWrite, MemRead, MemToReg, Branch;
wire [1:0] ALUOp;

// ALU signals
wire [31:0] alu_b;
wire [31:0] alu_out;
wire [3:0] alu_control;
wire alu_zero;

// Memory
wire [31:0] mem_data;

// Branch control
wire [31:0] branch_target;
wire pc_src;

// ============================================
// Instruction Decode
// ============================================
assign opcode   = instruction[6:0];
assign rd_addr  = instruction[11:7];
assign funct3   = instruction[14:12];
assign rs1_addr = instruction[19:15];
assign rs2_addr = instruction[24:20];
assign funct7   = instruction[31:25];

// ============================================
// PC + 4
// ============================================
assign pc_plus4 = pc_current + 4;

// ============================================
// Branch Target: PC + imm
// ============================================
assign branch_target = pc_current + imm;

// ============================================
// Branch Decision: Take branch if BEQ and zero flag
// ============================================
assign pc_src = Branch & alu_zero;

// ============================================
// Module Instantiations
// ============================================

// Program Counter
pc PC (
    .clk(clk),
    .reset(reset),
    .pc_next(pc_next),
    .pc(pc_current)
);

// Instruction Memory
instruction_cache IMEM (
    .addr(pc_current),
    .instruction(instruction)
);

// Register File
reg_file RF (
    .clk(clk),
    .we(RegWrite),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),
    .rd_data(wb_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

// Immediate Generator
imm_gen IMM_GEN (
    .instr(instruction),
    .imm(imm)
);

// Control Unit
control_unit CTRL (
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .MemToReg(MemToReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

// ALU Control
assign alu_control = (ALUOp == 2'b00) ? 4'b0000 :  // ADD for I-type, load, store
                     (ALUOp == 2'b01) ? 4'b0001 :  // SUB for branch
                     (ALUOp == 2'b10) ? (          // R-type: decode funct3/funct7
                         (funct3 == 3'b000) ? (funct7[5] ? 4'b0001 : 4'b0000) :  // ADD/SUB
                         (funct3 == 3'b111) ? 4'b0010 :  // AND
                         (funct3 == 3'b110) ? 4'b0011 :  // OR
                         (funct3 == 3'b100) ? 4'b0100 :  // XOR
                         (funct3 == 3'b001) ? 4'b0110 :  // SLL
                         4'b0000
                     ) : 4'b0000;

// ALU Source Mux
mux_alu_src ALU_SRC_MUX (
    .sel(ALUSrc),
    .rs2(rs2_data),
    .imm(imm),
    .alu_b(alu_b)
);

// ALU
alu ALU (
    .a(rs1_data),
    .b(alu_b),
    .alu_op(alu_control),
    .result(alu_out),
    .zero(alu_zero)
);

// Data Memory - NO 're' PORT (using original module)
data_mem DMEM (
    .clk(clk),
    .we(MemWrite),
    .addr(alu_out),
    .write_data(rs2_data),
    .read_data(mem_data)
);

// Write Back Mux
mux_wb WB_MUX (
    .sel(MemToReg),
    .alu_result(alu_out),
    .mem_data(mem_data),
    .wb_data(wb_data)
);

// PC Next Mux
mux_branch PC_MUX (
    .sel(pc_src),
    .pc_plus4(pc_plus4),
    .branch_tgt(branch_target),
    .pc_next(pc_next)
);

endmodule