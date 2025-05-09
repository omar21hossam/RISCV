class ral_model extends uvm_reg_block;
  `uvm_object_utils(ral_model)

  register_RAL       regs[32];
  PC_reg             PC;
  uvm_reg_map        map;

  string blk_hdl_path;
  string reg_hdl_path;
  string PC_hdl_path;

  function new(string name = "ral_model");
    super.new(name, UVM_NO_COVERAGE);
  endfunction


  function void build();
    super.build();
   
    add_hdl_path("riscv_top_tb.DUT.core_i.id_stage_i.register_file_i"); // HDL path for reg block

    // Create the register map
    map = create_map("map", 'h0, 4, UVM_BIG_ENDIAN, 0);
    

    // Create registers and add them to the map
    foreach (regs[i]) begin
      regs[i] = register_RAL::type_id::create($sformatf("x%0d", i));
      regs[i].configure(this, null, $sformatf("mem[%0d]", i));
      regs[i].build();
      if (i == 0) begin
        // Read-only access for x0
        map.add_reg(regs[i], i , "RO");
      end else begin
        // Read-write access for other registers
        map.add_reg(regs[i], i , "RW");
      end
    end

    // Create PC register and add it to the map
    PC = PC_reg::type_id::create("PC", this);
    PC.configure(this, null, "riscv_top_tb.DUT.core_i.if_stage_i.aligner_i.pc_q");
    PC.build();
    map.add_reg(PC, 'h100, "RW"); // Add PC register to the map
  endfunction

endclass