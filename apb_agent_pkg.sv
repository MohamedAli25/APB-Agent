package apb_agent_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "apb_types.svh"
  `include "apb_seq_item.svh"
  `include "apb_agent_config.svh"
  `include "reg2apb_adapter.svh"
  `include "apb_predictor.svh"
  `include "apb_driver.svh"
  `include "apb_coverage_monitor.svh"
  `include "apb_monitor.svh"
  typedef uvm_sequencer#(apb_seq_item) apb_sequencer;
  `include "apb_agent.svh"
  `include "apb_checker.svh"
  
endpackage: apb_agent_pkg
  