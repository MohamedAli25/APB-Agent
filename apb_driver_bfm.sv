interface apb_driver_bfm
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
  input  bit                              PCLK,
  input  bit                              PRESETn,
  output logic [ADDR_WIDTH-1:0]           PADDR,
  output logic [2:0]                      PPROT,
  output logic [NUM_OF_SLAVES-1:0]        PSELx,
  output logic                            PENABLE,
  output logic                            PWRITE,
  output logic [DATA_WIDTH-1:0]           PWDATA,
  output logic [DATA_WIDTH/8-1:0]         PSTRB,
  input  logic                            PREADY,
  input  logic [DATA_WIDTH-1:0]           PRDATA,
  input  logic                            PSLVERR,
  output logic                            PWAKEUP,
  
  //------------------------------------------
  // Parity Check Signals
  //------------------------------------------
  output logic [$ceil(ADDR_WIDTH/8)-1:0]  PADDRCHK,
  output logic                            PCTRLCHK,
  output logic [NUM_OF_SLAVES-1:0]        PSELxCHK,
  output logic                            PENABLECHK,
  output logic [DATA_WIDTH/8-1:0]         PWDATACHK,
  output logic                            PSTRBCHK,
  input logic                             PREADYCHK,
  input logic [DATA_WIDTH/8-1:0]          PRDATACHK,
  input logic                             PSLVERRCHK,
  output logic                            PWAKEUPCHK
);

  // Reset the values of the signals when PRESETn is asserted
  always @(negedge PRESETn) begin
    PADDR = {ADDR_WIDTH{1'b0}};
    PPROT = 3'b0;
    PSELx = {NUM_OF_SLAVES{1'b0}};
    PENABLE = 1'b0;
    PWRITE = 1'b0;
    PWDATA = {DATA_WIDTH{1'b0}};
    PSTRB = {DATA_WIDTH/8{1'b0}};
    PWAKEUP = 1'b0;
  end

  task automatic write(apb_seq_item apb_seq_item_h);
    // Case when PWAKEUP signal assertion is before PSELx assertion
    if (apb_seq_item_h.wakeup_assertion_timing == BEFORE_PSELX_ASSERTION) begin
      PWAKEUP = PWAKEUP_WAKEUP;
      repeat (apb_seq_item_h.difference_between_pwakeup_assertion_and_pselx_assertion) begin
        @(posedge PCLK);
      end
    end
    // Setup Phase
    PADDR = apb_seq_item_h.address;
    PWRITE = PWRITE_WRITE;
    PSELx[apb_seq_item_h.slave_num] = PSELX_ENABLE;
    PENABLE = PENABLE_DISABLE;
    PWDATA = apb_seq_item_h.write_data;
    foreach(apb_seq_item_h.write_data_valid[i]) begin
      PSTRB[i] = apb_seq_item_h.write_data_valid[i];
    end
    PPROT[0] = apb_seq_item_h.pprot_normal_privileged;
    PPROT[1] = apb_seq_item_h.pprot_secure_non_secure;
    PPROT[2] = apb_seq_item_h.pprot_data_instruction;
    // Case when PWAKEUP signal assertion during PSELx assertion
    if (apb_seq_item_h.wakeup_assertion_timing == DURING_PSELX_ASSERTION) begin
      PWAKEUP = PWAKEUP_WAKEUP;
    end
    fork
      begin
        // Case when PWAKEUP signal assertion is after PSELx assertion
        if (apb_seq_item_h.wakeup_assertion_timing == AFTER_PSELX_ASSERTION) begin
          // Wait for clock cycles before the assertion of PWAKEUP
          repeat (apb_seq_item_h.difference_between_pwakeup_assertion_and_pselx_assertion) begin
            @(posedge PCLK);
          end
          PWAKEUP = PWAKEUP_WAKEUP;
          @(posedge PCLK);
          // Check if PWAKEUP and PSELx are asserted at the same clock cycle
          if (PSELx[apb_seq_item_h.slave_num] == PSELX_ENABLE) begin
            wait(PREADY == PREADY_READY);
            @(posedge PCLK);
            apb_seq_item_h.error = PSLVERR;
          end
          // Wait for clock cycles before the deassertion of PWAKEUP
          repeat (apb_seq_item_h.clock_cycles_until_pwakeup_deassertion) begin
            @(posedge PCLK);
          end
          PWAKEUP = PWAKEUP_NO_WAKEUP;
        end
      end

      begin
        @(posedge PCLK);
        // Access Phase
        PENABLE = PENABLE_ENABLE;
        @(posedge PCLK);
        wait(PREADY == PREADY_READY);
        @(posedge PCLK);
        apb_seq_item_h.error = PSLVERR;
        PSELx[apb_seq_item_h.slave_num] = PSELX_DISABLE;
        // Wait for clock cycles before the deassertion of PWAKEUP
        repeat (apb_seq_item_h.clock_cycles_until_pwakeup_deassertion) begin
          @(posedge PCLK);
        end
        PWAKEUP = PWAKEUP_NO_WAKEUP;
      end
    join
  endtask: write

  task automatic read(apb_seq_item apb_seq_item_h);
    // Case when PWAKEUP signal assertion is before PSELx assertion
    if (apb_seq_item_h.wakeup_assertion_timing == BEFORE_PSELX_ASSERTION) begin
      PWAKEUP = PWAKEUP_WAKEUP;
      repeat (apb_seq_item_h.difference_between_pwakeup_assertion_and_pselx_assertion) begin
        @(posedge PCLK);
      end
    end
    // Setup Phase
    PADDR = apb_seq_item_h.address;
    PWRITE = PWRITE_READ;
    PSELx[apb_seq_item_h.slave_num] = PSELX_ENABLE;
    PENABLE = PENABLE_DISABLE;
    PPROT[0] = apb_seq_item_h.pprot_normal_privileged;
    PPROT[1] = apb_seq_item_h.pprot_secure_non_secure;
    PPROT[2] = apb_seq_item_h.pprot_data_instruction;
    // Case when PWAKEUP signal assertion during PSELx assertion
    if (apb_seq_item_h.wakeup_assertion_timing == DURING_PSELX_ASSERTION) begin
      PWAKEUP = PWAKEUP_WAKEUP;
    end
    fork
      begin
        // Case when PWAKEUP signal assertion is after PSELx assertion
        if (apb_seq_item_h.wakeup_assertion_timing == AFTER_PSELX_ASSERTION) begin
          // Wait for clock cycles before the assertion of PWAKEUP
          repeat (apb_seq_item_h.difference_between_pwakeup_assertion_and_pselx_assertion) begin
            @(posedge PCLK);
          end
          PWAKEUP = PWAKEUP_WAKEUP;
          @(posedge PCLK);
          // Check if PWAKEUP and PSELx are asserted at the same clock cycle
          if (PSELx[apb_seq_item_h.slave_num] == PSELX_ENABLE) begin
            wait(PREADY == PREADY_READY);
            @(posedge PCLK);
            apb_seq_item_h.read_data = PRDATA;
            apb_seq_item_h.error = PSLVERR;
          end
          // Wait for clock cycles before the deassertion of PWAKEUP
          repeat (apb_seq_item_h.clock_cycles_until_pwakeup_deassertion) begin
            @(posedge PCLK);
          end
          PWAKEUP = PWAKEUP_NO_WAKEUP;
        end
      end

      begin
        @(posedge PCLK);
        // Access Phase
        PENABLE = PENABLE_ENABLE;
        @(posedge PCLK);
        wait(PREADY == PREADY_READY);
        @(posedge PCLK);
        apb_seq_item_h.read_data = PRDATA;
        apb_seq_item_h.error = PSLVERR;
        PSELx[apb_seq_item_h.slave_num] = PSELX_DISABLE;
        // Wait for clock cycles before the deassertion of PWAKEUP
        repeat (apb_seq_item_h.clock_cycles_until_pwakeup_deassertion) begin
          @(posedge PCLK);
        end
        PWAKEUP = PWAKEUP_NO_WAKEUP;
      end
    join
  endtask: read

  task automatic delay(apb_seq_item apb_seq_item_h);
    repeat (apb_seq_item_h.delay_num_of_clock_cycles) begin
      @(posedge PCLK);
    end
  endtask: delay

  task automatic wakeup(apb_seq_item apb_seq_item_h);
    PWAKEUP = PWAKEUP_WAKEUP;
    repeat (apb_seq_item_h.delay_num_of_clock_cycles) begin
      @(posedge PCLK);
    end
    PWAKEUP = PWAKEUP_NO_WAKEUP;
  endtask: wakeup

  //------------------------------------------
  // Parity Check Signals Logic
  //------------------------------------------
  always @(PADDR) begin
    foreach (PADDRCHK[i]) begin
      PADDRCHK[i] = !(^PADDR[8*i+:8]);
    end
  end

  always @(PPROT or PWRITE) begin
    PCTRLCHK = !(^{PPROT, PWRITE});
  end

  always @(PSELx) begin
    foreach (PSELxCHK[i]) begin
      PSELxCHK[i] = !PSELx[i];
    end
  end

  always @(PENABLE) begin
    PCTRLCHK = !PENABLE;
  end

  always @(PWDATA) begin
    foreach (PWDATACHK[i]) begin
      PWDATACHK[i] = !(^PWDATA[8*i+:8]);
    end
  end

  always @(PSTRB) begin
    PSTRBCHK = !(^PSTRB);
  end

  always @(PWAKEUP) begin
    PWAKEUPCHK = !PWAKEUP;
  end

endinterface: apb_driver_bfm
