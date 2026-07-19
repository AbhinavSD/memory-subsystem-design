`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 22:12:42
// Design Name: 
// Module Name: request_mux
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


module request_mux #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  wire [3:0] grant,

    // Client 0
    input  wire                    rw0,
    input  wire [ADDR_WIDTH-1:0]   addr0,
    input  wire [DATA_WIDTH-1:0]   wdata0,

    // Client 1
    input  wire                    rw1,
    input  wire [ADDR_WIDTH-1:0]   addr1,
    input  wire [DATA_WIDTH-1:0]   wdata1,

    // Client 2
    input  wire                    rw2,
    input  wire [ADDR_WIDTH-1:0]   addr2,
    input  wire [DATA_WIDTH-1:0]   wdata2,

    // Client 3
    input  wire                    rw3,
    input  wire [ADDR_WIDTH-1:0]   addr3,
    input  wire [DATA_WIDTH-1:0]   wdata3,

    // Selected Output
    output reg                     rw,
    output reg [ADDR_WIDTH-1:0]    addr,
    output reg [DATA_WIDTH-1:0]    wdata
);

always @(*) begin

    // Default outputs
    rw    = 1'b0;
    addr  = {ADDR_WIDTH{1'b0}};
    wdata = {DATA_WIDTH{1'b0}};

    case (grant)

        4'b0001:
        begin
            rw    = rw0;
            addr  = addr0;
            wdata = wdata0;
        end

        4'b0010:
        begin
            rw    = rw1;
            addr  = addr1;
            wdata = wdata1;
        end

        4'b0100:
        begin
            rw    = rw2;
            addr  = addr2;
            wdata = wdata2;
        end

        4'b1000:
        begin
            rw    = rw3;
            addr  = addr3;
            wdata = wdata3;
        end

        default:
        begin
            rw    = 1'b0;
            addr  = {ADDR_WIDTH{1'b0}};
            wdata = {DATA_WIDTH{1'b0}};
        end

    endcase

end

endmodule
