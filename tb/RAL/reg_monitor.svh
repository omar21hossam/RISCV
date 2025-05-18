
class reg_monitor extends uvm_monitor;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(reg_monitor)

  //==================================================================================
  // Configurations
  //==================================================================================
  virtual reg_if reg_intf;

  //==================================================================================
  // Classes Handles
  //==================================================================================
  ral_model m_ral_model;
  uvm_status_e status;
  reg_sequence_item seq_item_alu;
  reg_sequence_item seq_item_mul;
  reg_sequence_item seq_item_lsu;
  reg_sequence_item seq_item_jump;

  //==================================================================================
  // TLM
  //==================================================================================
  uvm_analysis_port #(reg_sequence_item) alu_ap;
  uvm_analysis_port #(reg_sequence_item) mul_ap;
  uvm_analysis_port #(reg_sequence_item) lsu_ap;
  uvm_analysis_port #(reg_sequence_item) jump_ap;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name, uvm_component parent);
    super.new(name, parent);
    alu_ap  = new("alu_ap", this);
    mul_ap  = new("mul_ap", this);
    lsu_ap  = new("lsu_ap", this);
    jump_ap = new("jump_ap", this);
  endfunction


  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building REG Monitor", UVM_HIGH);

    // Creation
    // ----------------------------------------------------------------------------
    seq_item_alu  = reg_sequence_item::type_id::create("seq_item_alu");
    seq_item_mul  = reg_sequence_item::type_id::create("seq_item_mul");
    seq_item_lsu  = reg_sequence_item::type_id::create("seq_item_lsu");
    seq_item_jump = reg_sequence_item::type_id::create("seq_item_jump");


    // Configuration
    // ----------------------------------------------------------------------------
    // get the interface
    // ----------------------
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "reg_intf", reg_intf)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for reg_if");
    end
    // get the RAL model
    // ----------------------
    if (!uvm_config_db#(ral_model)::get(this, "", "ral_model", m_ral_model)) begin
      `uvm_fatal(get_full_name(), "Failed to get configuration for RAL model");
    end

  endfunction

  //==================================================================================
  // Function: Run Phase
  //==================================================================================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin : forever_loop
      fork
        // ALU and DIV
        // ---------------------------------------------------------------------------------------
        begin
          // Detect an ALU operation
          @(posedge reg_intf.alu_filter_valid iff reg_intf.alu_en_i) #1step;

          // Sample the ALU sequence item
          // --------------------------------------------
          sample (seq_item_alu);

          // Read the Register File content
          // --------------------------------------------
          @(negedge reg_intf.clk or
            negedge reg_intf.alu_filter_valid or
            posedge reg_intf.jump_done or
            reg_intf.alu_operator_i);
          #1step;

          // In case of a jump, we need to disable the forever loop
          // Also, In case of a change in the ALU operator, we need to disable the forever loop
          if (reg_intf.jump_done || (reg_intf.alu_operator_i != seq_item_alu.alu_operator_i)) begin
            disable forever_loop;
          end
          // If the ALU filter is valid, we need to check if the ALU result is different from the sampled one
          else if (
            reg_intf.alu_filter_valid &&
            (reg_intf.regfile_alu_waddr_fw_o == seq_item_alu.regfile_alu_waddr_fw_o) &&
            (seq_item_alu.alu_result != reg_intf.alu_result)
          )
          begin
            #1step;
            seq_item_alu.alu_result = reg_intf.alu_result;
          end  // If the ALU filter is not valid, we need to read the register file early
          else if (!reg_intf.alu_filter_valid) begin
            #1step;
            m_ral_model.gpr[seq_item_alu.regfile_alu_waddr_fw_o].read(status, seq_item_alu.actual_gpr,
                                                                      UVM_BACKDOOR);
            alu_ap.write(seq_item_alu);
            disable forever_loop;
          end

          // Wait for the ALU filter to be deasserted
          // --------------------------------------------
          @(
            negedge reg_intf.alu_filter_valid
            or posedge reg_intf.jump_done
            or reg_intf.alu_operator_i
          )
          #1step;

          // In case of a jump, we need to disable the forever loop
          // Also, In case of a change in the ALU operator, we need to disable the forever loop
          if (reg_intf.jump_done || (reg_intf.alu_operator_i != seq_item_alu.alu_operator_i)) begin
            disable forever_loop;
          end

          // Read the Register File content
          // --------------------------------------------
          m_ral_model.gpr[seq_item_alu.regfile_alu_waddr_fw_o].read(status, seq_item_alu.actual_gpr,
                                                                    UVM_BACKDOOR);

          // Send the sequence item to the analysis port
          // --------------------------------------------
          alu_ap.write(seq_item_alu);
        end

        // MUL
        // ---------------------------------------------------------------------------------------
        begin
          // Detect a MUL operation
          @(posedge reg_intf.mult_en_i) #1step;

          // In case of multicycle multiplication, we will sample after the alu_filter_valid is asserted
          if (reg_intf.mult_operator_i == cv32e40p_pkg::MUL_H) begin
            @(posedge reg_intf.alu_filter_valid) #1step;
          end
          #1step;

          // Sample the MUL sequence item
          // --------------------------------------------
          sample (seq_item_mul);

          // Wait for the mult_en_i to be deasserted
          // --------------------------------------------
          @(negedge reg_intf.mult_en_i) #1step;

          // Read the Register File content
          // --------------------------------------------
          m_ral_model.gpr[seq_item_mul.regfile_alu_waddr_fw_o].read(status, seq_item_mul.actual_gpr,
                                                                    UVM_BACKDOOR);

          // Send the sequence item to the analysis port
          // --------------------------------------------
          mul_ap.write(seq_item_mul);
        end

        // LSU
        // ---------------------------------------------------------------------------------------
        begin
          // Detect a load operation
          @(posedge reg_intf.lsu_filter_valid) #1step;

          // Sample the LSU sequence item
          // --------------------------------------------
          sample (seq_item_lsu);

          // Wait for the LSU filter to be deasserted
          // So that, the read data stabilize
          // --------------------------------------------
          @(negedge reg_intf.lsu_filter_valid) #1step;

          // Read the Register File content
          // --------------------------------------------
          m_ral_model.gpr[seq_item_lsu.regfile_waddr_wb_o].read(status, seq_item_lsu.actual_gpr,
                                                                UVM_BACKDOOR);

          // Send the sequence item to the analysis port
          // --------------------------------------------
          lsu_ap.write(seq_item_lsu);
        end

        // Jump
        // ---------------------------------------------------------------------------------------
        begin
          // Detect a jump operation
          @(posedge reg_intf.jump_done) #1step;

          // Filter the jump detection to avoid false positives
          // --------------------------------------------
          if (reg_intf.jump_done) begin

            // Wait for the jump_done to be deasserted
            @(negedge reg_intf.jump_done) #1step;

            // Sample the jump sequence item
            // --------------------------------------------
            sample (seq_item_jump);

            // Wait for the next clock cycle
            // So that, the data is written to the register file
            // --------------------------------------------
            @(posedge reg_intf.clk) #1step;
            m_ral_model.gpr[seq_item_jump.regfile_alu_waddr_fw_o].read(status, seq_item_jump.actual_gpr,
                                                                       UVM_BACKDOOR);

            // Send the sequence item to the analysis port
            // --------------------------------------------
            jump_ap.write(seq_item_jump);
          end
        end
      join_any
    end
  endtask

  //==================================================================================
  // Function: Sample
  //==================================================================================
  function void sample (input reg_sequence_item seq_item);
    // Sample the Ex stage signals
    seq_item.rst_n                  = reg_intf.rst_n;
    seq_item.alu_en_i               = reg_intf.alu_en_i;
    seq_item.alu_operator_i         = reg_intf.alu_operator_i;
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
