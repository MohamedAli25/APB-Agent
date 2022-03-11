class apb_monitor extends uvm_monitor;

  // UVM Factory Registration Macro
  `uvm_component_utils(apb_monitor)

  // Virtual Interface
  virtual apb_monitor_bfm apb_monitor_bfm_h;

  //------------------------------------------
  // Data Members
  //------------------------------------------
  apb_agent_config apb_agent_config_h;
  //------------------------------------------
    
  //------------------------------------------
  // Component Members
  //------------------------------------------
  uvm_analysis_port #(apb_seq_item) ap;

  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_monitor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
    
endclass: apb_monitor

function apb_monitor::new(string name = "apb_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction: build_phase

function void apb_monitor::connect_phase(uvm_phase phase);
  apb_monitor_bfm_h = apb_agent_config_h.apb_monitor_bfm_h;
endfunction: connect_phase
