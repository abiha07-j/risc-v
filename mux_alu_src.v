// 2:1 Mux for ALU Src: sel=0 (rs2), 1 (imm)
module mux_alu_src (
    input wire sel,  // ALUSrc from Control
    input wire [31:0] rs2, imm,
    output wire [31:0] alu_b
);

assign alu_b = sel ? imm : rs2;

endmodule