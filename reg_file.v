module reg_file (
    input wire clk,
    input wire we,  // Write enable
    input wire [4:0] rs1_addr, rs2_addr, rd_addr,
    input wire [31:0] rd_data,
    output reg [31:0] rs1_data, rs2_data
);

reg [31:0] regs [0:31];  // 32 registers

integer i;
initial for (i=0; i<32; i=i+1) regs[i] = 32'b0;  // Init to 0

always @(posedge clk) begin
    if (we && rd_addr != 0)  // Don't write to x0
        regs[rd_addr] <= rd_data;
end

always @(*) begin  // Combinational read (fast)
    rs1_data = (rs1_addr == 0) ? 32'b0 : regs[rs1_addr];
    rs2_data = (rs2_addr == 0) ? 32'b0 : regs[rs2_addr];
end

endmodule