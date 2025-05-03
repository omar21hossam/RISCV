module mul_top(
);
    `define CV32E40P_ASSERT_ON
    import uvm_pkg::*;
    import package_uvm::*;
    
    mul_if intf();

    cv32e40p_mult dut(
        .clk(intf.clk),
        .rst_n(intf.rst_n),
        .enable_i(intf.enable_i),
        .operator_i(intf.operator_i),
        .short_subword_i(intf.short_subword_i),
        .short_signed_i(intf.short_signed_i),
        .op_a_i(intf.operand_a_i),
        .op_b_i(intf.operand_b_i),
        .op_c_i(intf.operand_c_i),
        .imm_i(intf.imm_i),
        .dot_signed_i(intf.dot_signed_i),
        .dot_op_a_i(intf.dot_op_a_i),
        .dot_op_b_i(intf.dot_op_b_i),
        .dot_op_c_i(intf.dot_op_c_i),
        .is_clpx_i(intf.is_clpx_i),
        .clpx_shift_i(intf.clpx_shift_i),
        .clpx_img_i(intf.clpx_img_i),
        .result_o(intf.result_o),
        .multicycle_o(intf.multicycle_o),
        .mulh_active_o(intf.mulh_active_o),
        .ready_o(intf.ready_o),
        .ex_ready_i(intf.ex_ready_i)
    );
    
    initial begin
        uvm_config_db#(virtual mul_if)::set(null, "uvm_test_top", "vif", intf);
        run_test("mul_test");
    end

    initial begin
        intf.clk = 1;
        forever begin
            #10 intf.clk = ~intf.clk;
        end
    end

    initial begin
        $dumpfile("mul_top.vcd");
        $dumpvars(0, mul_top);
        $display("Starting simulation");
    end

    
endmodule