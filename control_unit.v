module control_unit(
    input wire [6:0] opcode,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg Branch,
    output reg [1:0] ALUOp
);

    always @(*) begin
        // Default (avoid latches)
        RegWrite = 0;
        ALUSrc   = 0;
        MemWrite = 0;
        MemRead  = 0;
        MemToReg = 0;
        Branch   = 0;
        ALUOp    = 2'b00;

        case(opcode)

            // R-type (add, sub, and, or, xor)
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc   = 0;
                ALUOp    = 2'b10;
            end

            // I-type (addi)
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end

            // Load (lw)
            7'b0000011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemRead  = 1;
                MemToReg = 1;
                ALUOp    = 2'b00;
            end

            // Store (sw)
            7'b0100011: begin
                ALUSrc   = 1;
                MemWrite = 1;
                ALUOp    = 2'b00;
            end

            // Branch (beq)
            7'b1100011: begin
                Branch   = 1;
                ALUOp    = 2'b01;
            end

            // J-Type (jal)
            7'b1101111: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end

            // U-type (lui)
            7'b0110111: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 2'b00;
            end

        endcase
    end

endmodule
