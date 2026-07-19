`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2026 19:26:31
// Design Name: 
// Module Name: memory_controller
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


  module memory_controller #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  wire                    clk,
    input  wire                    rst,

    // Arbiter Interface
    input  wire [3:0]              grant,
    input  wire                    rw,
    input  wire [ADDR_WIDTH-1:0]   addr,
    input  wire [DATA_WIDTH-1:0]   wdata,

    // RAM Interface
    output reg                     ram_we,
    output reg [ADDR_WIDTH-1:0]    ram_addr,
    output reg [DATA_WIDTH-1:0]    ram_din,
    input  wire [DATA_WIDTH-1:0]   ram_dout,

    // Response Interface
    output reg [DATA_WIDTH-1:0]    rdata,
    output reg                     ready,

    // Performance Counters
    output reg [31:0]              read_count,
    output reg [31:0]              write_count,
    output reg [31:0]              grant_count,
    output reg [31:0]              transaction_count
);

    //--------------------------------------------------
    // FSM States
    //--------------------------------------------------
    localparam IDLE     = 2'd0;
    localparam PROCESS  = 2'd1;
    localparam COMPLETE = 2'd2;

    reg [1:0] state;

    //--------------------------------------------------
    // Latched Transaction Registers
    //--------------------------------------------------
    reg                     rw_reg;
    reg [3:0]               grant_reg;
    reg [ADDR_WIDTH-1:0]    addr_reg;
    reg [DATA_WIDTH-1:0]    wdata_reg;

    //--------------------------------------------------
    // State Register & Performance Counters
    //--------------------------------------------------
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= IDLE;

            // Reset counters
            read_count        <= 32'd0;
            write_count       <= 32'd0;
            grant_count       <= 32'd0;
            transaction_count <= 32'd0;

            // Reset latched registers
            rw_reg    <= 1'b0;
            grant_reg <= 4'b0000;
            addr_reg  <= {ADDR_WIDTH{1'b0}};
            wdata_reg <= {DATA_WIDTH{1'b0}};
        end
        else
        begin
            case(state)

                IDLE:
                begin
                    if(grant != 4'b0000)
                    begin
                        // Latch the transaction information
                        grant_reg <= grant;
                        rw_reg    <= rw;
                        addr_reg  <= addr;
                        wdata_reg <= wdata;

                        grant_count <= grant_count + 1;
                        state <= PROCESS;
                    end
                end

                PROCESS:
                begin
                    state <= COMPLETE;
                end

                COMPLETE:
                begin
                    state <= IDLE;

                    transaction_count <= transaction_count + 1;

                    if(rw_reg)
                        write_count <= write_count + 1;
                    else
                        read_count <= read_count + 1;
                end

                default:
                    state <= IDLE;

            endcase
        end
    end

    //--------------------------------------------------
    // Output Logic
    //--------------------------------------------------
    always @(*)
    begin

        // Default outputs
        ram_we   = 1'b0;
        ram_addr = addr_reg;
        ram_din  = wdata_reg;

        rdata    = ram_dout;
        ready    = 1'b0;

        case(state)

            IDLE:
            begin
                // Wait for grant
            end

            PROCESS:
            begin
                if(rw_reg)
                    ram_we = 1'b1;
                else
                    ram_we = 1'b0;
            end

            COMPLETE:
            begin
                ready = 1'b1;
            end

        endcase

    end

endmodule
