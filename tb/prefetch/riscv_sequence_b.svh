
class riscv_sequenceb extends uvm_sequence #(riscv_seq_item) ; 

`uvm_object_utils(riscv_sequenceb);
 
	riscv_seq_item instr;
    int num_instr = 1024;

                      

function new (string name = "riscv_sequenceb");

   super.new(name) ;
    
endfunction

 protected task send_instruction(input bit [31:0] instr_data
                                  );
        instr = riscv_seq_item::type_id::create("instr");
        start_item(instr);
        instr.instruction = instr_data;
     
        finish_item(instr);

    endtask

    // Main sequence body
    task body();
 /********************direct sequence for the mem ***************/
        send_instruction(32'h00B00093);  // 1
        send_instruction(32'h01600113);  // 2
        send_instruction(32'h02100193);  // 3
        send_instruction(32'h02C00213);  // 4
        send_instruction(32'h03700293);  // 5
        send_instruction(32'h04200313);  // 6
        send_instruction(32'h04D00393);  // 7
        send_instruction(32'h05800413);  // 8
        send_instruction(32'h06300493);  // 9
        send_instruction(32'h06E00513);  // 10
    /************ randomize the mem *************/
        repeat(1000)begin
            // Randomize instruction
            instr = riscv_seq_item::type_id::create("instr") ; 
            start_item(instr);  // Start the sequence item
            
            if (!instr.randomize()) begin
                `uvm_error("RAND", "Randomization failed")
            end
     
            finish_item(instr);  // Finish the sequence item	

        end
  
	 	endtask

endclass

