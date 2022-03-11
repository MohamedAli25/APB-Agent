class apb_agent extends uvm_agent;

  // UVM Factory Registration Macro
  `uvm_component_utils(apb_agent)

  //------------------------------------------
  // Data Members
  //------------------------------------------
  apb_agent_config apb_agent_config_h;
    
  //------------------------------------------
  // Component Members
  //------------------------------------------
  uvm_analysis_port #(apb_seq_item) ap;
  apb_monitor apb_monitor_h;
  apb_sequencer apb_sequencer_h;
  apb_driver apb_driver_h;
  apb_coverage_monitor apb_coverage_monitor_h;
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: apb_agent
  
  
function apb_agent::new(string name = "apb_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_agent::build_phase(uvm_phase phase);
  if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config_h", apb_agent_config_h)) begin
    `uvm_fatal(this.get_name(), "Cannot get apb agent configuration from uvm_config_db");
  end
  ap = new("ap", this);

  apb_monitor_h = apb_monitor::type_id::create("apb_monitor_h", this);
  apb_monitor_h.apb_agent_config_h = apb_agent_config_h;

  if(apb_agent_config_h.is_active == UVM_ACTIVE) begin
    apb_sequencer_h = apb_sequencer::type_id::create("apb_sequencer_h", this);

    apb_driver_h = apb_driver::type_id::create("apb_driver_h", this);
    apb_driver_h.apb_agent_config_h = apb_agent_config_h;
  end

  if(apb_agent_config_h.has_coverage_monitor) begin
    apb_coverage_monitor_h = apb_coverage_monitor::type_id::create("apb_coverage_monitor_h", this);
  end
endfunction: build_phase

function void apb_agent::connect_phase(uvm_phase phase);
  apb_monitor_h.ap.connect(ap);
  
  if(apb_agent_config_h.is_active == UVM_ACTIVE) begin
    apb_driver_h.seq_item_port.connect(apb_sequencer_h.seq_item_export);
  end

  if(apb_agent_config_h.has_coverage_monitor) begin 
    apb_monitor_h.ap.connect(apb_coverage_monitor_h.analysis_export);
  end
endfunction: connect_phase
  