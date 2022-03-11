interface apb_if
  import apb_agent_pkg::*;
  #(
  //------------------------------------------
  // Parameters
  //------------------------------------------
  parameter ADDR_WIDTH,
  parameter DATA_WIDTH,
  parameter NUM_OF_SLAVES
  //------------------------------------------
)(
  input bit                       PCLK,
  input bit                       PRESETn
);

  //------------------------------------------
  // Signals
  //------------------------------------------
  logic [ADDR_WIDTH-1:0]          PADDR;
  logic [2:0]                     PPROT;
  logic [NUM_OF_SLAVES-1:0]       PSELx;
  logic                           PENABLE;
  logic                           PWRITE;
  logic [DATA_WIDTH-1:0]          PWDATA;
  logic [DATA_WIDTH/8-1:0]        PSTRB;
  logic                           PREADY;
  logic [DATA_WIDTH-1:0]          PRDATA;
  logic                           PSLVERR;
  logic                           PWAKEUP;
  
  //------------------------------------------
  // Parity Check Signals
  //------------------------------------------
  logic [$ceil(ADDR_WIDTH/8)-1:0] PADDRCHK;
  logic                           PCTRLCHK;
  logic                           PSELxCHK;
  logic                           PENABLECHK;
  logic [DATA_WIDTH/8-1:0]        PWDATACHK;
  logic                           PSTRBCHK;
  logic                           PREADYCHK;
  logic [DATA_WIDTH/8-1:0]        PRDATACHK;
  logic                           PSLVERRCHK;
  logic                           PWAKEUPCHK;

endinterface: apb_if
