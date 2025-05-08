class lsu_sequence_item extends uvm_sequence_item;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(lsu_sequence_item)

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_sequence_item");
    super.new(name);
  endfunction

  //==================================================================================
  // Data Members
  //==================================================================================
  // Execute Stage Signals
  // ---------------------------------------------------
  rand riscv_pkg::we_e            data_we_ex_i;
  rand riscv_pkg::type_e          data_type_ex_i;
  rand logic               [31:0] data_wdata_ex_i;
  rand riscv_pkg::extend_e        data_sign_ext_ex_i;
  logic                           data_req_ex_i;
  rand logic               [31:0] operand_a_ex_i;
  rand logic               [31:0] operand_b_ex_i;
  rand logic               [31:0] effective_addr;
  logic                           data_misaligned_ex_i;
  logic                           data_misaligned_o;
  logic                    [31:0] data_rdata_ex_o;
  logic                           lsu_ready_ex_o;
  logic                           lsu_ready_wb_o;
  logic                           busy_o;

  // OBI External Bus Interface Signals
  // ---------------------------------------------------
  rand logic               [31:0] data_rdata_i;
  rand logic               [31:0] data_rdata_next_i;
  logic                           data_gnt_i;
  logic                           data_rvalid_i;
  logic                           data_req_o;
  logic                    [31:0] data_addr_o;
  logic                           data_we_o;
  logic                    [ 3:0] data_be_o;
  logic                    [31:0] data_wdata_o;
  rand int unsigned               latency;


  // Discarded Signals
  // ---------------------------------------------------
  logic                      data_err_i = 1'b0;
  logic                      data_err_pmp_i = 1'b0;
  logic                      data_load_event_ex_i = 1'b0;
  logic                      addr_useincr_ex_i = 1'b1;
  logic               [ 5:0] data_atop_ex_i = 6'b0;
  logic               [ 1:0] data_reg_offset_ex_i = 2'b0;
  logic               [ 5:0] data_atop_o = 6'b0;
  logic                      p_elw_start_o = 1'b0;
  logic                      p_elw_finish_o = 1'b0;

  //==================================================================================
  // Constraints
  //==================================================================================

  // Distributing the randomization to have load/store equally
  constraint memory_op_type_c {
    data_we_ex_i dist {
      riscv_pkg::LOAD  := 50,
      riscv_pkg::STORE := 50
    };
  }

  // Distributing the randomization to have all access sizes equally
  constraint access_size_c {
    data_type_ex_i dist {
      riscv_pkg::BYTE1 := 50,
      riscv_pkg::BYTE2 := 50,
      riscv_pkg::HALF  := 100,
      riscv_pkg::WORD  := 100
    };
  }

  // Constrainting the sign extension flag to be a valid value
  constraint lsu_extend_type_c {
    data_sign_ext_ex_i inside {riscv_pkg::ZERO_EXT, riscv_pkg::SIGN_EXT};
  }

  // Constrainting effective address to be the sum of the operands for later constraints
  constraint effective_address_c {effective_addr == operand_a_ex_i + operand_b_ex_i;}

  // Preventing the address to be misaligned
  // constraint no_misalign_c {
  //   data_type_ex_i == riscv_pkg::WORD -> effective_addr[1:0] == 2'b00;
  //   data_type_ex_i == riscv_pkg::HALF -> effective_addr[1:0] inside {2'b00, 2'b01, 2'b10};
  // }

  // Forcing the address to be misaligned
  // constraint only_misalign_c {
  //   data_type_ex_i == riscv_pkg::WORD -> effective_addr[1:0] inside {2'b01, 2'b10, 2'b11};
  //   data_type_ex_i == riscv_pkg::HALF -> effective_addr[0] == 1'b1;
  // }

  // Randomizing the OBI response latency
  constraint max_latency_c {latency < 5;}

  //==================================================================================
  // Function: do_print
  //==================================================================================
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    // Control Flags
    printer.print_field("data_req_ex_i", data_req_ex_i, $bits(data_req_ex_i), UVM_BIN);
    printer.print_field("data_req_o", data_req_o, $bits(data_req_o), UVM_BIN);
    printer.print_field("data_gnt_i", data_gnt_i, $bits(data_gnt_i), UVM_BIN);
    printer.print_field("data_rvalid_i", data_rvalid_i, $bits(data_rvalid_i), UVM_BIN);
    printer.print_field("lsu_ready_ex_o", lsu_ready_ex_o, $bits(lsu_ready_ex_o), UVM_BIN);
    printer.print_field("lsu_ready_wb_o", lsu_ready_wb_o, $bits(lsu_ready_wb_o), UVM_BIN);
    printer.print_field("busy_o", busy_o, $bits(busy_o), UVM_BIN);
    printer.print_field("data_misaligned_ex_i", data_misaligned_ex_i, $bits(data_misaligned_ex_i),
                        UVM_BIN);
    printer.print_field("data_misaligned_o", data_misaligned_o, $bits(data_misaligned_o), UVM_BIN);

    // Operation Signals
    printer.print_string("data_we_ex_i", data_we_ex_i.name());
    printer.print_string("data_type_ex_i", data_type_ex_i.name());
    printer.print_string("data_sign_ext_ex_i", data_sign_ext_ex_i.name());
    printer.print_field("data_we_o", data_we_o, $bits(data_we_o), UVM_BIN);
    printer.print_field("data_be_o", data_be_o, $bits(data_be_o), UVM_BIN);

    // Data Signals
    printer.print_field("data_rdata_i", data_rdata_i, $bits(data_rdata_i), UVM_HEX);
    printer.print_field("data_rdata_ex_o", data_rdata_ex_o, $bits(data_rdata_ex_o), UVM_HEX);
    printer.print_field("data_wdata_o", data_wdata_o, $bits(data_wdata_o), UVM_HEX);
    printer.print_field("data_wdata_ex_i", data_wdata_ex_i, $bits(data_wdata_ex_i), UVM_HEX);

    // Address
    printer.print_field("operand_a_ex_i", operand_a_ex_i, $bits(operand_a_ex_i), UVM_HEX);
    printer.print_field("operand_b_ex_i", operand_b_ex_i, $bits(operand_b_ex_i), UVM_HEX);
    printer.print_field("data_addr_o", data_addr_o, $bits(data_addr_o), UVM_BIN);
  endfunction

  // ==================================================================================
  // Function: do_copy
  // ==================================================================================
  function void do_copy(uvm_object rhs);
    lsu_sequence_item lsu_item;
    super.do_copy(rhs);

    if (!$cast(lsu_item, rhs)) begin
      `uvm_fatal(get_full_name(), "Invalid object type for copy");
    end
    data_we_ex_i = lsu_item.data_we_ex_i;
    data_type_ex_i = lsu_item.data_type_ex_i;
    data_wdata_ex_i = lsu_item.data_wdata_ex_i;
    data_sign_ext_ex_i = lsu_item.data_sign_ext_ex_i;
    data_req_ex_i = lsu_item.data_req_ex_i;
    operand_a_ex_i = lsu_item.operand_a_ex_i;
    operand_b_ex_i = lsu_item.operand_b_ex_i;
    data_misaligned_ex_i = lsu_item.data_misaligned_ex_i;
    data_misaligned_o = lsu_item.data_misaligned_o;
    data_rdata_ex_o = lsu_item.data_rdata_ex_o;
    lsu_ready_ex_o = lsu_item.lsu_ready_ex_o;
    lsu_ready_wb_o = lsu_item.lsu_ready_wb_o;
    busy_o = lsu_item.busy_o;
    data_rdata_i = lsu_item.data_rdata_i;
    data_gnt_i = lsu_item.data_gnt_i;
    data_rvalid_i = lsu_item.data_rvalid_i;
    data_req_o = lsu_item.data_req_o;
    data_addr_o = lsu_item.data_addr_o;
    data_we_o = lsu_item.data_we_o;
    data_be_o = lsu_item.data_be_o;
    data_wdata_o = lsu_item.data_wdata_o;
  endfunction

endclass
