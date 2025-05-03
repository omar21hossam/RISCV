class alu_monitor extends uvm_monitor;
`uvm_component_utils(alu_monitor)
//==============================================================================
//Description: declarations
//============================================================================== 
alu_seq_item seq_item;
virtual ALU_interface vif;
uvm_analysis_port #(alu_seq_item) analysis_port;
//==============================================================================
//Description: function new
//==============================================================================
function new(string name = "alu_monitor", uvm_component parent = null);
super.new(name, parent);
analysis_port = new("analysis_port", this);
endfunction:new
//==============================================================================
//Description: build_phase
//==============================================================================
function void build_phase(uvm_phase phase);
super.build_phase(phase);
if (!uvm_config_db #(virtual ALU_interface)::get(this,"", "vif_m",vif)) begin
  `uvm_fatal(get_type_name(),"Error on interface connectivity");
end
endfunction:build_phase
//==============================================================================
//Description:run_phase
//==============================================================================
task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
  seq_item = alu_seq_item::type_id::create("seq_item",this);
  @(posedge vif.core_clk);
  fork
    begin:inp_sampling
    if($isunknown(vif.cb.operator_i ||vif.cb.operand_b_i || vif.cb.operand_a_i)) begin
    end
    else begin
      //for both cases, input and output, we need to sample the inputs at the posedge of the clock
      seq_item.in_out      = 1'b0; // input to ALU
      seq_item.rst_n       = vif.cb.rst_n;
      seq_item.enable_i    = vif.cb.enable_i;
      seq_item.operator_i  = vif.cb.operator_i;
      seq_item.operand_a_i = vif.cb.operand_a_i;
      seq_item.operand_b_i = vif.cb.operand_b_i;
      seq_item.ex_ready_i  = vif.cb.ex_ready_i;
      `uvm_info(get_type_name(), $sformatf("ALU Monitor: Sampling inputs: %s", seq_item.convert2string()), UVM_MEDIUM);
      analysis_port.write(seq_item);
      `uvm_info(get_type_name(), $sformatf("send input transaction to scoreboard"), UVM_NONE);
    end
    end
//===============================================================================
    begin:out_sampling
      if($isunknown(vif.cb.result_o ||vif.cb.comparison_result_o || vif.cb.ready_o))begin
      end 
      else begin
      seq_item.in_out = 1'b1; // output from ALU
      if(vif.cb.enable_i) wait(vif.ready_o); // wait for the output to be ready
      if (vif.ready_o) begin 
        //***osama Alzero code***//
      end
      else begin
        seq_item.result_o = vif.cb.result_o;
        seq_item.comparison_result_o = vif.cb.comparison_result_o;
        seq_item.ready_o = vif.cb.ready_o;
      end
      `uvm_info(get_type_name(), $sformatf("ALU Monitor: Sampling outputs: %s", seq_item.convert2string()), UVM_MEDIUM);
       analysis_port.write(seq_item);
      `uvm_info(get_type_name(), $sformatf("send output transaction to scoreboard"), UVM_NONE);
      end
    end
  join
  end
endtask:run_phase
endclass : alu_monitor