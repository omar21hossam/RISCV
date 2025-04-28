class mul_seq extends uvm_sequence #(mul_seq_item);
  `uvm_object_utils(mul_seq)

  // Declare the data members
    mul_seq_item seq_item;

  // Constructor
  function new(string name = "mul_seq");
    super.new(name);
  endfunction

  // Build phase
  task pre_body();
    // Create the sequence item
    seq_item = mul_seq_item::type_id::create("seq_item");
  endtask

  task body();
    // Loop to generate sequence items
    for (int i = 0; i < 128; i++) begin
      start_item(seq_item);
      seq_item.randomize() with {
        // Add randomization constraints here if needed
      };
      finish_item(seq_item);
    end
    endtask

  endclass : mul_seq