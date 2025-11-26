// 2:1 Mux for Write Back: sel=0 (ALU), 1 (mem data)
module mux_wb (
    input wire sel,  // MemToReg from Control
    input wire [31:0] alu_result, mem_data,
    output wire [31:0] wb_data
);

assign wb_data = sel ? mem_data : alu_result;

endmodule