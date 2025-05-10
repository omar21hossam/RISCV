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


class riscv_arith_sequence extends riscv_init_sequence;

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_arith_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_arith_sequence");
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
    super.body();
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");
    repeat (riscv_pkg::SEQUENCES) begin
      // Start the arithmetic sequence
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type inside {riscv_pkg::I_TYPE};
            m_seq_item.opcode inside {riscv_pkg::OP_LOAD};
            m_seq_item.funct3 inside {riscv_pkg::LB, riscv_pkg::LH, riscv_pkg::LW, riscv_pkg::LBU, riscv_pkg::LHU};
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize sequence item");
      end
      // Finish the sequence
      finish_item(m_seq_item);

      // Start the arithmetic sequence
      start_item(m_seq_item);
      if (!m_seq_item.randomize() with {
            m_seq_item.instr_type inside {riscv_pkg::S_TYPE};
            m_seq_item.opcode inside {riscv_pkg::OP_STORE};
            m_seq_item.funct3 inside {riscv_pkg::SB, riscv_pkg::SH, riscv_pkg::SW};
          }) begin
        `uvm_fatal(get_name(), "Failed to randomize sequence item");
      end
      // Finish the sequence
      finish_item(m_seq_item);
    end
  endtask

endclass

