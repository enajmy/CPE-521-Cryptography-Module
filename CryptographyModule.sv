`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2023 02:18:46 PM
// Design Name: 
// Module Name: CryptographyModule
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

// rs1 - plain text
// rs2 - user key
// count - encryption state (0, 1, 2, 3)
// sel - encrypt or decrypt (0 or 1)
// rd - encrypted output data

module CryptographyModule(
    input [31:0] rs1,
    input [31:0] rs2,
    input [1:0] count,
    input sel,
    output [31:0] rd
    );



endmodule
