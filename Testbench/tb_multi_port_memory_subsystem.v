`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2026 23:39:12
// Design Name: 
// Module Name: tb_multi_port_memory_subsystem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////timescale 1ns / 1ps
module tb_multi_port_memory_subsystem;

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 4;

//--------------------------------------------------
// Clock & Reset
//--------------------------------------------------
reg clk;
reg rst;

//--------------------------------------------------
// Client 0
//--------------------------------------------------
reg req0;
reg rw0;
reg [ADDR_WIDTH-1:0] addr0;
reg [DATA_WIDTH-1:0] wdata0;

//--------------------------------------------------
// Client 1
//--------------------------------------------------
reg req1;
reg rw1;
reg [ADDR_WIDTH-1:0] addr1;
reg [DATA_WIDTH-1:0] wdata1;

//--------------------------------------------------
// Client 2
//--------------------------------------------------
reg req2;
reg rw2;
reg [ADDR_WIDTH-1:0] addr2;
reg [DATA_WIDTH-1:0] wdata2;

//--------------------------------------------------
// Client 3
//--------------------------------------------------
reg req3;
reg rw3;
reg [ADDR_WIDTH-1:0] addr3;
reg [DATA_WIDTH-1:0] wdata3;

//--------------------------------------------------
// Outputs
//--------------------------------------------------
wire [DATA_WIDTH-1:0] rdata0;
wire ready0;

wire [DATA_WIDTH-1:0] rdata1;
wire ready1;

wire [DATA_WIDTH-1:0] rdata2;
wire ready2;

wire [DATA_WIDTH-1:0] rdata3;
wire ready3;

//--------------------------------------------------
// Performance Counters
//--------------------------------------------------
wire [31:0] read_count;
wire [31:0] write_count;
wire [31:0] grant_count;
wire [31:0] transaction_count;

//--------------------------------------------------
// DUT
//--------------------------------------------------
multi_port_memory_subsystem DUT
(
    .clk(clk),
    .rst(rst),

    .req0(req0),
    .rw0(rw0),
    .addr0(addr0),
    .wdata0(wdata0),

    .req1(req1),
    .rw1(rw1),
    .addr1(addr1),
    .wdata1(wdata1),

    .req2(req2),
    .rw2(rw2),
    .addr2(addr2),
    .wdata2(wdata2),

    .req3(req3),
    .rw3(rw3),
    .addr3(addr3),
    .wdata3(wdata3),

    .rdata0(rdata0),
    .ready0(ready0),

    .rdata1(rdata1),
    .ready1(ready1),

    .rdata2(rdata2),
    .ready2(ready2),

    .rdata3(rdata3),
    .ready3(ready3),

    .read_count(read_count),
    .write_count(write_count),
    .grant_count(grant_count),
    .transaction_count(transaction_count)
);

//--------------------------------------------------
// Clock Generation
//--------------------------------------------------
always #5 clk = ~clk;

//--------------------------------------------------
// Stimulus
//--------------------------------------------------
initial
begin

    clk = 0;
    rst = 1;

    req0 = 0; rw0 = 0; addr0 = 0; wdata0 = 0;
    req1 = 0; rw1 = 0; addr1 = 0; wdata1 = 0;
    req2 = 0; rw2 = 0; addr2 = 0; wdata2 = 0;
    req3 = 0; rw3 = 0; addr3 = 0; wdata3 = 0;

    //------------------------------------------
    // Reset
    //------------------------------------------
    #20;
    rst = 0;

    //------------------------------------------
    // Client0 WRITE
    //------------------------------------------
    @(posedge clk);
    req0 = 1;
    rw0 = 1;
    addr0 = 4'd3;
    wdata0 = 8'hA5;

    @(posedge clk);
    req0 = 0;

    repeat(4) @(posedge clk);

    //------------------------------------------
    // Client0 READ
    //------------------------------------------
    req0 = 1;
    rw0 = 0;
    addr0 = 4'd3;

    @(posedge clk);
    req0 = 0;

    repeat(4) @(posedge clk);

    //------------------------------------------
    // Client1 WRITE
    //------------------------------------------
    req1 = 1;
    rw1 = 1;
    addr1 = 4'd7;
    wdata1 = 8'h3C;

    @(posedge clk);
    req1 = 0;

    repeat(4) @(posedge clk);

    //------------------------------------------
    // Client1 READ
    //------------------------------------------
    req1 = 1;
    rw1 = 0;
    addr1 = 4'd7;

    @(posedge clk);
    req1 = 0;

    repeat(5) @(posedge clk);

    //==========================================================
    // STEP 24 : CORNER CASE TESTS
    //==========================================================

    //------------------------------------------
    // Consecutive Writes
    //------------------------------------------
    req0 = 1;
    rw0 = 1;
    addr0 = 4'd5;
    wdata0 = 8'hAA;

    @(posedge clk);
    req0 = 0;

    @(posedge clk);

    req0 = 1;
    rw0 = 1;
    addr0 = 4'd5;
    wdata0 = 8'hBB;

    @(posedge clk);
    req0 = 0;

    repeat(4) @(posedge clk);

    //------------------------------------------
    // Read Back
    //------------------------------------------
    req0 = 1;
    rw0 = 0;
    addr0 = 4'd5;

    @(posedge clk);
    req0 = 0;

    repeat(4) @(posedge clk);

    $display("--------------------------------------");
    $display("Read Back Data = %h", rdata0);
    $display("--------------------------------------");

    //------------------------------------------
    // Idle Cycles
    //------------------------------------------
    repeat(5) @(posedge clk);

    //------------------------------------------
    // Boundary Address Test (Address 0)
    //------------------------------------------
    req1 = 1;
    rw1 = 1;
    addr1 = 4'd0;
    wdata1 = 8'h11;

    @(posedge clk);
    req1 = 0;

    repeat(4) @(posedge clk);

    //------------------------------------------
    // Boundary Address Test (Address 15)
    //------------------------------------------
    req1 = 1;
    rw1 = 1;
    addr1 = 4'd15;
    wdata1 = 8'hFF;

    @(posedge clk);
    req1 = 0;

    repeat(4) @(posedge clk);

   //--------------------------------------------------
// STEP 24 : Corner Case 1
// Consecutive Writes to Same Address
//--------------------------------------------------

req0 = 1;
rw0 = 1;
addr0 = 4'd5;
wdata0 = 8'hAA;

@(posedge clk);
req0 = 0;

repeat(4) @(posedge clk);

req0 = 1;
rw0 = 1;
addr0 = 4'd5;
wdata0 = 8'hBB;

@(posedge clk);
req0 = 0;

repeat(4) @(posedge clk);

//--------------------------------------------------
// Read Back Same Address
//--------------------------------------------------

req0 = 1;
rw0 = 0;
addr0 = 4'd5;

@(posedge clk);
req0 = 0;

repeat(4) @(posedge clk);

$display("Read Back Data (Addr 5) = %h", rdata0);

//--------------------------------------------------
// Idle Cycles
//--------------------------------------------------

repeat(5) @(posedge clk);

//--------------------------------------------------
// Boundary Address Test : Address 0
//--------------------------------------------------

req1 = 1;
rw1 = 1;
addr1 = 4'd0;
wdata1 = 8'h11;

@(posedge clk);
req1 = 0;

repeat(4) @(posedge clk);

//--------------------------------------------------
// Boundary Address Test : Address 15
//--------------------------------------------------

req1 = 1;
rw1 = 1;
addr1 = 4'd15;
wdata1 = 8'hFF;

@(posedge clk);
req1 = 0;

repeat(4) @(posedge clk);

//--------------------------------------------------
// Final Results
//--------------------------------------------------

$display("--------------------------------------");
$display("Read Count        = %0d", read_count);
$display("Write Count       = %0d", write_count);
$display("Grant Count       = %0d", grant_count);
$display("Transaction Count = %0d", transaction_count);
$display("--------------------------------------");

$finish;

end

endmodule

