class apb_driver extends uvm_driver #(apb_seq_item);

  // UVM Factory Registration Macro
  `uvm_component_utils(apb_driver)

  // Virtual Interface
  virtual apb_driver_bfm apb_driver_bfm_h;

  //------------------------------------------
  // Data Members
  //------------------------------------------
  apb_agent_config      apb_agent_config_h;
  //------------------------------------------
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_driver", uvm_component parent = null);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  //------------------------------------------

endclass: apb_driver

function apb_driver::new(string name = "apb_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void apb_driver::connect_phase(uvm_phase phase);
  apb_driver_bfm_h = apb_agent_config_h.apb_driver_bfm_h;
endfunction: connect_phase

task apb_driver::run_phase(uvm_phase phase);
  apb_seq_item apb_seq_item_h;
  forever begin
    seq_item_port.get_next_item(apb_seq_item_h);
    case (apb_seq_item_h.apb_operation)
      WRITE: apb_driver_bfm_h.write(apb_seq_item_h);
      READ: apb_driver_bfm_h.read(apb_seq_item_h);
      WAKEUP: apb_driver_bfm_h.wakeup(apb_seq_item_h);
      DELAY: apb_driver_bfm_h.delay(apb_seq_item_h);
    endcase
    seq_item_port.item_done();
  end
endtask: run_phase

