
class riscv_corner_alu_test extends riscv_base_test;
  //==================================================================================
  // Registeration
  //==================================================================================
  `uvm_component_utils(riscv_corner_alu_test)

  //==================================================================================
  // Task: Run Phase
  //==================================================================================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    m_vsequence.start(m_env.m_vseqr);
    phase.phase_done.set_drain_time(this, 1ms);
    phase.drop_objection(this);
  endtask
endclass

