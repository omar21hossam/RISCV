class fetch_coverage_collector extends uvm_component;
  `uvm_component_utils(fetch_coverage_collector)


  uvm_analysis_export #(fetch_seq_item) cov_export;
  uvm_tlm_analysis_fifo #(fetch_seq_item) cov_fifo;
//--------------------------------------------------
  uvm_analysis_export #(fetch_seq_item) cov_export_ip;
  uvm_tlm_analysis_fifo #(fetch_seq_item) cov_fifo_ip;
  fetch_seq_item seq_item_ip,seq_item_op;
  uvm_analysis_export #(fetch_seq_item) cov_export_op;
  uvm_tlm_analysis_fifo #(fetch_seq_item) cov_fifo_op;


//--------------------------------------------------


 covergroup op_instruction_cg;
        // Cover basic opcode categories (major categories only)
        opcode: coverpoint seq_item_op.instr_rdata_id_o[6:0] {
            // RV32I Base
            bins R_TYPE       = {riscv_pkg::OP_RTYPE};
            bins I_TYPE       = {riscv_pkg::OP_ITYPE,riscv_pkg::OP_JALR};
            bins U_TYPE       = {riscv_pkg::OP_LUI,riscv_pkg::OP_AUIPC};
            bins S_L_TYPE       = {riscv_pkg::OP_STORE,riscv_pkg::OP_LOAD};
            bins B_TYPE       = {riscv_pkg::OP_BRANCH};
            bins J_TYPE       = {riscv_pkg::OP_JAL};
        }
        
        // Cover func3 for major instruction types
        func3: coverpoint seq_item_op.instr_rdata_id_o[14:12] {
 
bins  ADD_SUB  = {riscv_pkg::ADD_SUB};
bins  SLL      = {riscv_pkg::SLL};
bins  SLT      = {riscv_pkg::SLT};
bins  SLTU     = {riscv_pkg::SLTU};
bins  XOR      = {riscv_pkg::XOR};
bins  SRL_SRA  = {riscv_pkg::SRL_SRA};
bins  OR       = {riscv_pkg::OR};
bins  AND      = {riscv_pkg::AND};
bins  MUL      = {riscv_pkg::MUL};
bins  MULH     = {riscv_pkg::MULH};
bins  MULHSU   = {riscv_pkg::MULHSU};
bins  MULHU    = {riscv_pkg::MULHU};
bins  DIV      = {riscv_pkg::DIV};
bins  DIVU     = {riscv_pkg::DIVU};
bins  REM      = {riscv_pkg::REM};
bins  REMU     = {riscv_pkg::REMU};
bins  ADDI_JALR= {riscv_pkg::ADDI_JALR};
bins  SLLI     = {riscv_pkg::SLLI};
bins  SLTI     = {riscv_pkg::SLTI};
bins  SLTIU    = {riscv_pkg::SLTIU};
bins  XORI     = {riscv_pkg::XORI};
bins  SRLI_SRAI= {riscv_pkg::SRLI_SRAI};
bins  ORI      = {riscv_pkg::ORI};
bins  ANDI     = {riscv_pkg::ANDI};            
bins  BEQ      = {riscv_pkg::BEQ};
bins  BNE      = {riscv_pkg::BNE};
bins  BLT      = {riscv_pkg::BLT};
bins  BGE      = {riscv_pkg::BGE};
bins  BLTU     = {riscv_pkg::BLTU};
bins  BGEU     = {riscv_pkg::BGEU};
bins  SB       = {riscv_pkg::SB};
bins  SH       = {riscv_pkg::SH}; 
bins  SW       = {riscv_pkg::SW};


        }
        
        // Cover func7 for R-type instructions
        func7: coverpoint seq_item_op.instr_rdata_id_o[31:25] {
            bins R_OTHER    = {riscv_pkg::R_OTHER};
            bins SUB_SRA    = {riscv_pkg::SUB_SRA};  // For sub/sra
            bins muldiv     = {riscv_pkg::M_FUNCT7};  // M extension
        }
        
        // Immediate types (just categories, not all values)
        immediate_s_type: coverpoint seq_item_op.instr_rdata_id_o[31:25] {
            bins s_type_1 = {7'h0};                
            bins s_type_2 = {7'h20};  
   
        }
        
      immediate_J_type: coverpoint seq_item_op.instr_rdata_id_o[21] {
            bins j_type_1 = {1'b0};                
   
        }
        
      immediate_B_type: coverpoint seq_item_op.instr_rdata_id_o[8] {
            bins B_type_1 ={1'b0};                
   
        }
        

        // Cross coverage between opcode and func3 (ni benefit)
    //    opcode_x_func3: cross opcode, func3;
                // Source register 1 - all 32 values
        rs1_val: coverpoint  seq_item_op.instr_rdata_id_o[19:15]  {
            bins reg_val[] = {[0:31]};
        }
        
        // Source register 2 - all 32 values  
        rs2_val: coverpoint   seq_item_op.instr_rdata_id_o[24:20]  {
            bins reg_val[] = {[0:31]};
        }
        
        // Destination register - all 32 values
        rd_val: coverpoint  seq_item_op.instr_rdata_id_o[11:7]  {
            bins reg_val[] = {[0:31]};
        }
              
    endgroup
    covergroup tese_cases_scenarios;
  direct_inst: coverpoint seq_item_ip.instr_rdata_i{
         
            bins Inst_handled_misalignment[] =(
            'h0060006f => 'h00000013 => 'h006f0000 => 'h00000020 => 'h00000013 => 'h01260fb3
        );
            bins Instruction_ignored_misalignment[] = (
            'h0010006f => 'h0030006f => 'h0050006f => 'h0070006f
        );

        bins div_corner_cases[] = (
    'h000FA0B7 => 'hA2808093 =>  'h80000137 => 'h00010113 =>   'h0200C2B3  =>   'h0200E2B3 => 'h0200D2B3   => 'h0200F2B3 =>
     'h023142B3   =>    'h023162B3               
);

        bins mul_corner_cases[] = (
    'h00100093 => 'h80000137 =>  'hFFF10113 => 'h00AF41B7 =>   'hA4C18193  =>   'h020182B3 => 'h021182B3   => 'h022182B3 
                  
);


bins alu_corner_cases[] = (
    'h800000B7 => 'hFFF08093 =>  // li x1, 0x80000000 (max negative)
    'h80000137 => 'h00010113 =>  // li x2, 0x80000000
    'h01900193 =>                // li x3, 25
    'hFCF00213 =>                // li x4, -49
    'h001082B3 =>                // add x5, x1, x1 (max_neg + max_neg)
    'h003082B3 =>                // add x5, x1, x3 (max_neg + pos)
    'h004102B3 =>                // add x5, x2, x4 (max_neg + neg)
    'h002082B3 =>        'h404082B3 =>    'h403102B3 =>    'h000002B3 =>    'h400002B3 =>    'h4001D2B3 =>   'h000192B3 =>  
    'h0001D2B3 =>        'h41F1D293 =>    'h01F19293 =>    'h01F1D293 =>    'h00000263 =>     'h00001063           
);



        }




    endgroup  
//-------------------------------------------------------------------------------


  //-----------------------------------------------------------------------------
  function new(string name = "fetch_coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    op_instruction_cg = new();
    tese_cases_scenarios = new();
  endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    cov_export_ip = new("cov_export_ip", this);
    cov_fifo_ip   = new("cov_fifo_ip", this);
    cov_export_op = new("cov_export_op", this);
    cov_fifo_op   = new("cov_fifo_op", this);

  endfunction

  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);
       cov_export_ip.connect(cov_fifo_ip.analysis_export);
       cov_export_op.connect(cov_fifo_op.analysis_export);


  endfunction



  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
  cov_fifo_op.get(seq_item_op);
  cov_fifo_ip.get(seq_item_ip);
        op_instruction_cg.sample();
        tese_cases_scenarios.sample();
        ///direct sequences cover groups.
    end
  endtask

endclass
