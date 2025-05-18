class reg_monitor extends uvm_monitor;
  `uvm_component_utils(reg_monitor)

  // Interface
  virtual reg_if reg_intf;
  ral_model m_ral_model;
  uvm_status_e status;

  // sequence item 
  reg_sequence_item seq_item;

  // Monitor signals
  uvm_analysis_port #(reg_sequence_item) ap;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction


  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Regfile interface
    //------------------------------------------
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "reg_intf", reg_intf)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for reg_if");
    end

    if (!uvm_config_db#(ral_model)::get(this, "", "ral_model", m_ral_model)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for RAL model");
    end
    // Create sequence item
    seq_item = reg_sequence_item::type_id::create("seq_item");
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge reg_intf.alu_filter_valid or posedge reg_intf.lsu_filter_valid or posedge reg_intf.jump_done)
      #1step;
      if (reg_intf.jump_done) begin
        @(negedge reg_intf.jump_done) #1step;
        sample ();

        @(posedge reg_intf.clk) #1step;
        m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o,
                                                               UVM_BACKDOOR);
      end ///////////////////////////////////////////////////////////////////////////////////////
      else begin
        sample ();
        fork
          begin
            @(posedge reg_intf.clk) #1step;
            if ((seq_item.alu_result != reg_intf.alu_result) && (seq_item.regfile_alu_waddr_fw_o == reg_intf.regfile_alu_waddr_fw_o) && reg_intf.alu_filter_valid )
              seq_item.alu_result = reg_intf.alu_result;
          end

          begin
            if (seq_item.mult_en_i) begin
              @(negedge reg_intf.mult_en_i) #1step;
              m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o,
                                                                     UVM_BACKDOOR);
            end else begin
              // Sample the reference signal 
              if (reg_intf.alu_filter_valid && !reg_intf.lsu_filter_valid) begin
                @(negedge reg_intf.alu_filter_valid or posedge reg_intf.jump_done) #1step;
                if (reg_intf.jump_done && reg_intf.alu_filter_valid) begin
                  @(negedge reg_intf.jump_done) #1step;
                  sample ();
                  @(posedge reg_intf.clk) #1step;
                  m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o,
                                                                         UVM_BACKDOOR);
                end else begin
                  m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o,
                                                                         UVM_BACKDOOR);
                end
              end ///////////////////////////////////////////////////////////////////////////////////////
            else if (!reg_intf.alu_filter_valid && reg_intf.lsu_filter_valid) begin
                @(negedge reg_intf.lsu_filter_valid) #1step;
                m_ral_model.regs[seq_item.regfile_waddr_wb_o].read(status, seq_item.ref_o,
                                                                   UVM_BACKDOOR);
              end ///////////////////////////////////////////////////////////////////////////////////////
            else if (reg_intf.alu_filter_valid && reg_intf.lsu_filter_valid) begin
                if (seq_item.regfile_waddr_wb_o == seq_item.regfile_alu_waddr_fw_o) begin
                  @(negedge reg_intf.alu_filter_valid) #1step;
                  m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o,
                                                                         UVM_BACKDOOR);
                end ///////////////////////////////////////////////////////////////////////////////////////
              else begin
                  @(negedge reg_intf.alu_filter_valid) #1step;
                  seq_item.data_rvalid_i = 1'b0;
                  m_ral_model.regs[seq_item.regfile_alu_waddr_fw_o].read(status, seq_item.ref_o,
                                                                         UVM_BACKDOOR);
                  ap.write(seq_item);
                  #1step;
                  seq_item.alu_en_i = 1'b0;
                  seq_item.mult_en_i = 1'b0;
                  seq_item.data_rvalid_i = 1'b1;
                  if (reg_intf.data_rvalid_i == 1'b1) begin
                    @(negedge reg_intf.data_rvalid_i) #1step;
                  end
                  m_ral_model.regs[seq_item.regfile_waddr_wb_o].read(status, seq_item.ref_o,
                                                                     UVM_BACKDOOR);
                end  ///////////////////////////////////////////////////////////////////////////////////////
              end  ///////////////////////////////////////////////////////////////////////////////////////
            end
          end

        join

      end  ///////////////////////////////////////////////////////////////////////////////////////
      // Send the sequence item to the analysis port
      ap.write(seq_item);
    end
  endtask

  function void sample ();
    // Sample the Ex stage signals
    seq_item.rst_n                  = reg_intf.rst_n;
    seq_item.alu_en_i               = reg_intf.alu_en_i;
    seq_item.mult_en_i              = reg_intf.mult_en_i;
    seq_item.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o;
    seq_item.regfile_alu_we_fw_o    = reg_intf.regfile_alu_we_fw_o;
    seq_item.ex_valid_o             = reg_intf.ex_valid_o;
    seq_item.alu_result             = reg_intf.alu_result;
    seq_item.mult_result            = reg_intf.mult_result;
    // Sample the LSU signals
    seq_item.regfile_waddr_wb_o     = reg_intf.regfile_waddr_wb_o;
    seq_item.regfile_we_wb_power_o  = reg_intf.regfile_we_wb_power_o;
    seq_item.data_rvalid_i          = reg_intf.lsu_filter_valid;
    seq_item.data_misaligned_ex_i   = reg_intf.data_misaligned_ex_i;
    seq_item.lsu_rdata_i            = reg_intf.lsu_rdata_i;
  endfunction
endclass


