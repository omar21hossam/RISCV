//////////////////////////////////////////////////////////////
//                                                          //
//      ____                      _____           _         //
//     | __ )   __ _  ___   ___  |_   _|___  ___ | |_       //
//     |  _ \  / _` |/ __| / _ \   | | / _ \/ __|| __|      //
//     | |_) || (_| |\__ \|  __/   | ||  __/\__ \| |_       //
//     |____/  \__,_||___/ \___|   |_| \___||___/ \__|      //
//                                                          //
//////////////////////////////////////////////////////////////
class riscv_base_test extends uvm_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_base_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  riscv_env                   m_env;
  riscv_virtual_base_sequence m_vsequence_base;
  riscv_config_obj            m_riscv_config;
  alu_config                  m_alu_config;
  mul_config                  m_mul_config;

  //==================================================================================
  // Interfaces
  //==================================================================================
  virtual riscv_if            riscv_vif;
  virtual lsu_if              lsu_vif;
  virtual mul_if              mul_vif;
  virtual alu_if              alu_vif;
  virtual fetch_if            fetch_vif;
  virtual reg_if              reg_vif;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ---------------------------------------------------------------------
    m_env = riscv_env::type_id::create("m_env", this);
    m_riscv_config = riscv_config_obj::type_id::create("m_riscv_config", this);
    m_vsequence_base = riscv_virtual_base_sequence::type_id::create("m_vsequence_base", this);

    // Configs
    //------------------------------------------
    m_alu_config = alu_config::type_id::create("m_alu_config", this);
    m_alu_config.is_active = UVM_PASSIVE;
    m_mul_config = mul_config::type_id::create("m_mul_config", this);
    m_mul_config.is_active = UVM_PASSIVE;

    // Configuration
    // ---------------------------------------------------------------------
    // RISCV Config Class
    //------------------------------------------
    uvm_config_db#(riscv_config_obj)::set(this, "m_env", "riscv_config_obj", m_riscv_config);

    // ALU Config Class
    //------------------------------------------
    uvm_config_db#(alu_config)::set(this, "m_env", "alu_config", m_alu_config);

    // MUL Config Class
    //------------------------------------------
    uvm_config_db#(mul_config)::set(this, "m_env", "mul_config", m_mul_config);

    // RISCV Top Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual riscv_if)::get(this, "", "riscv_intf", riscv_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get interface in test");
    end else begin
      uvm_config_db#(virtual riscv_if)::set(this, "m_env", "riscv_intf", riscv_vif);
    end

    // Fetch Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual fetch_if)::get(this, "", "fetch_intf", fetch_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual fetch_if)::set(this, "m_env", "fetch_intf", fetch_vif);
    end

    // ALU Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_intf", alu_vif)) begin
      `uvm_fatal(get_full_name(), "Error in get alu interface in test");
    end else begin
      uvm_config_db#(virtual alu_if)::set(this, "m_env", "alu_intf", alu_vif);
    end

    // MUL Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual mul_if)::get(this, "", "mul_intf", mul_vif)) begin
      `uvm_fatal("NO_INTF", {"Config not found for ", get_full_name(), ".mul_vif"});
    end else begin
      uvm_config_db#(virtual mul_if)::set(this, "m_env", "mul_intf", mul_vif);
    end

    // LSU Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual lsu_if)::get(this, "", "lsu_intf", lsu_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for lsu_if");
    end else begin
      uvm_config_db#(virtual lsu_if)::set(this, "m_env", "lsu_intf", lsu_vif);
    end

    // REGFILE Interface
    //------------------------------------------
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "reg_intf", reg_vif)) begin
      `uvm_fatal(get_name(), "Failed to get configuration for reg_if");
    end else begin
      uvm_config_db#(virtual reg_if)::set(this, "m_env", "reg_intf", reg_vif);
    end

  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST", $sformatf("\n\n%s %s %s\n\n", `SHORT_EQ_LINE, get_type_name(), `SHORT_EQ_LINE), UVM_LOW);
    phase.raise_objection(this);
    m_vsequence_base.start(m_env.m_vseqr);
    phase.phase_done.set_drain_time(this, 1us);
    phase.drop_objection(this);
  endtask
endclass

////////////////////////////////////////////////////////////////
//                                                            //
//      ____                    _   _____           _         //
//     |  _ \  __ _  _ __    __| | |_   _|___  ___ | |_       //
//     | |_) |/ _` || '_ \  / _` |   | | / _ \/ __|| __|      //
//     |  _ <| (_| || | | || (_| |   | ||  __/\__ \| |_       //
//     |_| \_\\__,_||_| |_| \__,_|   |_| \___||___/ \__|      //
//                                                            //
////////////////////////////////////////////////////////////////
class riscv_rand_test extends riscv_base_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_rand_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  riscv_virtual_rand_sequence m_vsequence_rand;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_rand_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ---------------------------------------------------------------------
    m_vsequence_rand = riscv_virtual_rand_sequence::type_id::create("m_vsequence_rand", this);
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    m_vsequence_rand.start(m_env.m_vseqr);
    phase.phase_done.set_drain_time(this, 1us);
    phase.drop_objection(this);
  endtask
endclass

////////////////////////////////////////////////////////////////////
//                                                                //
//      ____   _                   _     _____           _        //
//     |  _ \ (_) _ __  ___   ___ | |_  |_   _|___  ___ | |_      //
//     | | | || || '__|/ _ \ / __|| __|   | | / _ \/ __|| __|     //
//     | |_| || || |  |  __/| (__ | |_    | ||  __/\__ \| |_      //
//     |____/ |_||_|   \___| \___| \__|   |_| \___||___/ \__|     //
//                                                                //
////////////////////////////////////////////////////////////////////
class riscv_direct_test extends riscv_base_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_direct_test)

  //==================================================================================
  // Class Handle
  //==================================================================================
  riscv_virtual_direct_sequence m_vsequence_direct;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_direct_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Creation
    // ---------------------------------------------------------------------
    m_vsequence_direct = riscv_virtual_direct_sequence::type_id::create("m_vsequence_direct", this);
  endfunction

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    m_vsequence_direct.start(m_env.m_vseqr);
    phase.phase_done.set_drain_time(this, 1us);
    phase.drop_objection(this);
  endtask
endclass
