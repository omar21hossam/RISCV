module riscv_top_tb(
);

    import uvm_pkg::*;
    import package_uvm::*;
    
    initial begin
        
        run_test("riscv_base_test");
    end

    initial begin
        $dumpfile("riscv_top_tb.vcd");
        $dumpvars(0, riscv_top_tb);
        $display("Starting simulation");
    end

    
endmodule