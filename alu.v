
module alu (
    input wire [31:0] a, b,
    input wire [3:0] alu_op,  // Control: 0000=add, 0001=sub, 0010=and, etc.
    output reg [31:0] result,
    output wire zero
);

assign zero = (result == 32'b0);

always @(*) begin
    case (alu_op)
        4'b0000: result = a + b;     // ADD
        4'b0001: result = a - b;     // SUB
        4'b0010: result = a & b;     // AND
        4'b0011: result = a | b;     // OR
        4'b0100: result = a ^ b;     // XOR
        4'b0110: result = a << b[4:0];  // SLL (shift left logical)
        // Add more: SRL, SRA, SLT (less than: result = (a < b) ? 1 : 0)
        default: result = 32'b0;
    endcase
end

endmodule