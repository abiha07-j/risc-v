// ============================================
// FILE: rv32i_single_cycle_tb.v
// Testbench for RV32I Processor
// ============================================

`timescale 1ns/1ps

module rv32i_single_cycle_tb;

    // Testbench signals
    reg clk;
    reg reset;
    
    // Instantiate Processor
    rv32i_single_cycle DUT (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock Generation (10ns period = 100MHz)
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Waveform dump
    initial begin
        $dumpfile("rv32i.vcd");
        $dumpvars(0, rv32i_single_cycle_tb);
        
        // Dump all signals in DUT
        $dumpvars(1, DUT.pc_current);
        $dumpvars(1, DUT.instruction);
        $dumpvars(1, DUT.RegWrite);
        $dumpvars(1, DUT.alu_out);
        $dumpvars(1, DUT.wb_data);
        
        // Dump register file contents (first 8 registers)
        $dumpvars(0, DUT.RF.regs[0]);
        $dumpvars(0, DUT.RF.regs[1]);
        $dumpvars(0, DUT.RF.regs[2]);
        $dumpvars(0, DUT.RF.regs[3]);
        $dumpvars(0, DUT.RF.regs[4]);
        $dumpvars(0, DUT.RF.regs[5]);
        $dumpvars(0, DUT.RF.regs[6]);
        $dumpvars(0, DUT.RF.regs[7]);
    end
    
    // Test sequence
    initial begin
        $display("============================================");
        $display("RISC-V RV32I Single Cycle Processor Test");
        $display("============================================\n");
        
        // Initialize
        reset = 1; clk=1;
        
        // Hold reset for 1 clock cycles
        #10;
        reset = 0;
        $display("Reset released at time %0t ns\n", $time);
        
        // Run for 25 clock cycles
        #45;
        
        // Display final register values
        $display("\n============================================");
        $display("Final Register Values:");
        $display("============================================");
        $display("x0  (zero) = 0x%08h (always 0)", DUT.RF.regs[0]);
        $display("x1  (ra)   = 0x%08h (expected: 0x00000005)", DUT.RF.regs[1]);
        $display("x2  (sp)   = 0x%08h (expected: 0x00000006)", DUT.RF.regs[2]);
        $display("x3  (gp)   = 0x%08h (expected: 0x0000000B)", DUT.RF.regs[3]);
        $display("x4  (tp)   = 0x%08h", DUT.RF.regs[4]);
        $display("x5  (t0)   = 0x%08h", DUT.RF.regs[5]);
        $display("x6  (t1)   = 0x%08h", DUT.RF.regs[6]);
        $display("x7  (t2)   = 0x%08h", DUT.RF.regs[7]);
        
        // Verify results
        $display("\n============================================");
        $display("Test Verification:");
        $display("============================================");
        
        if (DUT.RF.regs[1] == 32'h00000005) 
            $display("? x1 = 5 (PASS)");
        else 
            $display("? x1 = %d (FAIL - expected 5)", DUT.RF.regs[1]);
            
        if (DUT.RF.regs[2] == 32'h00000006) 
            $display("? x2 = 6 (PASS)");
        else 
            $display("? x2 = %d (FAIL - expected 6)", DUT.RF.regs[2]);
            
        if (DUT.RF.regs[3] == 32'h0000000B) 
            $display("? x3 = 11 (PASS)");
        else 
            $display("? x3 = %d (FAIL - expected 11)", DUT.RF.regs[3]);
        
        if (DUT.RF.regs[1] == 32'h00000005 && 
            DUT.RF.regs[2] == 32'h00000006 && 
            DUT.RF.regs[3] == 32'h0000000B) begin
            $display("\n*** ALL TESTS PASSED ***");
        end else begin
            $display("\n*** TESTS FAILED ***");
        end
        
        $display("============================================\n");
        $stop;
    end
    
    // Monitor execution (print every cycle)
    always @(posedge clk) begin
        if (!reset) begin
            $display("Time=%3t ns | PC=0x%08h | Instr=0x%08h | RW=%b | rd=x%02d | ALU=0x%08h | WB=0x%08h", 
                     $time, DUT.pc_current, DUT.instruction, 
                     DUT.RegWrite, DUT.rd_addr, DUT.alu_out, DUT.wb_data);
        end
    end

endmodule
