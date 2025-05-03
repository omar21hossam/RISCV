package riscv_sequencer_pkg  ; 

import riscv_seq_item_pkg::*  ;
import uvm_pkg ::* ; 
`include "uvm_macros.svh"

class riscv_sequencer extends uvm_sequencer #(riscv_seq_item) ; 

`uvm_component_utils(riscv_sequencer)

function new (string name = "riscv_sequencer" , uvm_component parent = null );
    super.new(name , parent); 
endfunction


endclass

endpackage