
class riscv_base_sequence extends uvm_sequence #(riscv_sequence_item);

  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_object_utils(riscv_base_sequence);

  //==================================================================================
  // Classes Handles
  //==================================================================================
  riscv_sequence_item m_seq_item;


  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "riscv_base_sequence");
    super.new(name);
  endfunction

  //==================================================================================
  // Task: Body
  //==================================================================================
  task body();
    repeat (1000) begin
      m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");

      // Start the sequence item
      start_item(m_seq_item);
      if (!m_seq_item.randomize()) begin
        `uvm_fatal(get_name(), "Failed to randomize sequence item");
      end
      // Finish the sequence item
      finish_item(m_seq_item);
    end
  endtask

  //==================================================================================
  // Task: send_instruction
  //==================================================================================
  protected task send_instruction(input bit [31:0] instr_data);
    m_seq_item = riscv_sequence_item::type_id::create("m_seq_item");
    start_item(m_seq_item);
    m_seq_item.instruction = instr_data;
    finish_item(m_seq_item);
  endtask

endclass

