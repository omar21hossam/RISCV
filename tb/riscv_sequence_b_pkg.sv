
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

 protected task send_instruction(input bit [31:0] instr_data, 
                                   input bit [31:0] instr_addr);
     //   riscv_seq_item item;
        instr = riscv_seq_item::type_id::create("instr");
        start_item(instr);
        instr.instruction = instr_data;
        instr.addr = instr_addr;
        finish_item(instr);
    endtask

    // Main sequence body
    task body();
    /************ randomize the mem *************/
        for (int i = 0; i <= num_instr; i++) begin
            // Randomize instruction
            instr = riscv_seq_item::type_id::create("instr") ; 
            start_item(instr);  // Start the sequence item
            if (!instr.randomize()) begin
                `uvm_error("RAND", "Randomization failed")
            end

            finish_item(instr);  // Finish the sequence item	

        end
  /********************direct sequence for the mem ***************/
        send_instruction(32'h00B00093, 32'h00000000);  // 1
        send_instruction(32'h01600113, 32'h00000004);  // 2
        send_instruction(32'h02100193, 32'h00000008);  // 3
        send_instruction(32'h02C00213, 32'h0000000c);  // 4
        send_instruction(32'h03700293, 32'h00000010);  // 5
        send_instruction(32'h04200313, 32'h00000014);  // 6
        send_instruction(32'h04D00393, 32'h00000018);  // 7
        send_instruction(32'h05800413, 32'h0000001c);  // 8
        send_instruction(32'h06300493, 32'h00000020);  // 9
        send_instruction(32'h06E00513, 32'h00000024);  // 10
  /**********************_RST_**********************************/     
        instr = riscv_seq_item::type_id::create("instr") ; 
            start_item(instr);  // Start the sequence item
            instr.rst_ni = 'b0;
            instr.boot_addr_i='b0;
            finish_item(instr);  // Finish the sequence item	
	
            #100
repeat(1000)begin
instr = riscv_seq_item::type_id::create("instr") ; 
 start_item(instr);  // Start the sequence item
            instr.rst_ni = 'b1;
             instr.boot_addr_i='b0;
            finish_item(instr);  // Finish the sequence item	
end


	 
	endtask

endclass

endpackage