class alu_coverage_collector extends uvm_subscriber #(alu_seq_item);
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(alu_coverage_collector)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  alu_seq_item seq_item;

  //==================================================================================
  // Covergroup: Input Transactions
  //==================================================================================
  covergroup alu_cov_inputs;

    operator: coverpoint seq_item.operator_i {  // ALU operation code for I and M instructions
      bins alu_op_code[] = {cv32e40p_pkg::ALU_ADD,cv32e40p_pkg::ALU_SUB,
                            cv32e40p_pkg::ALU_XOR,cv32e40p_pkg::ALU_OR,
                            cv32e40p_pkg::ALU_AND,cv32e40p_pkg::ALU_SRA,
                            cv32e40p_pkg::ALU_SRL,cv32e40p_pkg::ALU_SLL,
                            cv32e40p_pkg::ALU_LTS,cv32e40p_pkg::ALU_LTU,
                            cv32e40p_pkg::ALU_GES,cv32e40p_pkg::ALU_GEU,
                            cv32e40p_pkg::ALU_EQ ,cv32e40p_pkg::ALU_NE ,
                            cv32e40p_pkg::ALU_SLTS,cv32e40p_pkg::ALU_SLTU,
                            cv32e40p_pkg::ALU_DIVU,cv32e40p_pkg::ALU_DIV,
                            cv32e40p_pkg::ALU_REMU,cv32e40p_pkg::ALU_REM
                            };
    }


    ex_ready: coverpoint seq_item.ex_ready_i {  //for DIV instructions
      bins ex_ready_0 = {1'b0};
      bins ex_ready_1 = {1'b1};
      bins ex_ready_zero2one = (0 => 1'b1);
      bins ex_ready_one2zero = (1'b1 => 0);
    }

    //Note: we on I AND M instructions, we deal with signed numbers only
    operand_a: coverpoint seq_item.operand_a_i {  // ALU operand A
      bins operand_a_min = {32'h8000_0000};
      bins operand_a_zero = {32'h0000_0000};
      bins operand_a_max = {32'h7FFF_FFFF};
      bins operand_a_repet_min = (32'h8000_0000 [* 2]);
      bins operand_a_repet_max = (32'h7FFF_FFFF [* 2]);
      bins operand_a_repet_zero = (32'h0000_0000 [* 2]);
      bins operand_a_posv_values = {[32'h0000_0001 : 32'h7FFF_FFFE]};
      bins operand_a_negv_values = {[32'h8000_0001 : 32'hFFFF_FFFE]};
    }

    operand_b: coverpoint seq_item.operand_b_i {  // ALU operand B
      bins operand_b_min = {32'h8000_0000};
      bins operand_b_zero = {32'h0000_0000};
      bins operand_b_max = {32'h7FFF_FFFF};
      bins operand_b_samt_max = {32'h????_??1F};
      bins operand_b_repet_min = (32'h8000_0000 [* 2]);
      bins operand_b_repet_max = (32'h7FFF_FFFF [* 2]);
      bins operand_b_repet_zero = (32'h0000_0000 [* 2]);
      bins operand_b_posv_values = {[32'h0000_0001 : 32'h7FFF_FFFE]};
      bins operand_b_negv_values = {[32'h8000_0001 : 32'hFFFF_FFFE]};
    }

    vector_mode: coverpoint seq_item.vector_mode_i {bins vector_mode_0 = {0};}

    cross_operand_operation: cross operator, operand_a, operand_b{

      //===========================================
      // Check the overflow scenarios
      //Note:overflow not required done by extreme values and we did it by different values
      //===========================================
      bins add_op_overflow_case0 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_ADD]) &&   
                                   binsof(operand_a.operand_a_max) &&
                                   binsof(operand_b.operand_b_max);

      bins add_op_overflow_case1 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_ADD]) &&   
                                   binsof(operand_a.operand_a_min) && 
                                   binsof(operand_b.operand_b_negv_values);

      bins add_op_overflow_case2 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_ADD]) &&   
                                   binsof(operand_a.operand_a_max) &&
                                   binsof(operand_b.operand_b_posv_values);

      bins add_op_overflow_case3 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_ADD]) &&   
                                   binsof(operand_a.operand_a_min) && 
                                   binsof(operand_b.operand_b_min);

      bins sub_op_overflow_case0 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SUB]) &&   
                                   binsof(operand_a.operand_a_min) &&
                                   binsof(operand_b.operand_b_max);

      bins sub_op_overflow_case2 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SUB]) &&   
                                   binsof(operand_a.operand_a_min) &&
                                   binsof(operand_b.operand_b_posv_values);

      bins sub_op_overflow_case1 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SUB]) &&   
                                   binsof(operand_a.operand_a_max) && 
                                   binsof(operand_b.operand_b_negv_values);

      bins sub_op_overflow_case3 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SUB]) &&   
                                   binsof(operand_a.operand_a_max) && 
                                   binsof(operand_b.operand_b_min);

      //===========================================
      // Check the zero scenarios
      //===========================================                                                     
      bins add_op_zero_operands = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_ADD]) &&
                                  binsof(operand_a.operand_a_zero) &&
                                  binsof(operand_b.operand_b_zero);

      bins sub_op_zero_operands = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SUB]) &&
                                  binsof(operand_a.operand_a_zero) &&
                                  binsof(operand_b.operand_b_zero);

      //===========================================
      // Check the shifting scenarios
      //===========================================            
      //case0: no shifting
      bins shift_op_SRA_case0 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SRA]) &&  
                                  binsof(operand_b.operand_b_zero);

      bins shift_op_SRL_case0 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SRL]) &&  
                                  binsof(operand_b.operand_b_zero);

      bins shift_op_SLL_case0 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SLL]) &&  
                                  binsof(operand_b.operand_b_zero);
      //case1: shifting by max value
      bins shift_op_SRA_case1 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SRA]) &&  
                                  binsof(operand_b.operand_b_samt_max);

      bins shift_op_SRL_case1 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SRL]) &&
                                  binsof(operand_b.operand_b_samt_max);

      bins shift_op_SLL_case1 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SLL]) &&
                                  binsof(operand_b.operand_b_samt_max);
      //case2: shifting by any value
      bins shift_op_SRA_case2 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SRA]) &&  
                                  binsof(operand_b.operand_b_posv_values);

      bins shift_op_SRL_case2 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SRL]) &&
                                  binsof(operand_b.operand_b_negv_values);            //the shift amt affect by the first 5 bits only

      bins shift_op_SLL_case2 = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SLL]) &&  
                                  binsof(operand_b.operand_b_posv_values);

      //===========================================
      // Set Lower Than operations
      //===========================================
      //case0: the result is 0
      bins SLTS_op_case0 = binsof (operator.alu_op_code[cv32e40p_pkg::ALU_SLTS]) &&  //S:signed 
      binsof (operand_a.operand_a_posv_values) && binsof (operand_b.operand_b_negv_values);

      bins SLTU_op_case0     = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SLTU]) &&   
                                     binsof(operand_a.operand_a_negv_values) &&
                                     binsof(operand_b.operand_b_posv_values);
      //case1: the result is 1
      bins SLTS_op_case1      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SLTS]) &&   
                                     binsof(operand_a.operand_a_negv_values) &&
                                     binsof(operand_b.operand_b_posv_values);

      bins SLTU_op_case1      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_SLTU]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_negv_values);

      //===========================================
      // Comparisons operations
      //===========================================
      //case0: with positive values
      bins ALU_EQ_case0      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_EQ]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_posv_values);

      bins ALU_NE_case0      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_NE]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_posv_values);
      //case1: with negative values
      bins ALU_EQ_case1      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_EQ]) &&
                                      binsof(operand_a.operand_a_negv_values) &&
                                      binsof(operand_b.operand_b_negv_values);

      bins ALU_NE_case1      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_NE]) &&
                                      binsof(operand_a.operand_a_negv_values) &&
                                      binsof(operand_b.operand_b_posv_values);

      //===============================================                                                               
      //case0: the result is 0000_0000 and comparison_result_o = 0
      bins ALU_LTS_case0      =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_LTS]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_negv_values);

      bins ALU_LTU_case0      =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_LTU]) &&
                                      binsof(operand_a.operand_a_negv_values) &&
                                      binsof(operand_b.operand_b_posv_values);

      bins ALU_GES_case0     =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_GES]) &&
                                      binsof(operand_a.operand_a_negv_values) &&
                                      binsof(operand_b.operand_b_posv_values);

      bins ALU_GEU_case0     =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_GEU]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_negv_values);

      //case1: the result is FFFF_FFFF and comparison_result_o = 1
      bins ALU_LTS_case1      =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_LTS]) &&
                                      binsof(operand_a.operand_a_negv_values) &&
                                      binsof(operand_b.operand_b_posv_values);

      bins ALU_LTU_case1      =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_LTU]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_negv_values);

      bins ALU_GES_case1     =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_GES]) &&
                                      binsof(operand_a.operand_a_posv_values) &&
                                      binsof(operand_b.operand_b_negv_values);

      bins ALU_GEU_case1     =  binsof(operator.alu_op_code[cv32e40p_pkg::ALU_GEU]) &&
                                      binsof(operand_a.operand_a_negv_values) &&
                                      binsof(operand_b.operand_b_posv_values);
      //===========================================
      // Check the division corner cases scenarios
      //===========================================
      bins DIV_op_case0      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_DIV]) &&
                                      binsof(operand_a.operand_a_zero) &&
                                      binsof(operand_b.operand_b_zero);

      bins DIVU_op_case0     = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_DIVU]) &&
                                      binsof(operand_a.operand_a_zero) &&
                                      binsof(operand_b.operand_b_zero);

      bins REM_op_case0      = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_REM]) &&
                                      binsof(operand_a.operand_a_zero) &&
                                      binsof(operand_b.operand_b_zero);

      bins REMU_op_case0     = binsof(operator.alu_op_code[cv32e40p_pkg::ALU_REMU]) &&
                                      binsof(operand_a.operand_a_zero) &&
                                      binsof(operand_b.operand_b_zero);

    }

  endgroup : alu_cov_inputs
  //==================================================================================
  // Covergroup: Output Transactions
  //==================================================================================
  covergroup alu_cov_outputs;
    result_o: coverpoint seq_item.result_o {
      bins result_o_min = {32'h8000_0000};
      bins result_o_max = {32'h7FFF_FFFF};
      bins result_o_mid_values = {[32'h8000_0001 : 32'h7FFF_FFFE]};
      // division and remainder corner cases
      bins result_o_rem_corner = {32'h0000_0000}; //remainder Dividend = -2^(no.bits-1), Divisor = -1
      bins result_o_div_by_zero = {32'hFFFF_FFFF};  //division by zero
    }

    comparison_result_o: coverpoint seq_item.comparison_result_o {
      bins comparison_result_o_0 = {1'b0};
      bins comparison_result_o_1 = {1'b1};
      bins comparison_result_o_zero2one = (0 => 1);
      bins comparison_result_o_one2zero = (1 => 0);
      bins comparison_result_o_zero2zero = (0 => 0);
      bins comparison_result_o_one2one = (1 => 1);
    }

    ready_o: coverpoint seq_item.ready_o {
      bins ready_o_0 = {1'b0};
      bins ready_o_1 = {1'b1};
      bins ready_o_zero2zero = (0 => 0);
      bins ready_o_one2one = (1 => 1);
      bins ready_o_zero2one = (0 => 1);
      bins ready_o_one2zero = (1 => 0);
    }
  endgroup : alu_cov_outputs

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "alu_coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    alu_cov_inputs  = new();
    alu_cov_outputs = new();
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building MUL Subscriber", UVM_HIGH);
  endfunction

  //==================================================================================
  // Function: Write
  //==================================================================================
  function void write(alu_seq_item t);
    seq_item = alu_seq_item::type_id::create("seq_item");
    seq_item = t;
    if (t.in_out == 1'b0) begin
      // Input transaction
      alu_cov_inputs.sample();
    end else if (t.in_out == 1'b1) begin
      // Output transaction
      alu_cov_outputs.sample();
    end
  endfunction

  //==================================================================================
  // Function: Report Phase
  //==================================================================================
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Coverage Input: %0.2f%%", alu_cov_inputs.get_coverage()),
              UVM_MEDIUM)
    `uvm_info(get_type_name(), $sformatf("Coverage Output: %0.2f%%", alu_cov_outputs.get_coverage()
              ), UVM_MEDIUM)
  endfunction
endclass
