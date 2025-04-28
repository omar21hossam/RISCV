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
if (!uvm_config_db #(virtual ALU_interface)::get(this, "", "vif_m",vif)) begin
  `uvm_fatal(get_full_name(),"Error on interface connectivity");
end
endfunction:new
//==============================================================================
//Description:run_phase
//==============================================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // forever begin
    //seq_item = alu_seq_item::type_id::create("seq_item", this);
    //  // @(posedge vif.clk);
    //   // if (vif.rst == 1) begin 
    //   //   seq_item.rst = 1;
    //   //   analysis_port.write(seq_item);
    //   // end
    //   // else begin
        
    //   //   #1step;
    //   //   analysis_port.write(seq_item); 
    //   // end
    // end
  endtask
endclass : alu_monitor