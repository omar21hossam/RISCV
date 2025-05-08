interface riscv_intf(input logic clk);

     logic rst_ni;

     logic pulp_clock_en_i; // input PULP clock enable (only used if COREV_CLUSTER = 1)
     logic scan_cg_en_i;  // input Enable all clock gates for testing

    // Core ID, Cluster ID, debug mode halt address and boot address are considered more or less static
   //all are inputs
     logic [31:0] boot_addr_i;
     logic [31:0] mtvec_addr_i;
     logic [31:0] dm_halt_addr_i;
     logic [31:0] hart_id_i;
     logic [31:0] dm_exception_addr_i;

    // Instruction memory interface 
    //ip
      logic        instr_gnt_i;
      logic        instr_rvalid_i;
      logic [31:0] instr_rdata_i;
    //op
      logic [31:0] instr_addr_o;
      logic        instr_req_o;

    // Data memory interface
    //ip
    
      logic        data_gnt_i;
      logic        data_rvalid_i;
      logic [31:0] data_rdata_i;
    
    //op
     logic [ 3:0] data_be_o;
     logic [31:0] data_addr_o;
     logic [31:0] data_wdata_o;
     logic        data_we_o;
     logic        data_req_o;

    // Interrupt inputs
    //ip
     logic [31:0] irq_i;  // CLINT interrupts + CLINT extension interrupts
    //op
     logic        irq_ack_o;
     logic [ 4:0] irq_id_o;

    // Debug Interface
    //ip
      logic debug_req_i;
    //op  
     logic debug_havereset_o;
     logic debug_running_o;
     logic debug_halted_o;

    // CPU Control Signals
    //ip
     logic fetch_enable_i;
    //op
     logic core_sleep_o;



	clocking ckb_p @(negedge clk);
		default input #1 output #1;

		endclocking
endinterface