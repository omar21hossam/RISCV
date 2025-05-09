class riscv_driver extends uvm_driver #(riscv_seq_item) ; 

`uvm_component_utils(riscv_driver)

  virtual  riscv_intf    riscv_vintf_ ;
 riscv_seq_item      seq_item_rsp  ; //driver will respond 
function new (string name = "riscv_driver" ,uvm_component parent= null ) ; 
    super.new(name , parent) ;
endfunction


  function void reset();
          riscv_vintf_.rst_ni              <=0 ; 
          riscv_vintf_.boot_addr_i         <=0 ;
          riscv_vintf_.mtvec_addr_i        <=0 ;
          riscv_vintf_.dm_halt_addr_i      <=0 ;
          riscv_vintf_.hart_id_i           <=0 ;
          riscv_vintf_.dm_exception_addr_i <=0 ;
          riscv_vintf_.irq_i               <=0 ;
          riscv_vintf_.debug_req_i         <=0 ;
          riscv_vintf_.fetch_enable_i      <=0 ;
          riscv_vintf_.pulp_clock_en_i     <=0 ;
          riscv_vintf_.scan_cg_en_i        <=0 ;
          riscv_vintf_.instr_gnt_i         <=0 ;
          riscv_vintf_.instr_rvalid_i      <=0 ; 
          riscv_vintf_.instr_rdata_i       <=0 ;

  endfunction


task run_phase (uvm_phase phase);
    
    super.run_phase(phase) ;
   
         reset();
         #50;
      forever begin




        seq_item_rsp = riscv_seq_item::type_id::create("seq_item_rsp")  ; 
        seq_item_port.get_next_item(seq_item_rsp) ; 
          riscv_vintf_.rst_ni              <= seq_item_rsp.rst_ni; 
   fork      
/************************** memory obi ************************/

  begin
 @( posedge riscv_vintf_.clk)
  begin
   riscv_vintf_.instr_rvalid_i      <=0 ; 
  wait ( riscv_vintf_.instr_req_o =='b1) begin
riscv_vintf_.instr_gnt_i    <=1;
#10;
riscv_vintf_.instr_gnt_i    <=0;  
riscv_vintf_.instr_rvalid_i <=1 ;    
if (!(seq_item_rsp.instr_mem.exists(riscv_vintf_.instr_addr_o))) begin
riscv_vintf_.instr_rdata_i  <=seq_item_rsp.instruction ;
  seq_item_rsp.instr_mem[riscv_vintf_.instr_addr_o]  =seq_item_rsp.instruction    ;
                                                                 end
else    riscv_vintf_.instr_rdata_i  <=seq_item_rsp.instr_mem[riscv_vintf_.instr_addr_o];                                                              
                                  end
       
                        end 

  end

/********************************************************************/
     begin
@( posedge riscv_vintf_.clk)
        begin
          riscv_vintf_.boot_addr_i         <= seq_item_rsp.boot_addr_i;
          riscv_vintf_.mtvec_addr_i        <= seq_item_rsp.mtvec_addr_i;
          riscv_vintf_.dm_halt_addr_i      <= seq_item_rsp.dm_halt_addr_i;
          riscv_vintf_.hart_id_i           <= seq_item_rsp.hart_id_i;
          riscv_vintf_.dm_exception_addr_i <= seq_item_rsp.dm_exception_addr_i;
          riscv_vintf_.irq_i               <= seq_item_rsp.irq_i;
          riscv_vintf_.debug_req_i         <= seq_item_rsp.debug_req_i;
          riscv_vintf_.fetch_enable_i      <= seq_item_rsp.fetch_enable_i;
          riscv_vintf_.pulp_clock_en_i     <= seq_item_rsp.pulp_clock_en_i;
          riscv_vintf_.scan_cg_en_i        <= seq_item_rsp.scan_cg_en_i;
 end
 end
  join 
           seq_item_port.item_done() ; 
            

end

      
    endtask


endclass
