`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2026 18:10:19
// Design Name: 
// Module Name: round_robin_arbiter
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


module round_robin_arbiter(
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] req,
    output reg  [3:0] grant
);

reg [1:0] pointer;

//-------------------------
// Combinational Grant Logic
//-------------------------
always @(*) begin

    grant = 4'b0000;

    case(pointer)

        2'd0:
        begin
            if(req[0])      grant = 4'b0001;
            else if(req[1]) grant = 4'b0010;
            else if(req[2]) grant = 4'b0100;
            else if(req[3]) grant = 4'b1000;
        end

        2'd1:
        begin
            if(req[1])      grant = 4'b0010;
            else if(req[2]) grant = 4'b0100;
            else if(req[3]) grant = 4'b1000;
            else if(req[0]) grant = 4'b0001;
        end

        2'd2:
        begin
            if(req[2])      grant = 4'b0100;
            else if(req[3]) grant = 4'b1000;
            else if(req[0]) grant = 4'b0001;
            else if(req[1]) grant = 4'b0010;
        end

        2'd3:
        begin
            if(req[3])      grant = 4'b1000;
            else if(req[0]) grant = 4'b0001;
            else if(req[1]) grant = 4'b0010;
            else if(req[2]) grant = 4'b0100;
        end

    endcase

end

//-------------------------
// Pointer Update Logic
//-------------------------
always @(posedge clk or posedge rst)
begin

    if(rst)
        pointer <= 2'd0;

    else begin

        case(grant)

            4'b0001: pointer <= 2'd1;
            4'b0010: pointer <= 2'd2;
            4'b0100: pointer <= 2'd3;
            4'b1000: pointer <= 2'd0;

            default: pointer <= pointer;

        endcase

    end

end

endmodule
