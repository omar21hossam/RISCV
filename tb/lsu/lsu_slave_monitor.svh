class lsu_slave_monitor extends uvm_monitor;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_slave_monitor)

  //==================================================================================
  // Interface
  //==================================================================================
  virtual lsu_if vif;

  //==================================================================================
  // TLM
  //==================================================================================
  uvm_analysis_port #(lsu_sequence_item) req_analysis_port;
  uvm_analysis_port #(lsu_sequence_item) rsp_analysis_port;

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_sequence_item m_req_seq_item;
  lsu_sequence_item m_rsp_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_slave_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Monitor", UVM_HIGH);

    // Creation
    // ---------
    m_req_seq_item = lsu_sequence_item::type_id::create("m_req_seq_item");
    m_rsp_seq_item = lsu_sequence_item::type_id::create("m_rsp_seq_item");

    // Configuration
    // -------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end

    // TLM
    // -------
    req_analysis_port = new("req_analysis_port", this);
    rsp_analysis_port = new("rsp_analysis_port", this);
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    forever begin

      fork
        begin
          @(posedge vif.data_req_ex_i iff vif.rst_n) #1step;
          m_req_seq_item.data_we_ex_i = vif.data_we_ex_i;
          m_req_seq_item.data_type_ex_i = vif.data_type_ex_i;
          m_req_seq_item.data_wdata_ex_i = vif.data_wdata_ex_i;
          m_req_seq_item.data_sign_ext_ex_i = vif.data_sign_ext_ex_i;
          m_req_seq_item.data_req_ex_i = vif.data_req_ex_i;
          m_req_seq_item.operand_a_ex_i = vif.operand_a_ex_i;
          m_req_seq_item.operand_b_ex_i = vif.operand_b_ex_i;
          m_req_seq_item.data_misaligned_ex_i = vif.data_misaligned_ex_i;
          #1step req_analysis_port.write(m_req_seq_item);
        end
        begin
          // Sampling Inputs from EX Stage
          @(posedge vif.data_gnt_i iff vif.rst_n) #1step;
          m_rsp_seq_item.data_we_ex_i = vif.data_we_ex_i;
          m_rsp_seq_item.data_type_ex_i = vif.data_type_ex_i;
          m_rsp_seq_item.data_wdata_ex_i = vif.data_wdata_ex_i;
          m_rsp_seq_item.data_sign_ext_ex_i = vif.data_sign_ext_ex_i;
          m_rsp_seq_item.data_req_ex_i = vif.data_req_ex_i;
          m_rsp_seq_item.operand_a_ex_i = vif.operand_a_ex_i;
          m_rsp_seq_item.operand_b_ex_i = vif.operand_b_ex_i;
          m_rsp_seq_item.data_misaligned_ex_i = vif.data_misaligned_ex_i;

          // Sampling External OBI Data Memory Interface Output Signals
          m_rsp_seq_item.data_req_o = vif.data_req_o;
          m_rsp_seq_item.data_addr_o = vif.data_addr_o;
          m_rsp_seq_item.data_we_o = vif.data_we_o;
          m_rsp_seq_item.data_be_o = vif.data_be_o;
          m_rsp_seq_item.data_wdata_o = vif.data_wdata_o;
          m_rsp_seq_item.data_misaligned_o = vif.data_misaligned_o;

          // Sampling External OBI Data Memory Interface Inputs Signals
          @(posedge vif.data_rvalid_i iff vif.rst_n) #1step;
          m_rsp_seq_item.data_rdata_i = vif.data_rdata_i;
          m_rsp_seq_item.data_gnt_i = vif.data_gnt_i;
          m_rsp_seq_item.data_rvalid_i = vif.data_rvalid_i;

          // Sampling Outputs to EX and WB Stages
          m_rsp_seq_item.data_rdata_ex_o = vif.data_rdata_ex_o;
          m_rsp_seq_item.lsu_ready_ex_o = vif.lsu_ready_ex_o;
          m_rsp_seq_item.lsu_ready_wb_o = vif.lsu_ready_wb_o;
          m_rsp_seq_item.busy_o = vif.busy_o;

          #1step rsp_analysis_port.write(m_rsp_seq_item);
        end
      join_any
    end
  endtask
endclass
