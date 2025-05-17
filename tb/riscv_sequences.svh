////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//      ___         _  _    _         _  _             _    _                     //
//     |_ _| _ __  (_)| |_ (_)  __ _ | |(_) ____ __ _ | |_ (_)  ___   _ __        //
//      | | | '_ \ | || __|| | / _` || || ||_  // _` || __|| | / _ \ | '_ \       //
//      | | | | | || || |_ | || (_| || || | / /| (_| || |_ | || (_) || | | |      //
//     |___||_| |_||_| \__||_| \__,_||_||_|/___|\__,_| \__||_| \___/ |_| |_|      //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////
class riscv_init_sequence extends uvm_sequence #(riscv_sequence_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_init_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;


  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_init_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    for (int i = 1; i < 32; i++) begin

      // Start initialize the register file
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type == riscv_pkg::U_TYPE;
            m_seq_item.opcode == riscv_pkg::OP_LUI;
            m_seq_item.rd == i;
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize sequence item");
      end

      // Finish the first item
      finish_item(m_seq_item);

      // Start the second item
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type == riscv_pkg::I_TYPE;
            m_seq_item.opcode == riscv_pkg::OP_ITYPE;
            m_seq_item.funct3 == riscv_pkg::ADDI_JALR;
            m_seq_item.rs1 == i;
            m_seq_item.rd == i;
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize sequence item");
      end

      // Finish the second item
      finish_item(m_seq_item);
    end
  endtask

  //==================================================================================
  // Task: direct_send
  //==================================================================================
  protected task direct_send(input bit [31:0] instr_data);
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");
    start_item(m_seq_item);
    m_seq_item.instruction = instr_data;
    finish_item(m_seq_item);
  endtask

endclass

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//      ____                 _                 _          _   _                   //
//     |  _ \ __ _ _ __   __| | ___  _ __ ___ (_)______ _| |_(_) ___  _ __        //
//     | |_) / _` | '_ \ / _` |/ _ \| '_ ` _ \| |_  / _` | __| |/ _ \| '_ \       //
//     |  _ < (_| | | | | (_| | (_) | | | | | | |/ / (_| | |_| | (_) | | | |      //
//     |_| \_\__,_|_| |_|\__,_|\___/|_| |_| |_|_/___\__,_|\__|_|\___/|_| |_|      //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////
class riscv_rand_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_rand_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_rand_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    super.pre_body();
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");


    repeat (riscv_pkg::SEQUENCES) begin

      // Randomize All RV32IM Instructions Sequence
      // ---------------------------------------------------------------------
      start_item(m_seq_item);
      if (!m_seq_item.randomize()) begin
        `uvm_fatal(get_name(), "Failed to randomize alu sequence item");
      end
      // Finish the sequence
      finish_item(m_seq_item);

      // MUL Sequence
      // -------------------------------------------------
      // Start the arithmetic sequence
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type == riscv_pkg::R_TYPE;
            m_seq_item.opcode == riscv_pkg::OP_RTYPE;
            m_seq_item.funct3 inside {riscv_pkg::MUL, riscv_pkg::MULH, riscv_pkg::MULHSU, riscv_pkg::MULHU};
            m_seq_item.funct7 == riscv_pkg::M_FUNCT7;
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize mul sequence item");
      end
      // Finish the sequence
      finish_item(m_seq_item);

      // DIV Sequence
      // -------------------------------------------------
      // Start the arithmetic sequence
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type == riscv_pkg::R_TYPE;
            m_seq_item.opcode == riscv_pkg::OP_RTYPE;
            m_seq_item.funct3 inside {riscv_pkg::DIV,
            riscv_pkg::DIVU,
            riscv_pkg::REM,
            riscv_pkg::REMU};
            m_seq_item.funct7 == riscv_pkg::M_FUNCT7;
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize div sequence item");
      end
      // Finish the sequence
      finish_item(m_seq_item);

      // Load Sequence
      // -------------------------------------------------
      // Start the arithmetic sequence
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type inside {riscv_pkg::I_TYPE};
            m_seq_item.opcode inside {riscv_pkg::OP_LOAD};
            m_seq_item.funct3 inside {riscv_pkg::LB, riscv_pkg::LH, riscv_pkg::LW, riscv_pkg::LBU, riscv_pkg::LHU};
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize load sequence item");
      end
      // Finish the sequence
      finish_item(m_seq_item);

      // Store Sequence
      // -------------------------------------------------
      // Start the arithmetic sequence
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type inside {riscv_pkg::S_TYPE};
            m_seq_item.opcode inside {riscv_pkg::OP_STORE};
            m_seq_item.funct3 inside {riscv_pkg::SB, riscv_pkg::SH, riscv_pkg::SW};
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize store sequence item");
      end
       // Finish the sequence
       finish_item(m_seq_item);


      // // Jump Sequence
      // // -------------------------------------------------
      // // Start the arithmetic sequence
      // start_item(m_seq_item);
      // if (!m_seq_item.randomize() with {
      //       m_seq_item.instr_type inside {riscv_pkg::J_TYPE};
      //     }) begin
      //   `uvm_fatal(get_name(), "Failed to randomize jump sequence item");
      // end
      // // Finish the sequence
      // finish_item(m_seq_item);
    end
  endtask

endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//         _     _     _   _    ____                                   ____                             //
//        / \   | |   | | | |  / ___| ___   _ __  _ __    ___  _ __   / ___| __ _  ___   ___  ___       //
//       / _ \  | |   | | | | | |    / _ \ | '__|| '_ \  / _ \| '__| | |    / _` |/ __| / _ \/ __|      //
//      / ___ \ | |___| |_| | | |___| (_) || |   | | | ||  __/| |    | |___| (_| |\__ \|  __/\__ \      //
//     /_/   \_\|_____|\___/   \____|\___/ |_|   |_| |_| \___||_|     \____|\__,_||___/ \___||___/      //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_corner_alu_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_corner_alu_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_corner_alu_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    super.pre_body();
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");

    // ALU Corner Cases
    // ---------------------------------------------------
    // li x1, 0x7fffffff (maximum positive number)
    direct_send('h800000B7);
    direct_send('hFFF08093);

    // li x2, 0x80000000 (maximum negative number)
    direct_send('h80000137);
    direct_send('h00010113);

    direct_send('h01900193);  // li x3, 25 (some positive number)
    direct_send('hFCF00213);  // li x4, -49 (some negative number)
    direct_send('h01f00313);  // li x6, 31 (maximum shift amount)
    direct_send('h001082B3);  // add x5, x1, x1
    direct_send('h002102b3);  // add x5, x2, x2
    direct_send('h003082B3);  // add x5, x1, x3
    direct_send('h004102B3);  // add x5, x2, x4
    direct_send('h002082B3);  // add x5, x1, x2
    direct_send('h404082B3);  // sub x5, x1, x4
    direct_send('h403102B3);  // sub x5, x2, x3
    direct_send('h000002B3);  // add x5, x0, x0
    direct_send('h400002B3);  // sub x5, x0, x0
    direct_send('h401102b3);  // sub x5, x0, x0
    direct_send('h4001D2B3);  // sra x5, x3, x0
    direct_send('h000192B3);  // sll x5, x3, x0
    direct_send('h0001D2B3);  // srl x5, x3, x0
    direct_send('h4061d2b3);  // sra x5, x3, x6
    direct_send('h006192b3);  // sll x5, x3, x6
    direct_send('h0061d2b3);  // srl x5, x3, x6
    direct_send('h41F1D293);  // srai x5, x3, 31
    direct_send('h01F19293);  // slli x5, x3, 31
    direct_send('h01F1D293);  // srli x5, x3, 31
    direct_send('h00000263);  // beq x0, x0, 4
    direct_send('h00001063);  // bne x0, x0, 0
  endtask

endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//      __  __  _   _  _        ____                                   ____                             //
//     |  \/  || | | || |      / ___| ___   _ __  _ __    ___  _ __   / ___| __ _  ___   ___  ___       //
//     | |\/| || | | || |     | |    / _ \ | '__|| '_ \  / _ \| '__| | |    / _` |/ __| / _ \/ __|      //
//     | |  | || |_| || |___  | |___| (_) || |   | | | ||  __/| |    | |___| (_| |\__ \|  __/\__ \      //
//     |_|  |_| \___/ |_____|  \____|\___/ |_|   |_| |_| \___||_|     \____|\__,_||___/ \___||___/      //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_corner_mul_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_corner_mul_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_corner_mul_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    super.pre_body();
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");

    // MUL Corner Cases
    // ---------------------------------------------------
    direct_send('h00100093);  //  li x1, 1

    // li x2, 0x7fffffff (maximum positive number)
    direct_send('h80000137);
    direct_send('hFFF10113);

    // li x3, 0xaf3a4c (random positive number)
    direct_send('h00AF41B7);
    direct_send('hA4C18193);

    direct_send('h020182B3);  //  mul x5, x3, x0
    direct_send('h021182B3);  //  mul x5, x3, x1
    direct_send('h022182B3);  //  mul x5, x3, x2
  endtask

endclass

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//      ____  ___ __     __   ____                                   ____                             //
//     |  _ \|_ _|\ \   / /  / ___| ___   _ __  _ __    ___  _ __   / ___| __ _  ___   ___  ___       //
//     | | | || |  \ \ / /  | |    / _ \ | '__|| '_ \  / _ \| '__| | |    / _` |/ __| / _ \/ __|      //
//     | |_| || |   \ V /   | |___| (_) || |   | | | ||  __/| |    | |___| (_| |\__ \|  __/\__ \      //
//     |____/|___|   \_/     \____|\___/ |_|   |_| |_| \___||_|     \____|\__,_||___/ \___||___/      //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_corner_div_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_corner_div_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_corner_div_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    super.pre_body();
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");

    // DIV Corner Cases
    // ---------------------------------------------------
    // li x1, 0xf9a28 (random positive number)
    direct_send('h000FA0B7);
    direct_send('hA2808093);

    // li x2, 0x80000000 (maximum negative number)
    direct_send('h80000137);
    direct_send('h00010113);

    direct_send('h0200C2B3);  // div x5, x1, x0
    direct_send('h0200E2B3);  // rem x5, x1, x0
    direct_send('h0200D2B3);  // divu x5, x1, x0
    direct_send('h0200F2B3);  // remu, x5, x1, x0
    direct_send('h023142B3);  // div x5, x2, x3
    direct_send('h023162B3);  // rem x5, x2, x3
  endtask

endclass

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//      __  __  _              _  _                          _      _                                   //
//     |  \/  |(_) ___   __ _ | |(_)  __ _  _ __    ___   __| |    / \    ___  ___  ___  ___  ___       //
//     | |\/| || |/ __| / _` || || | / _` || '_ \  / _ \ / _` |   / _ \  / __|/ __|/ _ \/ __|/ __|      //
//     | |  | || |\__ \| (_| || || || (_| || | | ||  __/| (_| |  / ___ \| (__| (__|  __/\__ \\__ \      //
//     |_|  |_||_||___/ \__,_||_||_| \__, ||_| |_| \___| \__,_| /_/   \_\\___|\___|\___||___/|___/      //
//                                   |___/                                                              //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class riscv_misalign_instr_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_misalign_instr_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_misalign_instr_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    super.pre_body();
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");

    // Instruction handled misalignment
    // ---------------------------------------------------
    direct_send('h0060006f);  // jal x0, 6
    direct_send('h00000013);  // nop
    direct_send('h006f0000);  // {jal x0, 2},{0000}
    direct_send('h00000020);  // {0000},{jal x0, 2}
    direct_send('h00000013);  // nop
    direct_send('h01260fb3);  // {add x31, x12, x18}

    // Instruction ignored misalignment
    // ---------------------------------------------------
    direct_send('h0010006f);  // jalr x0, 1
    direct_send('h0030006f);  // jalr x0, 3
    direct_send('h0050006f);  // jalr x0, 5
    direct_send('h0070006f);  // jalr x0, 7

  endtask

endclass

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//      ____          _           _   _                             _           //
//     |  _ \   __ _ | |_  __ _  | | | |  __ _  ____ __ _  _ __  __| | ___      //
//     | | | | / _` || __|/ _` | | |_| | / _` ||_  // _` || '__|/ _` |/ __|     //
//     | |_| || (_| || |_| (_| | |  _  || (_| | / /| (_| || |  | (_| |\__ \     //
//     |____/  \__,_| \__|\__,_| |_| |_| \__,_|/___|\__,_||_|   \__,_||___/     //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
class riscv_data_hazard_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_data_hazard_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_data_hazard_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Pre-Body
  //==================================================================================
  task pre_body();
    super.pre_body();
  endtask

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");

    // Read-After-Write Hazards
    // ---------------------------------------------------
    direct_send('h00002083);  // lw x1, 0(x0)
    direct_send('h00008133);  // add x2, x1, x0
    direct_send('h022101B3);  // mul x3, x2, x2
    direct_send('h00302023);  // sw x3, 0(x0)

  endtask

endclass
