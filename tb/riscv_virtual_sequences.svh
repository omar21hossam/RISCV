//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//     __     __  ____                      ____                                                    //
//     \ \   / / | __ )   __ _  ___   ___  / ___|   ___   __ _  _   _   ___  _ __    ___  ___       //
//      \ \ / /  |  _ \  / _` |/ __| / _ \ \___ \  / _ \ / _` || | | | / _ \| '_ \  / __|/ _ \      //
//       \ V /   | |_) || (_| |\__ \|  __/  ___) ||  __/| (_| || |_| ||  __/| | | || (__|  __/      //
//        \_/    |____/  \__,_||___/ \___| |____/  \___| \__, | \__,_| \___||_| |_| \___|\___|      //
//                                                          |_|                                     //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_virtual_base_sequence extends uvm_sequence #(riscv_sequence_item);

  //==================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_virtual_base_sequence)
  `uvm_declare_p_sequencer(riscv_virtual_sequencer)

  //==================================================================================
  // Class Handles
  //==================================================================================
  riscv_main_sequencer m_instr_seqr;
  lsu_sequencer m_data_seqr;
  lsu_sequence m_lsu_sequence;
  riscv_init_sequence m_init_sequence;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_virtual_base_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // task: Pre-body
  //==================================================================================
  virtual task pre_body();
    m_instr_seqr = p_sequencer.m_instr_seqr;
    m_data_seqr = p_sequencer.m_data_seqr;
    m_lsu_sequence = lsu_sequence::type_id::create("m_lsu_sequence");
    m_init_sequence = riscv_init_sequence::type_id::create("m_init_sequence");
  endtask

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    
    fork
      //start the sequences
      begin
        m_init_sequence.start(m_instr_seqr);
      end
      m_lsu_sequence.start(m_data_seqr);
    join_any
  endtask
endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//     __     __  ____                    _   ____                                                    //
//     \ \   / / |  _ \  __ _  _ __    __| | / ___|   ___   __ _  _   _   ___  _ __    ___  ___       //
//      \ \ / /  | |_) |/ _` || '_ \  / _` | \___ \  / _ \ / _` || | | | / _ \| '_ \  / __|/ _ \      //
//       \ V /   |  _ <| (_| || | | || (_| |  ___) ||  __/| (_| || |_| ||  __/| | | || (__|  __/      //
//        \_/    |_| \_\\__,_||_| |_| \__,_| |____/  \___| \__, | \__,_| \___||_| |_| \___|\___|      //
//                                                            |_|                                     //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_virtual_rand_sequence extends uvm_sequence #(riscv_sequence_item);

  //==================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_virtual_rand_sequence)
  `uvm_declare_p_sequencer(riscv_virtual_sequencer)

  //==================================================================================
  // Class Handles
  //==================================================================================
  riscv_main_sequencer m_instr_seqr;
  lsu_sequencer m_data_seqr;
  lsu_sequence m_lsu_sequence;
  riscv_rand_sequence m_rand_sequence;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_virtual_rand_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // task: Pre-body
  //==================================================================================
  virtual task pre_body();
    m_instr_seqr = p_sequencer.m_instr_seqr;
    m_data_seqr = p_sequencer.m_data_seqr;
    m_lsu_sequence = lsu_sequence::type_id::create("m_lsu_sequence");
    m_rand_sequence = riscv_rand_sequence::type_id::create("m_rand_sequence");
  endtask

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    
    fork
      //start the sequences
      begin
        m_rand_sequence.start(m_instr_seqr);
      end
      m_lsu_sequence.start(m_data_seqr);
    join_any
  endtask
endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
//     __     __  ____   _                   _     ____                                                   //
//     \ \   / / |  _ \ (_) _ __  ___   ___ | |_  / ___|   ___   __ _  _   _   ___  _ __    ___  ___      //
//      \ \ / /  | | | || || '__|/ _ \ / __|| __| \___ \  / _ \ / _` || | | | / _ \| '_ \  / __|/ _ \     //
//       \ V /   | |_| || || |  |  __/| (__ | |_   ___) ||  __/| (_| || |_| ||  __/| | | || (__|  __/     //
//        \_/    |____/ |_||_|   \___| \___| \__| |____/  \___| \__, | \__,_| \___||_| |_| \___|\___|     //
//                                                                 |_|                                    //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_virtual_direct_sequence extends uvm_sequence #(riscv_sequence_item);

  //==================================================================================
  // Factory Registration
  //==================================================================================
  `uvm_object_utils(riscv_virtual_direct_sequence)
  `uvm_declare_p_sequencer(riscv_virtual_sequencer)

  //==================================================================================
  // Class Handles
  //==================================================================================
  riscv_main_sequencer m_instr_seqr;
  lsu_sequencer m_data_seqr;
  lsu_sequence m_lsu_sequence;
  riscv_corner_alu_sequence m_alu_sequence;
  riscv_corner_mul_sequence m_mul_sequence;
  riscv_corner_div_sequence m_div_sequence;
  riscv_data_hazard_sequence m_data_hazard_sequence;
  riscv_misalign_instr_sequence m_misalign_instr_sequence;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_virtual_direct_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // task: Pre-body
  //==================================================================================
  virtual task pre_body();
    m_instr_seqr = p_sequencer.m_instr_seqr;
    m_data_seqr = p_sequencer.m_data_seqr;
    m_lsu_sequence = lsu_sequence::type_id::create("m_lsu_sequence");
    m_alu_sequence = riscv_corner_alu_sequence::type_id::create("m_alu_sequence");
    m_mul_sequence = riscv_corner_mul_sequence::type_id::create("m_mul_sequence");
    m_div_sequence = riscv_corner_div_sequence::type_id::create("m_div_sequence");
    m_data_hazard_sequence = riscv_data_hazard_sequence::type_id::create("m_data_hazard_sequence");
    m_misalign_instr_sequence =
        riscv_misalign_instr_sequence::type_id::create("m_misalign_instr_sequence");
  endtask

  //==================================================================================
  // task: body
  //==================================================================================
  virtual task body();
    fork
      //start the sequences
      begin
        m_alu_sequence.start(m_instr_seqr);
        m_mul_sequence.start(m_instr_seqr);
        m_div_sequence.start(m_instr_seqr);
         m_data_hazard_sequence.start(m_instr_seqr);
         m_misalign_instr_sequence.start(m_instr_seqr);
      end
      m_lsu_sequence.start(m_data_seqr);
    join_any
  endtask
endclass
