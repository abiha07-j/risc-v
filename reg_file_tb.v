// Self-checking TB for Register File: Tests write/read, x0=0
module reg_file_tb;
    reg clk = 0;
    reg we;
    reg [4:0] rs1_addr, rs2_addr, rd_addr;
    reg [31:0] rd_data;
    wire [31:0] rs1_data, rs2_data;

    reg_file uut (  // Unit Under Test
        .clk(clk), .we(we),
        .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr),
        .rd_data(rd_data), .rs1_data(rs1_data), .rs2_data(rs2_data)
    );

    always #5 clk = ~clk;  // 10ns clock

    initial begin
        $display("Starting Reg File TB...");
        we = 0; rs1_addr = 5'd1; rs2_addr = 5'd2; rd_addr = 5'd1; rd_data = 32'd42;
        #10;  // Init

        // Test 1: Write 42 to x1, read x1 & x2 (exp: 42, 0)
        we = 1; #10; we = 0; #10;
        $display("Test 1: rs1=%d (exp42), rs2=%d (exp0)", rs1_data, rs2_data);
        if (rs1_data != 42 || rs2_data != 0) $stop;

        // Test 2: Write 7 to x2, read both (exp: 42, 7)
        rd_addr = 5'd2; rd_data = 32'd7; we = 1; #10; we = 0; #10;
        $display("Test 2: rs1=%d (exp42), rs2=%d (exp7)", rs1_data, rs2_data);
        if (rs1_data != 42 || rs2_data != 7) $stop;

        // Test 3: x0 write ignored, read=0
        rd_addr = 5'd0; rd_data = 32'd999; we = 1; #10; we = 0; rs1_addr = 5'd0; #10;
        $display("Test 3: x0=%d (exp0)", rs1_data);
        if (rs1_data != 0) $stop;

        $display("All PASS! Reg File verified.");
        #10 $finish;
    end

    initial $monitor("t=%0t: we=%b rd=%d rs1=%d rs2=%d", $time, we, rd_addr, rs1_data, rs2_data);

endmodule
