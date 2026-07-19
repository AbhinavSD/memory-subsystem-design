`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 20:42:37
// Design Name: 
// Module Name: multi_port_memory_subsystem
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
//////////////////////////////////////////////////////////////////////////////////


module multi_port_memory_subsystem #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input wire clk,
    input wire rst,

    //==============================
    // Client 0
    //==============================
    input wire req0,
    input wire rw0,
    input wire [ADDR_WIDTH-1:0] addr0,
    input wire [DATA_WIDTH-1:0] wdata0,

    //==============================
    // Client 1
    //==============================
    input wire req1,
    input wire rw1,
    input wire [ADDR_WIDTH-1:0] addr1,
    input wire [DATA_WIDTH-1:0] wdata1,

    //==============================
    // Client 2
    //==============================
    input wire req2,
    input wire rw2,
    input wire [ADDR_WIDTH-1:0] addr2,
    input wire [DATA_WIDTH-1:0] wdata2,

    //==============================
    // Client 3
    //==============================
    input wire req3,
    input wire rw3,
    input wire [ADDR_WIDTH-1:0] addr3,
    input wire [DATA_WIDTH-1:0] wdata3,

    //==============================
    // Client Responses
    //==============================
    output wire [DATA_WIDTH-1:0] rdata0,
    output wire ready0,

    output wire [DATA_WIDTH-1:0] rdata1,
    output wire ready1,

    output wire [DATA_WIDTH-1:0] rdata2,
    output wire ready2,

    // Client 3 Response
    output wire [DATA_WIDTH-1:0] rdata3,
    output wire ready3,

    // Performance Counter Outputs
    output wire [31:0] read_count,
    output wire [31:0] write_count,
    output wire [31:0] grant_count,
    output wire [31:0] transaction_count

);

    //--------------------------------------------------
    // Internal Wires
    //--------------------------------------------------

    // Request vector for arbiter
    wire [3:0] req;
    assign req = {req3, req2, req1, req0};

    // Arbiter output
    wire [3:0] grant;

    // Request MUX outputs
    wire                    mux_rw;
    wire [ADDR_WIDTH-1:0]   mux_addr;
    wire [DATA_WIDTH-1:0]   mux_wdata;

    // Memory Controller ↔ RAM
    wire                    ram_we;
    wire [ADDR_WIDTH-1:0]   ram_addr;
    wire [DATA_WIDTH-1:0]   ram_din;
    wire [DATA_WIDTH-1:0]   ram_dout;

    // Memory Controller outputs
    wire [DATA_WIDTH-1:0]   mc_rdata;
    wire                    mc_ready;
   
    //--------------------------------------------------
    // Round Robin Arbiter
    //--------------------------------------------------
    round_robin_arbiter arbiter (
        .clk(clk),
        .rst(rst),
        .req(req),
        .grant(grant)
    );

    //--------------------------------------------------
    // Request Multiplexer
    //--------------------------------------------------
    request_mux #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) req_mux (

        .grant(grant),

        .rw0(rw0),
        .addr0(addr0),
        .wdata0(wdata0),

        .rw1(rw1),
        .addr1(addr1),
        .wdata1(wdata1),

        .rw2(rw2),
        .addr2(addr2),
        .wdata2(wdata2),

        .rw3(rw3),
        .addr3(addr3),
        .wdata3(wdata3),

        .rw(mux_rw),
        .addr(mux_addr),
        .wdata(mux_wdata)
    );

    //--------------------------------------------------
    // Memory Controller
    //--------------------------------------------------
    memory_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) controller (

        .clk(clk),
        .rst(rst),

        .grant(grant),

        .rw(mux_rw),
        .addr(mux_addr),
        .wdata(mux_wdata),

        .ram_we(ram_we),
        .ram_addr(ram_addr),
        .ram_din(ram_din),
        .ram_dout(ram_dout),

        .rdata(mc_rdata),
        .ready(mc_ready),

        .read_count(read_count),
        .write_count(write_count),
        .grant_count(grant_count),
        .transaction_count(transaction_count)
    );

    //--------------------------------------------------
    // Dual-Port RAM
    //--------------------------------------------------
    dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram (

        .clk(clk),

        // Port A
        .we_a(ram_we),
        .addr_a(ram_addr),
        .din_a(ram_din),
        .dout_a(ram_dout),

        // Port B (Unused)
        .we_b(1'b0),
        .addr_b({ADDR_WIDTH{1'b0}}),
        .din_b({DATA_WIDTH{1'b0}}),
        .dout_b()
    );

    //--------------------------------------------------
    // Response Demultiplexer
    //--------------------------------------------------
    response_demux #(
        .DATA_WIDTH(DATA_WIDTH)
    ) resp_demux (

        .grant(grant),

        .rdata(mc_rdata),
        .ready(mc_ready),

        .rdata0(rdata0),
        .ready0(ready0),

        .rdata1(rdata1),
        .ready1(ready1),

        .rdata2(rdata2),
        .ready2(ready2),

        .rdata3(rdata3),
        .ready3(ready3)
    );

endmodule
