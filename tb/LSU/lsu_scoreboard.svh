class lsu_scoreboard extends uvm_scoreboard;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(lsu_scoreboard)

  //==================================================================================
  // TLM
  //==================================================================================
  uvm_tlm_analysis_fifo #(lsu_sequence_item) analysis_fifo;

  //==================================================================================
  // Classes Handles
  //==================================================================================
  lsu_sequence_item m_seq_item_actual;
  lsu_sequence_item m_seq_item_oneOftwo;
  lsu_sequence_item m_seq_item_reference;

  //==================================================================================
  // Flags
  //==================================================================================
  int success_count = 0;
  int failure_count = 0;

  //==================================================================================
  // Function: Constructor
  //==================================================================================
  function new(string name = "lsu_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //==================================================================================
  // Function: Build Phase
  //==================================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Building LSU Scoreboard", UVM_HIGH);

    // Creation
    // ---------
    m_seq_item_actual = lsu_sequence_item::type_id::create("m_seq_item_actual");
    m_seq_item_reference = lsu_sequence_item::type_id::create("m_seq_item_reference");
    m_seq_item_oneOftwo = lsu_sequence_item::type_id::create("m_seq_item_oneOftwo");

    // TLM
    // -------
    analysis_fifo = new("analysis_fifo", this);
  endfunction

  // ==================================================================================
  // Task: Run Phase
  // ==================================================================================
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_name(), "Running LSU Scoreboard", UVM_HIGH);

    // Sampling Inputs from EX Stage
    // ------------------------------
    forever begin
      analysis_fifo.get(m_seq_item_actual);

      // Copy the content of first aligned transaction before misalignment
      m_seq_item_oneOftwo.copy(m_seq_item_actual);

      // Misaligned Case
      // ------------------------------
      if (m_seq_item_actual.data_misaligned_o) begin
        // Retrieve the second transaction caused by misalignment
        analysis_fifo.get(m_seq_item_actual);

        // Get Reference Transaction
        m_seq_item_reference = get_reference(m_seq_item_actual, m_seq_item_oneOftwo);

        if (m_seq_item_actual.data_we_ex_i == riscv_pkg::LOAD) begin
          assert (m_seq_item_actual.data_rdata_ex_o == m_seq_item_reference.data_rdata_ex_o) begin
            success_count++;
            `uvm_info(get_name(), $sformatf(
                      "Data match for LOAD operation: Expected[%8h] - Actual[%8h]",
                      m_seq_item_reference.data_rdata_ex_o,
                      m_seq_item_actual.data_rdata_ex_o
                      ), UVM_HIGH);
          end else begin
            failure_count++;
            `uvm_fatal(get_name(), $sformatf(
                       "Data mismatch for LOAD operation: Expected[%8h] - Actual[%8h]",
                       m_seq_item_reference.data_rdata_ex_o,
                       m_seq_item_actual.data_rdata_ex_o
                       ));
          end
        end else if (m_seq_item_actual.data_we_ex_i == riscv_pkg::STORE) begin
          assert (m_seq_item_actual.data_wdata_o == m_seq_item_reference.data_wdata_o) begin
            success_count++;
            `uvm_info(get_name(), $sformatf(
                      "Data match for STORE operation: Expected[%8h] - Actual[%8h]",
                      m_seq_item_reference.data_wdata_o,
                      m_seq_item_actual.data_wdata_o
                      ), UVM_HIGH);
          end else begin
            failure_count++;
            `uvm_fatal(get_name(), $sformatf(
                       "Data mismatch for STORE operation: Expected[%8h] - Actual[%8h]",
                       m_seq_item_reference.data_wdata_o,
                       m_seq_item_actual.data_wdata_o
                       ));
          end
        end


      end  // Aligned Case
           // ------------------------------
      else begin
        // Get Reference Transaction
        m_seq_item_reference = get_reference(m_seq_item_actual, m_seq_item_oneOftwo);

        if (m_seq_item_actual.data_we_ex_i == riscv_pkg::LOAD) begin
          assert (m_seq_item_actual.data_rdata_ex_o == m_seq_item_reference.data_rdata_ex_o) begin
            success_count++;
            `uvm_info(get_name(), $sformatf(
                      "Data match for LOAD operation: Expected[%8h] - Actual[%8h]",
                      m_seq_item_reference.data_rdata_ex_o,
                      m_seq_item_actual.data_rdata_ex_o
                      ), UVM_HIGH);
          end else begin
            failure_count++;
            `uvm_fatal(get_name(), $sformatf(
                       "Data mismatch for LOAD operation: Expected[%8h] - Actual[%8h]",
                       m_seq_item_reference.data_rdata_ex_o,
                       m_seq_item_actual.data_rdata_ex_o
                       ));
          end
        end else if (m_seq_item_actual.data_we_ex_i == riscv_pkg::STORE) begin
          assert (m_seq_item_actual.data_wdata_o == m_seq_item_reference.data_wdata_o) begin
            success_count++;
            `uvm_info(get_name(), $sformatf(
                      "Data match for STORE operation: Expected[%8h] - Actual[%8h]",
                      m_seq_item_reference.data_wdata_o,
                      m_seq_item_actual.data_wdata_o
                      ), UVM_HIGH);
          end else begin
            failure_count++;
            `uvm_fatal(get_name(), $sformatf(
                       "Data mismatch for STORE operation: Expected[%8h] - Actual[%8h]",
                       m_seq_item_reference.data_wdata_o,
                       m_seq_item_actual.data_wdata_o
                       ));
          end
        end
      end
    end
  endtask

  //==================================================================================
  // Function: Report Phase
  //==================================================================================
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name(), $sformatf("Success Count: %0d", success_count), UVM_NONE);
    `uvm_info(get_name(), $sformatf("Failure Count: %0d", failure_count), UVM_NONE);
  endfunction

  //==================================================================================
  // Function: get_reference
  //==================================================================================
  function lsu_sequence_item get_reference(input lsu_sequence_item latest_t,
                                           input lsu_sequence_item earliest_t);
    // Create a new instance of the expected transaction
    lsu_sequence_item expected_t;
    expected_t = lsu_sequence_item::type_id::create("expected_t");

    // Load Case
    // ------------------------------------------------
    if (earliest_t.data_we_ex_i == riscv_pkg::LOAD) begin

      case (earliest_t.data_type_ex_i)

        // Load Byte
        // --------------------------------------
        riscv_pkg::BYTE1, riscv_pkg::BYTE2: begin

          // Byte-Mask
          case (earliest_t.data_be_o)
            // Byte 0
            4'b0001: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {24'b0, latest_t.data_rdata_i[7:0]};
              end  // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {24{latest_t.data_rdata_i[7]}}, latest_t.data_rdata_i[7:0]
                };
              end
            end

            // Byte 1
            4'b0010: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {24'b0, latest_t.data_rdata_i[15:8]};
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {24{latest_t.data_rdata_i[15]}}, latest_t.data_rdata_i[15:8]
                };
              end
            end

            // Byte 2
            4'b0100: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {24'b0, latest_t.data_rdata_i[23:16]};
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {24{latest_t.data_rdata_i[23]}}, latest_t.data_rdata_i[23:16]
                };
              end
            end

            // Byte 3
            4'b1000: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {24'b0, latest_t.data_rdata_i[31:24]};
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {24{latest_t.data_rdata_i[31]}}, latest_t.data_rdata_i[31:24]
                };
              end
            end

            default: begin
              `uvm_fatal(
                  get_name(), $sformatf(
                  "Unsupported byte enable for LB operation: Byte Enable[%4b]", latest_t.data_be_o))
            end
          endcase
        end

        // Load Halfword
        // --------------------------------------
        riscv_pkg::HALF: begin

          // Byte-Mask
          case (earliest_t.data_be_o)

            // EA[1:0] = 2'b00
            4'b0011: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {16'b0, latest_t.data_rdata_i[15:0]};
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {16{latest_t.data_rdata_i[15]}}, latest_t.data_rdata_i[15:0]
                };
              end
            end

            // EA[1:0] = 2'b01
            4'b0110: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {16'b0, latest_t.data_rdata_i[23:8]};
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {24{latest_t.data_rdata_i[23]}}, latest_t.data_rdata_i[23:8]
                };
              end
            end

            // EA[1:0] = 2'b10
            4'b1100: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {16'b0, latest_t.data_rdata_i[31:16]};
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {16{latest_t.data_rdata_i[31]}}, latest_t.data_rdata_i[31:16]
                };
              end
            end

            // EA[1:0] = 2'b11
            4'b1000: begin
              // Zero-Extend
              if (latest_t.data_sign_ext_ex_i == riscv_pkg::ZERO_EXT) begin
                expected_t.data_rdata_ex_o = {
                  16'b0, latest_t.data_rdata_i[7:0], earliest_t.data_rdata_i[31:24]
                };
              end // Sign-Extend
              else if (latest_t.data_sign_ext_ex_i == riscv_pkg::SIGN_EXT) begin
                expected_t.data_rdata_ex_o = {
                  {16{latest_t.data_rdata_i[7]}},
                  latest_t.data_rdata_i[7:0],
                  earliest_t.data_rdata_i[31:24]
                };
              end
            end


            default: begin
              `uvm_fatal(get_name(), $sformatf(
                         "Unsupported byte enable for misaligned LH operation: Byte Enable[%4b]",
                         latest_t.data_be_o
                         ));
            end
          endcase
        end

        // Load Word
        // --------------------------------------
        riscv_pkg::WORD: begin
          // Byte-Mask
          case (earliest_t.data_be_o)
            // EA[1:0] = 2'b00
            4'b1111: begin
              expected_t.data_rdata_ex_o = latest_t.data_rdata_i;
            end

            // EA[1:0] = 2'b01
            4'b1110: begin
              expected_t.data_rdata_ex_o = {
                latest_t.data_rdata_i[7:0], earliest_t.data_rdata_i[31:8]
              };
            end

            // EA[1:0] = 2'b10
            4'b1100: begin
              expected_t.data_rdata_ex_o = {
                latest_t.data_rdata_i[15:0], earliest_t.data_rdata_i[31:16]
              };
            end

            // EA[1:0] = 2'b11
            4'b1000: begin
              expected_t.data_rdata_ex_o = {
                latest_t.data_rdata_i[23:0], earliest_t.data_rdata_i[31:24]
              };
            end

            default: begin
              `uvm_fatal(
                  get_name(), $sformatf(
                  "Unsupported byte enable for LW operation: Byte Enable[%4b]", latest_t.data_be_o
                  ));
            end
          endcase
        end

        // Unsupported Load Type
        // --------------------------------------
        default: begin
          `uvm_fatal(get_name(), "Unsupported data type for LOAD operation")
        end
      endcase
    end  // Store Case
         // -----------------------------------------------------
    else if (earliest_t.data_we_ex_i == riscv_pkg::STORE) begin

      case (earliest_t.data_type_ex_i)

        // Store Byte
        // --------------------------------------
        riscv_pkg::BYTE1, riscv_pkg::BYTE2: begin

          // Byte-Mask
          case (latest_t.data_be_o)
            // Byte 0
            4'b0001: begin
              expected_t.data_wdata_o = latest_t.data_wdata_ex_i;
            end

            // Byte 1
            4'b0010: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 8);
            end

            // Byte 2
            4'b0100: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 16);
            end

            // Byte 3
            4'b1000: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 24);
            end

            default: begin
              `uvm_fatal(
                  get_name(), $sformatf(
                  "Unsupported byte enable for SB operation: Byte Enable[%4b]", latest_t.data_be_o))
            end
          endcase
        end

        // Store Halfword
        // --------------------------------------
        riscv_pkg::HALF: begin

          // Byte-Mask
          case (earliest_t.data_be_o)
            // EA[1:0] = 2'b00
            4'b0011: begin
              expected_t.data_wdata_o = latest_t.data_wdata_ex_i;
            end

            // EA[1:0] = 2'b01
            4'b0110: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 8);
            end

            // EA[1:0] = 2'b10
            4'b1100: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 16);
            end

            //  EA[1:0] = 2'b11
            4'b1000: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 24);
            end

            default: begin
              `uvm_fatal(
                  get_name(), $sformatf(
                  "Unsupported byte enable for SH operation: Byte Enable[%4b]", latest_t.data_be_o))
            end
          endcase
        end

        // Store Word
        // --------------------------------------
        riscv_pkg::WORD: begin
          // Byte-Mask
          case (earliest_t.data_be_o)

            // EA[1:0] = 2'b00
            4'b1111: begin
              expected_t.data_wdata_o = latest_t.data_wdata_ex_i;
            end

            // EA[1:0] = 2'b01
            4'b1110: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 8);
            end

            // EA[1:0] = 2'b10
            4'b1100: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 16);
            end

            // EA[1:0] = 2'b11
            4'b1000: begin
              expected_t.data_wdata_o = rotate_left(latest_t.data_wdata_ex_i, 24);
            end

            default: begin
              `uvm_fatal(
                  get_name(), $sformatf(
                  "Unsupported byte enable for SW operation: Byte Enable[%4b]", latest_t.data_be_o))
            end
          endcase
        end

        // Unsupported Store Type
        // --------------------------------------
        default: begin
          `uvm_fatal(get_name(), "Unsupported data type for STORE operation")
        end
      endcase
    end
    return expected_t;
  endfunction


  //==================================================================================
  // Function: rotate_right
  //==================================================================================
  function logic [31:0] rotate_right(input logic [31:0] data, input int unsigned shamt);
    return (data >> shamt) | (data << (32 - shamt));
  endfunction

  //==================================================================================
  // Function: rotate_left
  //==================================================================================
  function logic [31:0] rotate_left(input logic [31:0] data, input int unsigned shamt);
    return (data << shamt) | (data >> (32 - shamt));
  endfunction

endclass
