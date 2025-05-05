class lsu_subscriber #(
    type T = lsu_sequence_item
) extends uvm_subscriber #(lsu_sequence_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_subscriber)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_sequence_item m_seq_item;

  //==================================================================================
  // Covergroup: Input Transactions
  //==================================================================================
  covergroup cov_inputs;

    // Execute Stage Signals
    // ---------------------------------------------------
    c_memory_operations: coverpoint m_seq_item.data_we_ex_i {
      bins load = {riscv_pkg::LOAD}; bins store = {riscv_pkg::STORE};
    }

    c_access_sizes: coverpoint m_seq_item.data_type_ex_i {
      bins byte_ = {riscv_pkg::BYTE1, riscv_pkg::BYTE2};
      bins half = {riscv_pkg::HALF};
      bins word = {riscv_pkg::WORD};
    }

    c_extend_types: coverpoint m_seq_item.data_sign_ext_ex_i {
      bins zero_ext = {riscv_pkg::ZERO_EXT};
      bins sign_ext = {riscv_pkg::SIGN_EXT};
      illegal_bins other = default;
    }

    c_misaligned_access: coverpoint m_seq_item.data_misaligned_ex_i {
      bins misaligned = {1'b1}; bins aligned = {1'b0};
    }

    //==================================================================================
    // Cross Coverage: Input Interactions
    //==================================================================================
    cross_all_variants: cross c_memory_operations, c_access_sizes, c_extend_types, c_misaligned_access {
      bins lb_align = binsof(c_memory_operations.load) &&
                      binsof(c_access_sizes.byte_) &&
                      binsof(c_extend_types.sign_ext) &&
                      binsof(c_misaligned_access.aligned);

      bins lbu_align = binsof(c_memory_operations.load) &&
                        binsof(c_access_sizes.byte_) &&
                        binsof(c_extend_types.zero_ext) &&
                        binsof(c_misaligned_access.aligned);

      bins lh_align = binsof(c_memory_operations.load) &&
                      binsof(c_access_sizes.half) &&
                      binsof(c_extend_types.sign_ext) &&
                      binsof(c_misaligned_access.aligned);

      bins lhu_align = binsof(c_memory_operations.load) &&
                        binsof(c_access_sizes.half) &&
                        binsof(c_extend_types.zero_ext) &&
                        binsof(c_misaligned_access.aligned);

      bins lw_align = binsof(c_memory_operations.load) &&
                      binsof(c_access_sizes.word) &&
                      binsof(c_misaligned_access.aligned);

      bins lh_misalign = binsof(c_memory_operations.load) &&
                          binsof(c_access_sizes.half) &&
                          binsof(c_extend_types.sign_ext) &&
                          binsof(c_misaligned_access.misaligned);

      bins lhu_misalign =  binsof(c_memory_operations.load) &&
                            binsof(c_access_sizes.half) &&
                            binsof(c_extend_types.zero_ext) &&
                            binsof(c_misaligned_access.misaligned);

      bins lw_misalign = binsof(c_memory_operations.load) &&
                          binsof(c_access_sizes.word) &&
                          binsof(c_misaligned_access.misaligned);

      bins sb_align = binsof(c_memory_operations.store) &&
                      binsof(c_access_sizes.byte_) &&
                      binsof(c_misaligned_access.aligned);

      bins sh_align = binsof(c_memory_operations.store) &&
                      binsof(c_access_sizes.half) &&
                      binsof(c_misaligned_access.aligned);

      bins sw_align =  binsof(c_memory_operations.store) &&
                        binsof(c_access_sizes.word) &&
                        binsof(c_misaligned_access.aligned);

      bins sh_misalign = binsof(c_memory_operations.store) &&
                          binsof(c_access_sizes.half) &&
                          binsof(c_misaligned_access.misaligned);

      bins sw_misalign = binsof(c_memory_operations.store) &&
                          binsof(c_access_sizes.word) &&
                          binsof(c_misaligned_access.misaligned);

    }
  endgroup



  //==================================================================================
  // Covergroup: Output Transactions
  //==================================================================================
  covergroup cov_outputs;

    // Execute Stage Signals
    // ---------------------------------------------------
    c_misaligned_access: coverpoint m_seq_item.data_misaligned_o {
      bins misaligned = {1'b1}; bins aligned = {1'b0};
    }

    // OBI External Bus Interface Signals
    // ---------------------------------------------------
    c_obi_type: coverpoint m_seq_item.data_we_o {
      bins store = {1'b1}; bins load = {1'b0};
    }

    c_obi_byte_mask: coverpoint m_seq_item.data_be_o {
      bins word_mask[] = {4'b1111, 4'b1110, 4'b1100, 4'b1000};
      bins half_mask[] = {4'b0011, 4'b1100, 4'b0110, 4'b1000};
      bins byte_mask[] = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
    }
  endgroup

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_subscriber", uvm_component parent = null);
    super.new(name, parent);

    // Construction of embedded covergroup (defined in a class) is not supported
    // except in constructor 'new()' of covergroup's parent class
    cov_inputs  = new();
    cov_outputs = new();
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Subscriber", UVM_HIGH);
  endfunction

  //==================================================================================
  // Function: Write
  //==================================================================================
  function void write(T t);
    m_seq_item = t;
    cov_inputs.sample();
    cov_outputs.sample();
  endfunction

endclass
