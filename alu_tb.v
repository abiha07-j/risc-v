module alu_tb;
    reg [31:0] a = 32'd5, b = 32'd3;
    reg [3:0] alu_op;
    wire [31:0] result;
    wire zero;

    // Fixed instantiation (connect ports)
    alu uut (.a(a), .b(b), .alu_op(alu_op), .result(result), .zero(zero));

    initial begin
        $display("Starting ALU TB...");

        // ADD: 5+3=8
        alu_op = 4'b0000; #10;
        if (result == 8) $display("ADD PASS: %d", result); else $display("ADD FAIL: %d", result);

        // SUB: 5-3=2
        alu_op = 4'b0001; #10;
        if (result == 2) $display("SUB PASS: %d", result); else $display("SUB FAIL: %d", result);

        // Zero: 0+0=0, zero=1
        a = 0; b = 0; alu_op = 4'b0000; #10;
        if (result == 0 && zero == 1) $display("Zero PASS: %d z=%b", result, zero);
        else $display("Zero FAIL: %d z=%b", result, zero);

        $display("TB done!");
        $finish;
    end

    // Updated monitor (shows op)
    initial $monitor("t=%0t: op=%b A=%d B=%d ? result=%d zero=%b", $time, alu_op, a, b, result, zero);

endmodule
