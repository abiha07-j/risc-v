module pc (
    input wire clk,
    input wire reset,
    input wire [31:0] pc_next,  // Next PC value
    output reg [31:0] pc        // Current PC
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'b0;  // Reset to 0
    else
        pc <= pc_next;  // Update to next
end

endmodule
