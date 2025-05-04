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
  // ======== Execute Stage Signals ======== //
  rand riscv_pkg::we_e            data_we_ex_i;
  rand riscv_pkg::type_e          data_type_ex_i;
  rand logic               [31:0] data_wdata_ex_i;
  rand riscv_pkg::extend_e        data_sign_ext_ex_i;
  rand logic                      data_req_ex_i;
  rand logic               [31:0] operand_a_ex_i;
  rand logic               [31:0] operand_b_ex_i;
  rand logic               [31:0] effective_addr;
  rand logic                      data_misaligned_ex_i;
  logic                           data_misaligned_o;
  logic                    [31:0] data_rdata_ex_o;
  logic                           lsu_ready_ex_o;
  logic                           lsu_ready_wb_o;
  logic                           busy_o;

  // ======== OBI External Bus Interface Signals ======== //
  rand logic               [31:0] data_rdata_i;
  logic                           data_gnt_i;
  logic                           data_rvalid_i;
  logic                           data_req_o;
  logic                    [31:0] data_addr_o;
  logic                           data_we_o;
  logic                    [ 3:0] data_be_o;
  logic                    [31:0] data_wdata_o;
  rand int unsigned               latency;

  //==================================================================================
  // Constraints
  //==================================================================================
  constraint memory_op_type_c {
    data_we_ex_i dist {
      riscv_pkg::LOAD  := 50,
      riscv_pkg::STORE := 50
    };
  }

  constraint access_size_c {
    data_type_ex_i dist {
      {riscv_pkg::BYTE1, riscv_pkg::BYTE2} :/ 100,
      riscv_pkg::HALF := 100,
      riscv_pkg::WORD := 100
    };
  }

  constraint lsu_extend_type_c {
    data_sign_ext_ex_i inside {riscv_pkg::ZERO_EXT, riscv_pkg::SIGN_EXT};
  }

  constraint effective_address_c {effective_addr == operand_a_ex_i + operand_b_ex_i;}

  constraint no_misalign_c {
    data_type_ex_i == riscv_pkg::WORD -> effective_addr[1:0] == 2'b00;
    data_type_ex_i == riscv_pkg::HALF -> effective_addr[0] == 1'b0;
  }

  constraint misalign_flag_c {
    (((data_type_ex_i == riscv_pkg::WORD) && (effective_addr[1:0] != 2'b00)) ||
   ((data_type_ex_i ==riscv_pkg::HALF) && (effective_addr[0] != 1'b0))) <-> (data_misaligned_ex_i == 1'b1);
  }

  constraint min_delay_c {latency == 0;}

  function void print();
    $display("data_we_ex_i         = %s", data_we_ex_i);
    $display("data_type_ex_i       = %s", data_type_ex_i);
    $display("data_wdata_ex_i      = %8h", data_wdata_ex_i);
    $display("data_sign_ext_ex_i   = %s", data_sign_ext_ex_i);
    $display("data_req_ex_i        = %1b", data_req_ex_i);
    $display("operand_a_ex_i       = %8h", operand_a_ex_i);
    $display("operand_b_ex_i       = %8h", operand_b_ex_i);
    $display("data_misaligned_ex_i = %1b", data_misaligned_ex_i);
    $display("data_misaligned_o    = %1b", data_misaligned_o);
    $display("data_rdata_ex_o      = %8h", data_rdata_ex_o);
    $display("lsu_ready_ex_o       = %1b", lsu_ready_ex_o);
    $display("lsu_ready_wb_o       = %1b", lsu_ready_wb_o);
    $display("busy_o               = %1b", busy_o);
    $display("data_rdata_i         = %8h", data_rdata_i);
    $display("data_gnt_i           = %1b", data_gnt_i);
    $display("data_rvalid_i        = %1b", data_rvalid_i);
    $display("data_req_o           = %1b", data_req_o);
    $display("data_addr_o          = %8h", data_addr_o);
    $display("data_we_o            = %1b", data_we_o);
    $display("data_be_o            = %2b", data_be_o);
    $display("data_wdata_o         = %8h", data_wdata_o);
  endfunction

endclass
