class reg2apb_adapter extends uvm_reg_adapter;

  // UVM Factory Registration Macro
  `uvm_object_utils(reg2apb_adapter)
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "reg2apb_adapter");
  extern virtual function uvm_sequence_item reg2bus(
    const ref uvm_reg_bus_op rw
  );
  extern virtual function void bus2reg(
    uvm_sequence_item bus_item,
    ref uvm_reg_bus_op rw
  );

endclass: reg2apb_adapter

function reg2apb_adapter::new(string name = "reg2apb_adapter");
  super.new(name);
  supports_byte_enable = 0;
  provides_responses = 0;
endfunction

function uvm_sequence_item reg2apb_adapter::reg2bus(
  const ref uvm_reg_bus_op rw
);
  apb_seq_item apb_seq_item_h;

  apb_seq_item_h.apb_operation = rw.kind == UVM_READ ? READ : WRITE;
  apb_seq_item_h.address = rw.addr;
  apb_seq_item_h.write_data = rw.data;

  return apb_seq_item_h;
endfunction

function void reg2apb_adapter::bus2reg(
  uvm_sequence_item bus_item,
  ref uvm_reg_bus_op rw
);
  apb_seq_item apb_seq_item_h;
  if(!$cast(apb_seq_item_h, bus_item)) begin
    `uvm_fatal(get_name(), "Couldn't cast uvm_sequence_item to apb_seq_item")
  end

  rw.kind = apb_seq_item_h.apb_operation == READ ? UVM_READ : UVM_WRITE;
  rw.addr = apb_seq_item_h.address;
  rw.data = apb_seq_item_h.apb_operation == READ ? apb_seq_item_h.read_data : apb_seq_item_h.write_data;
  rw.status = apb_seq_item_h.error == PSLVERR_NO_ERROR ? UVM_IS_OK : UVM_NOT_OK;
endfunction