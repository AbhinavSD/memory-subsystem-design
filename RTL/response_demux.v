`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2026 23:00:48
// Design Name: 
// Module Name: response_demux
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


module response_demux #(
    parameter DATA_WIDTH = 8
)(
    input  wire [3:0]            grant,
    input  wire [DATA_WIDTH-1:0] rdata,
    input  wire                  ready,

    output reg [DATA_WIDTH-1:0] rdata0,
    output reg                  ready0,

    output reg [DATA_WIDTH-1:0] rdata1,
    output reg                  ready1,

    output reg [DATA_WIDTH-1:0] rdata2,
    output reg                  ready2,

    output reg [DATA_WIDTH-1:0] rdata3,
    output reg                  ready3
);

always @(*) begin

    // Default outputs
    rdata0 = {DATA_WIDTH{1'b0}};
    rdata1 = {DATA_WIDTH{1'b0}};
    rdata2 = {DATA_WIDTH{1'b0}};
    rdata3 = {DATA_WIDTH{1'b0}};

    ready0 = 1'b0;
    ready1 = 1'b0;
    ready2 = 1'b0;
    ready3 = 1'b0;

    case(grant)

        4'b0001:
        begin
            rdata0 = rdata;
            ready0 = ready;
        end

        4'b0010:
        begin
            rdata1 = rdata;
            ready1 = ready;
        end

        4'b0100:
        begin
            rdata2 = rdata;
            ready2 = ready;
        end

        4'b1000:
        begin
            rdata3 = rdata;
            ready3 = ready;
        end

        default:
        begin
            // Keep default values
        end

    endcase

end

endmodule
