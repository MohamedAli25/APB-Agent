class apb_predictor extends uvm_reg_predictor #(apb_seq_item);

  // UVM Factory Registration Macro
  `uvm_component_utils(apb_predictor)
  
  //------------------------------------------
  // Methods
  //------------------------------------------
  extern function new(string name = "apb_predictor", uvm_component parent = null);
  extern function void write(apb_seq_item tr);

endclass: apb_predictor
  
  
function apb_predictor::new(string name = "apb_predictor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void apb_predictor::write(apb_seq_item tr);
  if(tr.apb_operation == WRITE || tr.apb_operation == READ) begin
    super.write(tr);
  end
endfunction