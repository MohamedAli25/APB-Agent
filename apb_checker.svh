checker apb_checker (
  byte unsigned                   ADDR_WIDTH,
  data_width_t                    DATA_WIDTH,
  longint unsigned                NUM_OF_SLAVES,
  bit                             PCLK,
  bit                             PRESETn,
  PADDR,
  logic [2:0]                     PPROT,
         PSELx,
  logic                           PENABLE,
  logic                           PWRITE,
            PWDATA,
          PSTRB,
  logic                           PREADY,
            PRDATA,
  logic                           PSLVERR,
  logic                           PWAKEUP,
  
  //------------------------------------------
  // Parity Check Signals
  //------------------------------------------
  logic [$ceil(ADDR_WIDTH/8)-1:0] PADDRCHK,
  logic                           PCTRLCHK,
  logic                           PSELxCHK,
  logic                           PENABLECHK,
  logic [DATA_WIDTH/8-1:0]        PWDATACHK,
  logic                           PSTRBCHK,
  logic                           PREADYCHK,
  logic [DATA_WIDTH/8-1:0]        PRDATACHK,
  logic                           PSLVERRCHK,
  logic                           PWAKEUPCHK
);
  default clocking @(posedge PCLK); endclocking

  //------------------------------------------
  // Sequences
  //------------------------------------------
  function automatic bit is_transfer_start;
    return PSELx != {NUM_OF_SLAVES{1'b0}};
  endfunction: is_transfer_start

  sequence transfer_start;
    is_transfer_start;
  endsequence

  sequence write_transfer_start;
    is_transfer_start && PWRITE == PWRITE_WRITE;
  endsequence

  sequence read_transfer_start;
    is_transfer_start && PWRITE == PWRITE_READ;
  endsequence
  
  //------------------------------------------
  // Properties
  //------------------------------------------
  property no_more_than_one_pselx_asserted_bit;
    disable iff(!PRESETn) $onehot0(PSELx) && !($isunknown(PSELx));
  endproperty

  // TODO: Modify this property
  property signals_always_valid;
    disable iff(!PRESETn) !$isunknown(PSELx) && !$isunknown(PWAKEUP);
  endproperty

  property signals_valid_when_pselx_asserted;
    disable iff(!PRESETn) $onehot(PSELx) |-> !$isunknown(PADDR) && !$isunknown(PPROT) && !$isunknown(PENABLE) && !$isunknown(PWRITE) && !$isunknown(PSTRB);
  endproperty

  property pwdata_valid_when_pselx_asserted(byte unsigned index);
    disable iff(!PRESETn) $onehot(PSELx) && !$isunknown(PSTRB[index]) |-> !$isunknown(PWDATA[8*index+:8]);
  endproperty

  property signals_valid_when_pselx_penable_asserted;
    disable iff(!PRESETn) $onehot(PSELx) && PENABLE |-> !$isunknown(PREADY);
  endproperty

  //------------------------------------------
  // Assertions
  //------------------------------------------
  // Assert that the ADDR_WIDTH is not more than 32 bits
  initial begin
    assert (ADDR_WIDTH <= 32 && ADDR_WIDTH >= 0) 
    else   `uvm_fatal("apb_monitor_bfm", "ADDR_WIDTH parameter is assigned a value out of bounds")
  end
  
  // Assert that the DATA_WIDTH is either 8, 16 or 32 bits
  initial begin
    assert (DATA_WIDTH == DATA_WIDTH_8 || DATA_WIDTH == DATA_WIDTH_16 || DATA_WIDTH == DATA_WIDTH_32) 
    else   `uvm_fatal("apb_monitor_bfm", "DATA_WIDTH parameter is assigned an invalid value")
  end

  // Assert that there is at most one completer that the requester is communicating with
  assert property (no_more_than_one_pselx_asserted_bit) else `uvm_error("apb_monitor_bfm", "There is more than one bit asserted in PSELx")
  assert property (signals_always_valid) else `uvm_error("apb_monitor_bfm", "PSELx or PWAKEUP wasn't valid in a clock cycle")
  assert property (signals_valid_when_pselx_asserted) else `uvm_error("apb_monitor_bfm", "PADDR, PPROT, PENABLE, PWRITE, PSTRB wasn't valid when PSELx was asserted")
  generate
    for(genvar i = 0; i < DATA_WIDTH/8; i = i + 1) begin
      assert property (pwdata_valid_when_pselx_asserted(i)) else `uvm_error("apb_monitor_bfm", "PWDATA wasn't valid when PSELx was asserted")
    end
  endgenerate
  assert property (signals_valid_when_pselx_penable_asserted) else `uvm_error("apb_monitor_bfm", "PREADY wasn't valid when PSELx and PENABLE are asserted")
  
  
  //------------------------------------------
  // Coverage
  //------------------------------------------
  cover property (no_more_than_one_pselx_asserted_bit) `uvm_info("apb_monitor_bfm", "no_more_than_one_pselx_asserted_bit PASS", UVM_NONE)
  cover property (signals_always_valid) `uvm_info("apb_monitor_bfm", "signals_always_valid PASS", UVM_NONE)
  cover property (signals_valid_when_pselx_asserted) `uvm_info("apb_monitor_bfm", "signals_valid_when_pselx_asserted PASS", UVM_NONE)
  for(genvar i = 0; i < DATA_WIDTH/8; i = i + 1) begin
    cover property (pwdata_valid_when_pselx_asserted(i)) `uvm_info("apb_monitor_bfm", "pwdata_valid_when_pselx_asserted PASS", UVM_NONE)
  end
  cover property (signals_valid_when_pselx_penable_asserted) `uvm_info("apb_monitor_bfm", "signals_valid_when_pselx_penable_asserted PASS", UVM_NONE)


endchecker: apb_checker