`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 04:18:59 PM
// Design Name: 
// Module Name: Cryptography_Module
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


module Cryptography_Module(
    input [31:0] data_in,
    input [31:0] key,
    input [1:0] cnt,
    input sel,
    output reg [31:0] result
    );
    
    reg iv = 8'b10011011;
    
    always @(cnt, data_in, key, sel)
    begin
        if(sel == 0)
        begin
            case(cnt)
                0: result = {24'b0, iv ^ data_in[7:0] ^ key[7:0]};
                1: result |= (result[7:0] ^ data_in[15:8] ^ key[15:8]) << 8;
                2: result |= (result[15:8] ^ data_in[23:16] ^ key[23:16]) << 16;
                3: result |= (result[23:16] ^ data_in[31:24] ^ key[31:24]) << 24;
                default: result = 0;
            endcase
        end
        else
        begin
            case(cnt)
                0: result = {24'b0, iv ^ data_in[7:0] ^ key[7:0]};
                1: result |= (data_in[7:0] ^ data_in[15:8] ^ key[15:8]) << 8;
                2: result |= (data_in[15:8] ^ data_in[23:16] ^ key[23:16]) << 16;
                3: result |= (data_in[23:16] ^ data_in[31:24] ^ key[31:24]) << 24;
                default: result = 0;
            endcase
        end
    end
    
endmodule
