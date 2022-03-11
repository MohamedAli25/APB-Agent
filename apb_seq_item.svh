class apb_seq_item #(
  byte unsigned ADDR_WIDTH,
  data_width_t  DATA_WIDTH,
  longint unsigned NUM_OF_SLAVES
) extends uvm_sequence_item;
  
  // UVM Factory Registration Macro
  `uvm_object_param_utils(apb_seq_item #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_OF_SLAVES(NUM_OF_SLAVES)
  ))
    
  //------------------------------------------
  // Data Members
  //------------------------------------------
  rand apb_operation_t  apb_operation;
  rand bit [ADDR_WIDTH-1:0] address;
  rand bit [DATA_WIDTH-1:0] write_data;
  rand bit write_data_valid [DATA_WIDTH/8];
  rand longint unsigned delay_num_of_clock_cycles;
  rand pprot_normal_privileged_t  pprot_normal_privileged;
  rand pprot_secure_non_secure_t  pprot_secure_non_secure;
  rand pprot_data_instruction_t  pprot_data_instruction;
  rand wakeup_assertion_timing_t  wakeup_assertion_timing;
  rand longint unsigned difference_between_pwakeup_assertion_and_pselx_assertion;
  rand longint unsigned clock_cycles_until_pwakeup_deassertion;
  rand longint unsigned slave_num;

  bit [DATA_WIDTH-1:0] read_data;
  pslverr_t error;


  //------------------------------------------
  // Constraints
  //------------------------------------------
  constraint write_data_valid_default_value {
    foreach(write_data_valid[i]) {
      soft write_data_valid[i] == 1'b1;
    }
  }

  constraint delay_num_of_clock_cycles_default_value {
    soft delay_num_of_clock_cycles inside {1, 2};
  }

  constraint difference_between_pwakeup_assertion_and_pselx_assertion_default_value {
    soft difference_between_pwakeup_assertion_and_pselx_assertion inside {1, 2};
  }

  constraint clock_cycles_until_pwakeup_deassertion_default_value {
    soft clock_cycles_until_pwakeup_deassertion dist {0:/75, [1:3]:/25};
  }

  constraint slave_num_is_valid {
    slave_num < NUM_OF_SLAVES;
  }
  
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_seq_item");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();
  extern function void do_print(uvm_printer printer);
  
endclass: apb_seq_item

function apb_seq_item::new(string name = "apb_seq_item");
  super.new(name);
endfunction: new

function void apb_seq_item::do_copy(uvm_object rhs);
  apb_seq_item #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_OF_SLAVES(NUM_OF_SLAVES)
  ) rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_name(), "The apb_seq_item couldn't be cast during do_copy")
  end
  super.do_copy(rhs);
  this.apb_operation = rhs_.apb_operation;
  this.address = rhs_.address;
  this.write_data = rhs_.write_data;
  this.write_data_valid = rhs_.write_data_valid;
  this.delay_num_of_clock_cycles = rhs_.delay_num_of_clock_cycles;
  this.pprot_normal_privileged = rhs_.pprot_normal_privileged;
  this.pprot_secure_non_secure = rhs_.pprot_secure_non_secure;
  this.pprot_data_instruction = rhs_.pprot_data_instruction;
  this.wakeup_assertion_timing = rhs_.wakeup_assertion_timing;
  this.difference_between_pwakeup_assertion_and_pselx_assertion = rhs_.difference_between_pwakeup_assertion_and_pselx_assertion;
  this.read_data = rhs_.read_data;
  this.error = rhs_.error;
endfunction: do_copy

function bit apb_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  apb_seq_item #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_OF_SLAVES(NUM_OF_SLAVES)
  ) rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_name(), "The apb_seq_item couldn't be cast during do_copy")
  end
  return super.do_compare(rhs, comparer) &&
        this.apb_operation == rhs_.apb_operation &&
        this.address == rhs_.address &&
        this.write_data == rhs_.write_data &&
        this.write_data_valid == rhs_.write_data_valid &&
        this.delay_num_of_clock_cycles == rhs_.delay_num_of_clock_cycles &&
        this.pprot_normal_privileged == rhs_.pprot_normal_privileged &&
        this.pprot_secure_non_secure == rhs_.pprot_secure_non_secure &&
        this.pprot_data_instruction == rhs_.pprot_data_instruction &&
        this.wakeup_assertion_timing == rhs_.wakeup_assertion_timing &&
        this.difference_between_pwakeup_assertion_and_pselx_assertion == rhs_.difference_between_pwakeup_assertion_and_pselx_assertion &&
        this.read_data == rhs_.read_data &&
        this.error == rhs_.error;
endfunction: do_compare

function string apb_seq_item::convert2string();
  return $sformatf("APB Seq Item: %p", this);
endfunction: convert2string

function void apb_seq_item::do_print(uvm_printer printer);
  `uvm_info(get_name(), this.convert2string(), UVM_NONE)
endfunction: do_print
