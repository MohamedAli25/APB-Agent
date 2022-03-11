class apb_agent_config extends uvm_object;
  
  // UVM Factory Registration Macro
  `uvm_object_utils(apb_agent_config)
  
  // BFM Virtual Interfaces
  virtual apb_driver_bfm apb_driver_bfm_h;
  virtual apb_monitor_bfm apb_monitor_bfm_h;
    
  //------------------------------------------
  // Data Members
  //------------------------------------------
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  bit has_coverage_monitor = 1;

  byte unsigned address_width;
  data_width_t data_width;
  longint unsigned num_of_slaves;
    
  //------------------------------------------
  // Events
  //------------------------------------------
  event reset_detected_e;
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_agent_config");
  
endclass: apb_agent_config

function apb_agent_config::new(string name = "apb_agent_config");
  super.new(name);
endfunction: new
