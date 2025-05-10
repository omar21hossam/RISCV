class riscv_main_driver extends uvm_driver #(riscv_sequence_item);
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_main_driver)

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual riscv_if riscv_vif;

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item seq_item_rsp;  //driver will respond 

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_main_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual riscv_if)::get(this, "", "riscv_intf", riscv_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for riscv intf in driver");
    end
    seq_item_rsp = riscv_sequence_item::type_id::create("seq_item_rsp");
  endfunction

  //==================================================================================
  // Function: Reset
  //==================================================================================
  function void reset();
    riscv_vif.rst_ni              <= 0;
    riscv_vif.boot_addr_i         <= 0;
    riscv_vif.mtvec_addr_i        <= 0;
    riscv_vif.dm_halt_addr_i      <= 0;
    riscv_vif.hart_id_i           <= 0;
    riscv_vif.dm_exception_addr_i <= 0;
    riscv_vif.irq_i               <= 0;
    riscv_vif.debug_req_i         <= 0;
    riscv_vif.fetch_enable_i      <= 0;
    riscv_vif.pulp_clock_en_i     <= 0;
    riscv_vif.scan_cg_en_i        <= 0;
    riscv_vif.instr_gnt_i         <= 0;
    riscv_vif.instr_rvalid_i      <= 0;
    riscv_vif.instr_rdata_i       <= 0;

  endfunction

  //==================================================================================
  // task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // Reset the DUT
    reset();

    #(3 * riscv_pkg::CLK_FREQ);
    forever begin
      seq_item_port.get_next_item(seq_item_rsp);

      // Enable instruction fetching
      riscv_vif.rst_ni <= seq_item_rsp.rst_ni;
      riscv_vif.fetch_enable_i <= seq_item_rsp.fetch_enable_i;

      @(posedge riscv_vif.clk iff riscv_vif.instr_req_o);
      riscv_vif.instr_gnt_i <= 1;

      @(posedge riscv_vif.clk);
      riscv_vif.instr_rvalid_i <= 1;
      riscv_vif.instr_rdata_i  <= seq_item_rsp.instruction;

      seq_item_port.item_done();
    end
  endtask
endclass
