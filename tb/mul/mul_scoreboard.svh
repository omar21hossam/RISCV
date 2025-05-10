class mul_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mul_scoreboard)
    int passed_cases;
    int failed_cases;
    logic signed [63:0] expected_result;
    uvm_analysis_imp #(mul_seq_item, mul_scoreboard) sc_analysis_imp;
    

    function new(string name = "mul_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sc_analysis_imp = new("sc_analysis_imp", this);
    endfunction
    function void mul_ref_model(mul_seq_item t);
        // Reference model for the multiplier
        // This is where you would implement the reference model logic
        // For example, you could perform the multiplication and check the result
        // against the expected value from the DUT.
        // This is a placeholder for your reference model logic.
        if (t.rst_n == 0) begin
            `uvm_info(get_full_name(), $sformatf("Scoreboard: Received item with rst_n=0, skipping"), UVM_MEDIUM);
            return;
        end
        else if (t.enable_i == 0) begin
            `uvm_info(get_full_name(), $sformatf("Scoreboard: Received item with enable_i=0, skipping"), UVM_MEDIUM);
            return;
        end
        else begin
            // Perform the multiplication based on the operator_i
            case (t.operator_i)
                MUL_MAC32:  begin
                    expected_result = t.operand_a_i * t.operand_b_i + t.operand_c_i;
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: MAC32 operation"), UVM_MEDIUM);
                    expected_result = expected_result[31:0]; // Truncate to 32 bits
                end
                MUL_MSU32:  begin
                    expected_result = t.operand_c_i - (t.operand_a_i * t.operand_b_i);
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: MSU32 operation"), UVM_MEDIUM);
                    expected_result = expected_result[31:0]; // Truncate to 32 bits
                end
                MUL_I:  begin
                    // For I operation, there is something wrong here the dut always add the operand_c_i to the result
                    // t_result_o = t.operand_a_i * t.operand_b_i + t.operand_c_i;
                    expected_result = t.operand_a_i * t.operand_b_i;
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: I operation"), UVM_MEDIUM);
                    expected_result = expected_result[31:0]; // Truncate to 32 bits
                end
                MUL_IR:  begin
                
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: IR operation"), UVM_MEDIUM);
                end
                MUL_DOT8:  begin
                    
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: DOT8 operation"), UVM_MEDIUM);
                end
                MUL_DOT16:  begin
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: DOT16 operation"), UVM_MEDIUM);
                end
                // must check is it signed or unsigned
                //mul mulh mulhsu mulhu
                MUL_H:  begin
                    case (t.short_signed_i)
                        2'b00: begin
                            expected_result = (t.operand_a_i) * (t.operand_b_i); // Unsigned multiplication
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: MUL_HU operation"), UVM_MEDIUM);
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: %0h", expected_result), UVM_MEDIUM);
                            expected_result = expected_result[63:32]; // Truncate to 32 bits
                        end
                        2'b01: begin
                            expected_result = $signed(t.operand_a_i) * $signed({1'b0, t.operand_b_i});
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: MUL_HSU operation"), UVM_MEDIUM);
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: %0h", expected_result), UVM_MEDIUM);
                            expected_result =  (expected_result[63:32]); // Truncate to 32 bits
                        end
                        2'b11: begin
                            expected_result = $signed(t.operand_a_i) * $signed(t.operand_b_i); // Signed multiplication with subword
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: MUL_H operation"), UVM_MEDIUM);
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: %0h", expected_result), UVM_MEDIUM);
                            expected_result = $signed (expected_result[63:32]); // Truncate to 32 bits
                        end
                        default: begin
                            expected_result = 32'hDEADBEEF; // Invalid operation
                            `uvm_info(get_full_name(), $sformatf("Scoreboard: Invalid operation"), UVM_MEDIUM);
                        end
                    endcase    
                end
                default: begin
                    expected_result = 32'hDEADBEEF; // Invalid operation
                    `uvm_info(get_full_name(), $sformatf("Scoreboard: Invalid operation"), UVM_MEDIUM);
                end
            endcase

            // Check the result against the DUT output
            if (t.result_o !== expected_result) begin
                `uvm_error(get_full_name(), $sformatf("Scoreboard: Mismatch! Expected %0h, got %0h", expected_result, t.result_o));
                failed_cases++;
            end else begin
                `uvm_info(get_full_name(), $sformatf("Scoreboard: Match! Expected %0h, got %0h", expected_result, t.result_o), UVM_MEDIUM);
                passed_cases++;
            end
        end
    endfunction

    function void write(mul_seq_item t);
        mul_ref_model(t);
    endfunction

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info(get_full_name(), $sformatf("Scoreboard: Passed cases: %0d", passed_cases), UVM_MEDIUM);
        `uvm_info(get_full_name(), $sformatf("Scoreboard: Failed cases: %0d", failed_cases), UVM_MEDIUM);
    endfunction
        
endclass