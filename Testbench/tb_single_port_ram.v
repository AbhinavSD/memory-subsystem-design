`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2026 22:53:33
// Design Name: 
// Module Name: tb_single_port_ram
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


`timescale 1ns/1ps

module tb_single_port_ram;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg clk;
    reg we;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;

    // DUT
    single_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initialize
        we   = 0;
        addr = 0;
        din  = 0;

        // -------------------------
        // Write AA to Address 3
        // -------------------------
        @(posedge clk);
        we   = 1;
        addr = 4'd3;
        din  = 8'hAA;

        // -------------------------
        // Write 55 to Address 5
        // -------------------------
        @(posedge clk);
        addr = 4'd5;
        din  = 8'h55;

        // -------------------------
        // Read Address 3
        // -------------------------
        @(posedge clk);
        we   = 0;
        addr = 4'd3;

        @(posedge clk);
        $display("Read Addr 3 = %h", dout);

        // -------------------------
        // Read Address 5
        // -------------------------
        addr = 4'd5;

        @(posedge clk);
        $display("Read Addr 5 = %h", dout);

        #10;
        $finish;
    end

endmodule
