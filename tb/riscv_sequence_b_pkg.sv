
package riscv_sequenceb_pkg;
import riscv_seq_item_pkg::*;
import uvm_pkg::* ; 
`include "uvm_macros.svh"
 	 
class riscv_sequenceb extends uvm_sequence #(riscv_seq_item) ; 

`uvm_object_utils(riscv_sequenceb);
 
	riscv_seq_item instr;
    int num_instr = 256;

                      

function new (string name = "riscv_sequenceb");

   super.new(name) ;
    
endfunction

    // Main sequence body
    task body();
        for (int i = 0; i <= num_instr; i++) begin
            // Randomize instruction
            instr = riscv_seq_item::type_id::create("instr") ; 
            start_item(instr);  // Start the sequence item
            if (!instr.randomize()) begin
                `uvm_error("RAND", "Randomization failed")
            end
  
            finish_item(instr);  // Finish the sequence item	

        end
        instr = riscv_seq_item::type_id::create("instr") ; 
            start_item(instr);  // Start the sequence item
            instr.rst_ni = 'b0;
            finish_item(instr);  // Finish the sequence item	
            #10
            instr = riscv_seq_item::type_id::create("instr") ; 
            start_item(instr);  // Start the sequence item
            instr.rst_ni = 'b1;
            finish_item(instr);  // Finish the sequence item	


/*  if u wanna use direct sequence or direct instruction , just extend this class
and use         instr.op= ....  addr= ....   then fill all fields with what u wanna

    */

	 
	endtask

endclass

endpackage