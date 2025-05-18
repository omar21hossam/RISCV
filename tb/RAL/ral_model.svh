class ral_model extends uvm_reg_block;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(ral_model)

  //==================================================================================
  // Data Members
  //==================================================================================
  register_file_model gpr [32];
  pc_model            pc;
  uvm_reg_map         map;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "ral_model");
    super.new(name, UVM_NO_COVERAGE);
  endfunction

  //==================================================================================
  // Function: Build
  //==================================================================================
  function void build();
    // HDL path for reg block
    add_hdl_path("riscv_top_tb.DUT.core_i.id_stage_i.register_file_i");

    // Create the register map
    //(map_name, address, endianness, offset)
    map = create_map("map", 'h0, 4, UVM_LITTLE_ENDIAN, 0);

    // Create registers and add them to the map

    // 32 general-purpose registers (x0 to x31)
    // ----------------------------------------
    foreach (gpr[i]) begin
      gpr[i] = register_file_model::type_id::create($sformatf("x%0d", i));
      gpr[i].configure(this, null, $sformatf("mem[%0d]", i));
      gpr[i].build();
      if (i == 0) begin
        // Read-only access for x0
        map.add_reg(gpr[i], i, "RO");
      end else begin
        // Read-write access for other registers
        map.add_reg(gpr[i], i, "RW");
      end
    end

    // Program Counter (PC)
    // ----------------------------------------
    pc = pc_model::type_id::create("pc");
    pc.configure(this, null, "riscv_top_tb.DUT.core_i.if_stage_i.aligner_i.pc_q");
    pc.build();
    map.add_reg(pc, 'h100, "RW");  // Add pc register to the map
  endfunction

endclass
