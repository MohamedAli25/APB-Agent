interface apb_monitor_bfm
  //------------------------------------------
  // Imports
  //------------------------------------------
  import uvm_pkg::*;
  import apb_agent_pkg::*;
  #(
  //------------------------------------------
  // Parameters
  //------------------------------------------
  parameter ADDR_WIDTH,
  parameter DATA_WIDTH,
  parameter NUM_OF_SLAVES
)(
  //------------------------------------------
  // Signals
  //------------------------------------------
  input bit                             PCLK,
  input bit                             PRESETn,
  input logic [ADDR_WIDTH-1:0]          PADDR,
  input logic [2:0]                     PPROT,
  input logic [NUM_OF_SLAVES-1:0]       PSELx,
  input logic                           PENABLE,
  input logic                           PWRITE,
  input logic [DATA_WIDTH-1:0]          PWDATA,
  input logic [DATA_WIDTH/8-1:0]        PSTRB,
  input logic                           PREADY,
  input logic [DATA_WIDTH-1:0]          PRDATA,
  input logic                           PSLVERR,
  input logic                           PWAKEUP,
  
  //------------------------------------------
  // Parity Check Signals
  //------------------------------------------
  input logic [$ceil(ADDR_WIDTH/8)-1:0] PADDRCHK,
  input logic                           PCTRLCHK,
  input logic                           PSELxCHK,
  input logic                           PENABLECHK,
  input logic [DATA_WIDTH/8-1:0]        PWDATACHK,
  input logic                           PSTRBCHK,
  input logic                           PREADYCHK,
  input logic [DATA_WIDTH/8-1:0]        PRDATACHK,
  input logic                           PSLVERRCHK,
  input logic                           PWAKEUPCHK
);

  //------------------------------------------
  // Includes
  //------------------------------------------
  `include "uvm_macros.svh"

  //------------------------------------------
  // Events
  //------------------------------------------
  event reset_detected_e;

endinterface: apb_monitor_bfm
