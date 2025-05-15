class fetch_monitor extends uvm_monitor;

  `uvm_component_utils(fetch_monitor)


  virtual fetch_if                    fetch_intf;
  fetch_seq_item                      seq_item_ip,seq_item_op;

  uvm_analysis_port #(fetch_seq_item) mon_ap_ip;
  uvm_analysis_port #(fetch_seq_item) mon_ap_op;

  logic [31:0] inst_op = 'b0;
  ////////////////////////////////////////////////////////////////////////////////////

  function new(string name = "fetch_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  //////////////////////////////////////////////////////////////////////
  ////////////////////////////--build phase--////////////////////////////
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    mon_ap_ip = new("mon_ap_ip", this);

    mon_ap_op = new("mon_ap_op", this);


    if (!uvm_config_db#(virtual fetch_if)::get(this, "", "fetch_intf", fetch_intf)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for fetch intf in mon");
    end


  endfunction

  ////////////////////////////--run phase--////////////////////////////
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      seq_item_ip = fetch_seq_item::type_id::create("seq_item_ip");
      seq_item_op = fetch_seq_item::type_id::create("seq_item_op");
      

      @(posedge fetch_intf.clk) begin


        if (fetch_intf.instr_rvalid_i) begin

          seq_item_ip.instr_rdata_i = fetch_intf.instr_rdata_i;
          seq_item_ip.pc_id_o = fetch_intf.pc_id_o;
          seq_item_ip.pc_if_o = fetch_intf.pc_if_o;
          seq_item_ip.instr_addr_o = fetch_intf.instr_addr_o;
          mon_ap_ip.write(seq_item_ip);


   /*        $display("time %0t:   instr_addr_o %0d ,  pc_id_o %0d ,  pc_if_o %0d ,  instr_rdata_i %0h",  $time,
            seq_item_ip.instr_addr_o,seq_item_ip.pc_id_o ,seq_item_ip.pc_if_o ,seq_item_ip.instr_rdata_i  
);  */      
       
        end
          if ( !(fetch_intf.instr_rdata_id_o == inst_op )) begin


            seq_item_op.instr_rdata_id_o = fetch_intf.instr_rdata_id_o;
            seq_item_op.instr_valid_id_o = fetch_intf.instr_valid_id_o;
inst_op= fetch_intf.instr_rdata_id_o;
             mon_ap_op.write(seq_item_op);


/*        $display("time %0t: data_id_o %0h , valid_id_o %0d ",  $time,seq_item_op.instr_rdata_id_o,seq_item_op.instr_valid_id_o,
); */
          end
          end
        end
      
 
  endtask

endclass
