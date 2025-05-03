
package riscv_driver_pkg ;
import uvm_pkg::* ; 
`include "uvm_macros.svh"
 import riscv_seq_item_pkg::*;

class riscv_driver extends uvm_driver #(riscv_seq_item) ; 

`uvm_component_utils(riscv_driver)

  virtual  riscv_intf    riscv_vintf_ ;
 riscv_seq_item      seq_item ;
function new (string name = "riscv_driver" ,uvm_component parent= null ) ; 
    super.new(name , parent) ;
endfunction

task run_phase (uvm_phase phase);
    
    super.run_phase(phase) ;
 for (int i = 0; i <= 256; i++) begin
  seq_item = riscv_seq_item::type_id::create("seq_item")  ; 
        seq_item_port.get_next_item(seq_item) ; 
         riscv_vintf_.addr         <= seq_item.addr;
          riscv_vintf_.inst        <= seq_item.instruction;
        seq_item_port.item_done() ; 
 end
      forever begin
        seq_item = riscv_seq_item::type_id::create("seq_item")  ; 
        seq_item_port.get_next_item(seq_item) ; 
        //  riscv_vintf_.addr         <= seq_item.addr;
        //   riscv_vintf_.inst        <= seq_item.instruction;
        @(posedge riscv_vintf_.ckb_p)
        begin
          riscv_vintf_.rst_ni               <= seq_item.rst_ni;
          riscv_vintf_.boot_addr_i         <= seq_item.boot_addr_i;
          riscv_vintf_.mtvec_addr_i        <= seq_item.mtvec_addr_i;
          riscv_vintf_.dm_halt_addr_i      <= seq_item.dm_halt_addr_i;
          riscv_vintf_.hart_id_i           <= seq_item.hart_id_i;
          riscv_vintf_.dm_exception_addr_i <= seq_item.dm_exception_addr_i;
          riscv_vintf_.irq_i               <= seq_item.irq_i;
          riscv_vintf_.debug_req_i         <= seq_item.debug_req_i;
          riscv_vintf_.fetch_enable_i      <= seq_item.fetch_enable_i;


            seq_item_port.item_done() ; 
//$display("driver class ,time:%0t  : rst %0b ,alu_en %0b , a_en %0b , b_en %0b , a %0b ,b %0b ,a_op %0b ,b_op %0b" ,$time ,trans.rst_n,trans.ALU_en,trans.A_en,trans.B_en,trans.A,trans.B,trans.a_op,trans.b_op);
end
      end
    endtask


endclass

endpackage