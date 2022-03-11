class apb_coverage_monitor extends uvm_subscriber #(apb_seq_item);

  // UVM Factory Registration Macro
  `uvm_component_utils(apb_coverage_monitor)

  
  //------------------------------------------
  // Cover Groups
  //------------------------------------------
  covergroup apb_cov;

    OPERATION: coverpoint apb_seq_item_h.apb_operation {
      bins write = {WRITE};
      bins read = {READ};
      bins delay = {DELAY};
      bins wakeup = {WAKEUP};
      bins write_read[] = (WRITE, READ => WRITE, READ);
      bins write_read_delay[] = (WRITE, READ => DELAY => WRITE, READ);
    }

    ERROR: coverpoint apb_seq_item_h.error {
      bins no_error = {PSLVERR_NO_ERROR};
      bins error = {PSLVERR_ERROR};
      bins error_no_error[] = (PSLVERR_NO_ERROR, PSLVERR_ERROR => PSLVERR_NO_ERROR, PSLVERR_ERROR);
    }

    NORMAL_PRIVILEGED: coverpoint apb_seq_item_h.normal_privileged {
      bins normal = {PPROT_NORMAL};
      bins privileged = {PPROT_PRIVILEGED};
      bins normal_privileged[] = (PPROT_NORMAL, PPROT_PRIVILEGED => PPROT_NORMAL, PPROT_PRIVILEGED);
    }

    SECURE_NON_SECURE: coverpoint apb_seq_item_h.secure_non_secure {
      bins secure = {PPROT_SECURE};
      bins non_secure = {PPROT_NON_SECURE};
      bins secure_non_secure[] = (PPROT_SECURE, PPROT_NON_SECURE => PPROT_SECURE, PPROT_NON_SECURE);
    }

    DATA_INSTRUCTION: coverpoint apb_seq_item_h.data_instruction {
      bins data = {PPROT_DATA};
      bins instruction = {PPROT_INSTRUCTION};
      bins data_instruction[] = (PPROT_DATA, PPROT_INSTRUCTION => PPROT_DATA, PPROT_INSTRUCTION);
    }

    WAKEUP_ASSERTION_TIMING: coverpoint apb_seq_item_h.wakeup_assertion_timing {
      bins before_pselx_assertion = {BEFORE_PSELX_ASSERTION};
      bins during_pselx_assertion = {DURING_PSELX_ASSERTION};
      bins after_pselx_assertion  = {AFTER_PSELX_ASSERTION};
      bins before_during_after_pselx_assertion[] = (BEFORE_PSELX_ASSERTION, DURING_PSELX_ASSERTION, AFTER_PSELX_ASSERTION =>
                                                  BEFORE_PSELX_ASSERTION, DURING_PSELX_ASSERTION, AFTER_PSELX_ASSERTION);
    }

    OPERATION_WITH_WAIT: cross apb_seq_item_h.apb_operation, apb_seq_item_h.with_wait;

  endgroup: apb_cov

  //------------------------------------------
  // Component Members
  //------------------------------------------
  apb_seq_item apb_seq_item_h;

  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_coverage_monitor", uvm_component parent = null);
  extern function void report_phase(uvm_phase phase);
  extern function void write(apb_seq_item apb_seq_item_h);
    
endclass: apb_coverage_monitor

function apb_coverage_monitor::new(string name = "apb_coverage_monitor", uvm_component parent = null);
  super.new(name, parent);
  apb_cov = new;
endfunction: new

function void apb_coverage_monitor::report_phase(uvm_phase phase);

endfunction: report_phase

function void apb_coverage_monitor::write(apb_seq_item apb_seq_item_h);
  this.apb_seq_item_h = apb_seq_item_h;
  apb_cov.sample();
endfunction: write