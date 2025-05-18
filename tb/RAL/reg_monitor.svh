
class reg_monitor extends uvm_monitor;
  `uvm_component_utils(reg_monitor)

  // Interface
  virtual reg_if reg_intf;
  ral_model m_ral_model;
  uvm_status_e status;

  // sequence item 
  reg_sequence_item seq_item_alu;
  reg_sequence_item seq_item_mul;
  reg_sequence_item seq_item_lsu;
  reg_sequence_item seq_item_jump;

  // Monitor signals
  uvm_analysis_port #(reg_sequence_item) alu_ap;
  uvm_analysis_port #(reg_sequence_item) mul_ap;
  uvm_analysis_port #(reg_sequence_item) lsu_ap;
  uvm_analysis_port #(reg_sequence_item) jump_ap;

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    alu_ap  = new("alu_ap", this);
    mul_ap  = new("mul_ap", this);
    lsu_ap  = new("lsu_ap", this);
    jump_ap = new("jump_ap", this);
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
    seq_item_alu  = reg_sequence_item::type_id::create("seq_item_alu");
    seq_item_mul  = reg_sequence_item::type_id::create("seq_item_mul");
    seq_item_lsu  = reg_sequence_item::type_id::create("seq_item_lsu");
    seq_item_jump = reg_sequence_item::type_id::create("seq_item_jump");
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin : forever_loop
      fork
        // ALU and DIV
        // ---------------
        begin
          @(posedge reg_intf.alu_filter_valid iff reg_intf.alu_en_i) #1step;
          // Sample the Ex stage signals
          seq_item_alu.rst_n                  = reg_intf.rst_n;
          seq_item_alu.alu_en_i               = reg_intf.alu_en_i;
          seq_item_alu.alu_operator_i         = reg_intf.alu_operator_i;
          seq_item_alu.mult_en_i              = reg_intf.mult_en_i;
          seq_item_alu.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o;
          seq_item_alu.regfile_alu_we_fw_o    = reg_intf.regfile_alu_we_fw_o;
          seq_item_alu.ex_valid_o             = reg_intf.ex_valid_o;
          seq_item_alu.alu_result             = reg_intf.alu_result;
          seq_item_alu.mult_result            = reg_intf.mult_result;
          // Sample the LSU signals
          seq_item_alu.regfile_waddr_wb_o     = reg_intf.regfile_waddr_wb_o;
          seq_item_alu.regfile_we_wb_power_o  = reg_intf.regfile_we_wb_power_o;
          seq_item_alu.data_rvalid_i          = reg_intf.lsu_filter_valid;
          seq_item_alu.data_misaligned_ex_i   = reg_intf.data_misaligned_ex_i;
          seq_item_alu.lsu_rdata_i            = reg_intf.lsu_rdata_i;

          @(negedge reg_intf.clk or negedge reg_intf.alu_filter_valid or posedge reg_intf.jump_done or reg_intf.alu_operator_i);
          #1step;
          if (reg_intf.jump_done || (reg_intf.alu_operator_i != seq_item_alu.alu_operator_i)) begin
            disable forever_loop;
          end
          else if (reg_intf.alu_filter_valid && (reg_intf.regfile_alu_waddr_fw_o == seq_item_alu.regfile_alu_waddr_fw_o) && (seq_item_alu.alu_result != reg_intf.alu_result))
              begin
            #1step;
            seq_item_alu.alu_result = reg_intf.alu_result;
          end else if (!reg_intf.alu_filter_valid) begin
            #1step;
            m_ral_model.regs[seq_item_alu.regfile_alu_waddr_fw_o].read(status, seq_item_alu.ref_o,
                                                                       UVM_BACKDOOR);
            alu_ap.write(seq_item_alu);
            disable forever_loop;
          end
          @(negedge reg_intf.alu_filter_valid or posedge reg_intf.jump_done or reg_intf.alu_operator_i)
          #1step;
          if (reg_intf.jump_done || (reg_intf.alu_operator_i != seq_item_alu.alu_operator_i)) begin
            disable forever_loop;
          end
          m_ral_model.regs[seq_item_alu.regfile_alu_waddr_fw_o].read(status, seq_item_alu.ref_o,
                                                                     UVM_BACKDOOR);

          // Send the sequence item to the analysis port
          alu_ap.write(seq_item_alu);
        end

        // MUL
        // ---------------
        begin
          @(posedge reg_intf.mult_en_i) #1step;
          if (reg_intf.mult_operator_i == cv32e40p_pkg::MUL_H) begin
            @(posedge reg_intf.alu_filter_valid) #1step;
          end
          #1step;
          // Sample the Ex stage signals
          seq_item_mul.rst_n                  = reg_intf.rst_n;
          seq_item_mul.alu_en_i               = reg_intf.alu_en_i;
          seq_item_mul.mult_en_i              = reg_intf.mult_en_i;
          seq_item_mul.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o;
          seq_item_mul.regfile_alu_we_fw_o    = reg_intf.regfile_alu_we_fw_o;
          seq_item_mul.ex_valid_o             = reg_intf.ex_valid_o;
          seq_item_mul.alu_result             = reg_intf.alu_result;
          seq_item_mul.mult_result            = reg_intf.mult_result;
          // Sample the LSU signals
          seq_item_mul.regfile_waddr_wb_o     = reg_intf.regfile_waddr_wb_o;
          seq_item_mul.regfile_we_wb_power_o  = reg_intf.regfile_we_wb_power_o;
          seq_item_mul.data_rvalid_i          = reg_intf.lsu_filter_valid;
          seq_item_mul.data_misaligned_ex_i   = reg_intf.data_misaligned_ex_i;
          seq_item_mul.lsu_rdata_i            = reg_intf.lsu_rdata_i;
          @(negedge reg_intf.mult_en_i) #1step;
          m_ral_model.regs[seq_item_mul.regfile_alu_waddr_fw_o].read(status, seq_item_mul.ref_o,
                                                                     UVM_BACKDOOR);

          // Send the sequence item to the analysis port
          mul_ap.write(seq_item_mul);
        end

        // LSU
        // ---------------
        begin
          @(posedge reg_intf.lsu_filter_valid) #1step;
          // Sample the Ex stage signals
          seq_item_lsu.rst_n                  = reg_intf.rst_n;
          seq_item_lsu.alu_en_i               = reg_intf.alu_en_i;
          seq_item_lsu.mult_en_i              = reg_intf.mult_en_i;
          seq_item_lsu.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o;
          seq_item_lsu.regfile_alu_we_fw_o    = reg_intf.regfile_alu_we_fw_o;
          seq_item_lsu.ex_valid_o             = reg_intf.ex_valid_o;
          seq_item_lsu.alu_result             = reg_intf.alu_result;
          seq_item_lsu.mult_result            = reg_intf.mult_result;
          // Sample the LSU signals
          seq_item_lsu.regfile_waddr_wb_o     = reg_intf.regfile_waddr_wb_o;
          seq_item_lsu.regfile_we_wb_power_o  = reg_intf.regfile_we_wb_power_o;
          seq_item_lsu.data_rvalid_i          = reg_intf.lsu_filter_valid;
          seq_item_lsu.data_misaligned_ex_i   = reg_intf.data_misaligned_ex_i;
          seq_item_lsu.lsu_rdata_i            = reg_intf.lsu_rdata_i;

          @(negedge reg_intf.lsu_filter_valid) #1step;
          m_ral_model.regs[seq_item_lsu.regfile_waddr_wb_o].read(status, seq_item_lsu.ref_o,
                                                                 UVM_BACKDOOR);
          lsu_ap.write(seq_item_lsu);
        end

        // Jump
        // ---------------
        begin
          @(posedge reg_intf.jump_done) #1step;
          if (reg_intf.jump_done) begin
            @(negedge reg_intf.jump_done) #1step;
            // Sample the Ex stage signals
            seq_item_jump.rst_n                  = reg_intf.rst_n;
            seq_item_jump.alu_en_i               = reg_intf.alu_en_i;
            seq_item_jump.mult_en_i              = reg_intf.mult_en_i;
            seq_item_jump.regfile_alu_waddr_fw_o = reg_intf.regfile_alu_waddr_fw_o;
            seq_item_jump.regfile_alu_we_fw_o    = reg_intf.regfile_alu_we_fw_o;
            seq_item_jump.ex_valid_o             = reg_intf.ex_valid_o;
            seq_item_jump.alu_result             = reg_intf.alu_result;
            seq_item_jump.mult_result            = reg_intf.mult_result;
            // Sample the LSU signals
            seq_item_jump.regfile_waddr_wb_o     = reg_intf.regfile_waddr_wb_o;
            seq_item_jump.regfile_we_wb_power_o  = reg_intf.regfile_we_wb_power_o;
            seq_item_jump.data_rvalid_i          = reg_intf.lsu_filter_valid;
            seq_item_jump.data_misaligned_ex_i   = reg_intf.data_misaligned_ex_i;
            seq_item_jump.lsu_rdata_i            = reg_intf.lsu_rdata_i;
            @(posedge reg_intf.clk) #1step;
            m_ral_model.regs[seq_item_jump.regfile_alu_waddr_fw_o].read(status, seq_item_jump.ref_o,
                                                                        UVM_BACKDOOR);
            jump_ap.write(seq_item_jump);
          end
        end
      join_any
    end
  endtask
endclass


