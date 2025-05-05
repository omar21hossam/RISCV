class alu_seq extends uvm_sequence #(alu_seq_item);
  `uvm_object_utils(alu_seq)

  // Declare the data members
    alu_seq_item seq_item;

  // Constructor
  function new(string name = "alu_seq");
    super.new(name);
  endfunction

  // // Build phase
  // task pre_body();
  //   // Create the sequence item
  //   seq_item = alu_seq_item::type_id::create("seq_item");
  // endtask

  task body();
    //**walid test sequence**//
    //===============================================================================
    // Set the initial values for the sequence item rst scenario
      seq_item = alu_seq_item::type_id::create("seq_item");
      // start_item(seq_item);
      // assert(seq_item.randomize() with {rst_n == 1'b0; enable_i == 1'b0; operator_i == ALU_ADD;ex_ready_i == 1'b0; operand_a_i ==4; operand_b_i==1;});
      // finish_item(seq_item);
    //Loop to generate sequence items
    for (int i = 0; i < 1000; i++) begin
      seq_item = alu_seq_item::type_id::create("seq_item");
      start_item(seq_item);
      assert(seq_item.randomize() with {rst_n == 1'b1;/*enable_i == 1'b1;/*(operator_i  inside{ALU_DIV,ALU_REM,ALU_DIVU,ALU_REMU,ALU_SRA});/*operand_b_i inside {[1:20]};*/ex_ready_i == 1'b1;});
      finish_item(seq_item);
      //================================================================================
    end
    endtask
  endclass : alu_seq
