`timescale 1ns/1ps

module tb_apb_timer;

  // Clock & Reset
  reg PCLK, PCLKG, PRESETn;
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;  // 100 MHz clock
  end
  assign PCLKG = PCLK; // No separate clock gating in TB

  initial begin
    PRESETn = 0;
    #20 PRESETn = 1; // Release reset after 20ns
  end

  // APB Signals
  reg PSEL, PENABLE, PWRITE;
  reg [11:2] PADDR;
  reg [31:0] PWDATA;
  wire [31:0] PRDATA;
  wire PREADY, PSLVERR;

  // External input
  reg EXTIN;

  // Timer interrupt
  wire TIMERINT;

  // Revision
  reg [3:0] ECOREVNUM;

  // DUT instantiation
  apb_timer dut (
    .PCLK(PCLK),
    .PCLKG(PCLKG),
    .PRESETn(PRESETn),
    .PSEL(PSEL),
    .PADDR(PADDR),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .ECOREVNUM(ECOREVNUM),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR),
    .EXTIN(EXTIN),
    .TIMERINT(TIMERINT)
  );

  // APB Write Task
  task apb_write(input [11:2] addr, input [31:0] data);
    begin
      @(posedge PCLK);
      PSEL    = 1;
      PENABLE = 0;
      PWRITE  = 1;
      PADDR   = addr;
      PWDATA  = data;
      @(posedge PCLK);
      PENABLE = 1;
      @(posedge PCLK);
      PSEL    = 0;
      PENABLE = 0;
      PWRITE  = 0;
    end
  endtask

  // APB Read Task
  task apb_read(input [11:2] addr, output [31:0] data);
    begin
      @(posedge PCLK);
      PSEL    = 1;
      PENABLE = 0;
      PWRITE  = 0;
      PADDR   = addr;
      @(posedge PCLK);
      PENABLE = 1;
      @(posedge PCLK);
      data = PRDATA;
      PSEL    = 0;
      PENABLE = 0;
    end
  endtask

  // Stimulus
  initial begin
    ECOREVNUM = 4'h1;
    EXTIN = 0;
    PSEL = 0; PENABLE = 0; PWRITE = 0;
    PADDR = 0; PWDATA = 0;

    // Wait for reset release
    @(posedge PRESETn);

    // Configure reload value = 10
    apb_write(10'h002, 32'd10); // Addr = 0x08
    // Enable timer with interrupt
    apb_write(10'h000, 32'b1001); // [3]=INT_EN, [0]=ENABLE

    // Let timer run
    repeat (20) @(posedge PCLK);

    // Check interrupt status
    $display("TIMERINT = %0d at time %t", TIMERINT, $time);

    // Clear interrupt
    apb_write(10'h003, 32'h1);

    // Observe
    repeat (10) @(posedge PCLK);

    $finish;
  end

endmodule
