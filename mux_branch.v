// 2:1 Mux for Branch: sel=0 (PC+4), 1 (branch target)
module mux_branch (
    input wire sel,  // Branch from Control
    input wire [31:0] pc_plus4, branch_tgt,  // PC+4 or PC+imm
    output wire [31:0] pc_next
);

assign pc_next = sel ? branch_tgt : pc_plus4;

endmodule