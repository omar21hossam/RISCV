class alu_monitor extends uvm_monitor;
`uvm_component_utils(alu_monitor)
//==============================================================================
//Description: declarations
//============================================================================== 
alu_seq_item seq_item,
            seq_item_prev;
virtual alu_if vif;
uvm_analysis_port #(alu_seq_item) analysis_port;
//==============================================================================
//Description: function new
//==============================================================================
function new(string name = "alu_monitor", uvm_component parent = null);
super.new(name, parent);
analysis_port = new("analysis_port", this);
seq_item_prev = alu_seq_item::type_id::create("seq_item_prev",this);
endfunction:new
//==============================================================================
//Description: build_phase
//==============================================================================
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db #(virtual alu_if)::get(this,"", "vif_m",vif)) begin
  `uvm_fatal(get_type_name(),"Error on interface connectivity");
end
endfunction:build_phase
//==============================================================================
//Description:run_phase
//==============================================================================
// a signal to detect if the ALU operation or operand is changed
  bit detect_change;
task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
  seq_item = alu_seq_item::type_id::create("seq_item",this);
  @(posedge vif.core_clk iff vif.enable_i && vif.rst_n);  
  fork
    begin:inp_sampling
    if($isunknown(vif.operator_i ||vif.operand_b_i || vif.operand_a_i)) begin
    end
    else begin
      //for both cases, input and output, we need to sample the inputs at the posedge of the clock
      seq_item.in_out      = 1'b0; // input to ALU
      seq_item.rst_n       = vif.rst_n;
      seq_item.enable_i    = vif.enable_i;
      seq_item.operator_i  = vif.operator_i;
      seq_item.operand_a_i = vif.operand_a_i;
      seq_item.operand_b_i = vif.operand_b_i;
      seq_item.ex_ready_i  = vif.ex_ready_i;
      seq_item.testing_time = $realtime;
      if (compare_inputs(seq_item, seq_item_prev)) begin
       // `uvm_warning(get_type_name(),"ALU inputs are  the same");
       detect_change = 0;
      end
      else begin
        detect_change = 1;
         analysis_port.write(seq_item);
      end
      seq_item_prev = alu_seq_item::type_id::create("seq_item_prev",this);
      seq_item_prev = new seq_item;
    end
    end
//===============================================================================
    begin:out_sampling
      if($isunknown(vif.result_o ||vif.comparison_result_o || vif.ready_o))begin
      end 
      else begin
       seq_item.in_out = 1'b1; // output from ALU
     // if(vif.enable_i) begin 
	   if (!vif.ready_o) begin // division operation 
	    wait(vif.ready_o && vif.ex_ready_i); // wait for the output to be ready for division
         @(posedge vif.core_clk);
       end 
       seq_item.result_o = vif.result_o;
       seq_item.ready_o = vif.ready_o;
       seq_item.comparison_result_o = vif.comparison_result_o;
       seq_item.testing_time = $realtime;
	 // end
      if (detect_change) begin
        analysis_port.write(seq_item);
      end 
      end
    end
  join
  end
endtask:run_phase

//===============================================================================
//Description:compare_inputs
//=============================================================================== 
function bit compare_inputs(alu_seq_item seq_item, alu_seq_item seq_item_prev);
  if (seq_item.operator_i == seq_item_prev.operator_i && 
      seq_item.operand_a_i == seq_item_prev.operand_a_i && 
      seq_item.operand_b_i == seq_item_prev.operand_b_i) begin
    return 1;
  end
  return 0;
endfunction:compare_inputs
endclass : alu_monitor
