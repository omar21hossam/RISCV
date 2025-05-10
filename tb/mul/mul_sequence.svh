class mul_seq extends uvm_sequence #(mul_seq_item);
  `uvm_object_utils(mul_seq)

  // Declare the data members
    mul_seq_item seq_item;

  // Constructor
  function new(string name = "mul_seq");
    super.new(name);
  endfunction

  // Build phase
  task pre_body();
    // Create the sequence item
    seq_item = mul_seq_item::type_id::create("seq_item");
  endtask

  task body();
    // Set the default values for the sequence item
    start_item(seq_item);
    seq_item.randomize() with {
      rst_n == 0;
    };
    finish_item(seq_item);
    start_item(seq_item);
    seq_item.rst_n = 1;
    seq_item.enable_i = 1;
    seq_item.operator_i = riscv_pkg::MUL_H;

    seq_item.short_subword_i = 1'b0;
    seq_item.short_signed_i = 2'b01;

    seq_item.operand_a_i = 32'd2589750257;
    seq_item.operand_b_i = 32'd3285378231;
    seq_item.operand_c_i = 32'd0;
    seq_item.imm_i = 5'd0;

    seq_item.dot_signed_i = 2'b00;
    seq_item.dot_op_a_i = 32'd0;
    seq_item.dot_op_b_i = 32'd0;
    seq_item.dot_op_c_i = 32'd0;

    seq_item.is_clpx_i = 1'b0;
    seq_item.clpx_shift_i = 2'd0;
    seq_item.clpx_img_i = 1'd0;

    seq_item.ex_ready_i = 1'b0;
    finish_item(seq_item);
    // Loop to generate sequence items
    // for (int i = 0; i < 10; i++) begin
    //   start_item(seq_item);
    //   seq_item.randomize() with {
    //     rst_n == 1;
    //   };
    //   finish_item(seq_item);
    //end
    endtask

  endclass : mul_seq