class lsu_active_driver #(
    type REQ = lsu_sequence_item,
    type RSP = REQ
) extends lsu_driver #(lsu_sequence_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_active_driver)

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_sequence_item m_seq_item;

  //==================================================================================
  // Configurations
  //==================================================================================
  virtual lsu_if vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Driver", UVM_HIGH);

    // Creation
    // ---------
    m_seq_item = lsu_sequence_item::type_id::create("m_seq_item");

    // Configuration
    // -------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    reset();
    forever begin
      seq_item_port.get_next_item(m_seq_item);
      drv_lsu_ex();
      obi_rsp_hndlr();
      #1step;
      seq_item_port.item_done();
    end
  endtask

  //==================================================================================
  // Task: reset
  //==================================================================================
  task reset();
    `uvm_info(get_name(), "Resetting LSU Driver", UVM_HIGH);
    vif.rst_n                = 1'b0;
    vif.data_we_ex_i         = riscv_pkg::LOAD;
    vif.data_type_ex_i       = riscv_pkg::BYTE1;
    vif.data_wdata_ex_i      = 'b0;
    vif.data_sign_ext_ex_i   = riscv_pkg::SIGN_EXT;
    vif.data_req_ex_i        = 'b0;
    vif.operand_a_ex_i       = 'b0;
    vif.operand_b_ex_i       = 'b0;
    vif.data_misaligned_ex_i = 'b0;
    vif.data_gnt_i           = 1'b0;
    vif.data_rdata_i         = 'b0;
    vif.data_rvalid_i        = 1'b0;
    repeat (3) @(negedge vif.clk);
    vif.rst_n = 1'b1;
  endtask

  //==================================================================================
  // Task: drive LSU signals at EX stage
  //==================================================================================
  task drv_lsu_ex();
    @(negedge vif.clk iff vif.lsu_ready_ex_o);
    `uvm_info(get_name(), "Driving LSU EX stage signals", UVM_HIGH);
    vif.data_req_ex_i        = 1'b1;
    vif.data_we_ex_i         = m_seq_item.data_we_ex_i;
    vif.data_type_ex_i       = m_seq_item.data_type_ex_i;
    vif.data_wdata_ex_i      = m_seq_item.data_wdata_ex_i;
    vif.data_sign_ext_ex_i   = m_seq_item.data_sign_ext_ex_i;
    vif.operand_a_ex_i       = m_seq_item.operand_a_ex_i;
    vif.operand_b_ex_i       = m_seq_item.operand_b_ex_i;
    vif.data_misaligned_ex_i = 1'b0;
  endtask

  //==================================================================================
  // Task: OBI response handler
  //==================================================================================
  task obi_rsp_hndlr();
    @(negedge vif.clk iff vif.data_req_o);
    `uvm_info(get_name(), $sformatf(
              "Handling OBI response [addr = %0h, type = %1b, byte-mask = %4b, data = %0h]",
              vif.data_addr_o,
              vif.data_we_o,
              vif.data_be_o,
              vif.data_wdata_o
              ), UVM_HIGH);

    // Sample OBI response signals
    m_seq_item.data_addr_o = vif.data_addr_o;
    m_seq_item.data_we_o = vif.data_we_o;
    m_seq_item.data_be_o = vif.data_be_o;
    m_seq_item.data_misaligned_o = vif.data_misaligned_o;

    // Grant the OBI request
    vif.data_gnt_i = 1'b1;
    @(negedge vif.clk);
    vif.data_gnt_i = 1'b0;
    vif.data_req_ex_i = (m_seq_item.data_misaligned_o) ? 1'b1 : 1'b0;
    vif.data_misaligned_ex_i = (m_seq_item.data_misaligned_o) ? 1'b1 : 1'b0;
    wait_for_response();

    // Response to the OBI request
    if (m_seq_item.data_we_o == riscv_pkg::LOAD) begin
      // Load the data and then validate the response
      vif.data_rdata_i  = m_seq_item.data_rdata_i;
      vif.data_rvalid_i = 1'b1;
    end else if (m_seq_item.data_we_o == riscv_pkg::STORE) begin
      // Ignore the store data and just set the valid signal
      vif.data_rvalid_i = 1'b1;
    end

    // Deassert the valid signal after a clock cycle
    @(negedge vif.clk);
    vif.data_rvalid_i = 1'b0;

    // in case of misalignment
    // -------------------------------------------------
    @(negedge vif.clk);
    if (m_seq_item.data_misaligned_o) begin
      // Sample OBI response signals
      m_seq_item.data_addr_o = vif.data_addr_o;
      m_seq_item.data_we_o = vif.data_we_o;
      m_seq_item.data_be_o = vif.data_be_o;

      // Grant the OBI request
      vif.data_gnt_i = 1'b1;
      @(negedge vif.clk);
      vif.data_gnt_i = 1'b0;
      vif.data_req_ex_i = 1'b0;
      vif.data_misaligned_ex_i = 1'b0;

      // Response to the OBI request
      if (m_seq_item.data_we_o == riscv_pkg::LOAD) begin
        // Load the data and then validate the response
        vif.data_rdata_i  = m_seq_item.data_rdata_next_i;
        vif.data_rvalid_i = 1'b1;
      end else if (m_seq_item.data_we_o == riscv_pkg::STORE) begin
        // Ignore the strore data and just set the valid signal
        vif.data_rvalid_i = 1'b1;
      end

      // Deassert the valid signal after a clock cycle
      @(negedge vif.clk);
      vif.data_rvalid_i = 1'b0;
    end
  endtask

  //==================================================================================
  // Task: wait_for_response
  //==================================================================================
  task wait_for_response();
    while (m_seq_item.latency > 0) begin
      @(negedge vif.clk) m_seq_item.latency--;
    end
    @(negedge vif.clk);
  endtask
endclass
