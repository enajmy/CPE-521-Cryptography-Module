`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 04:45:12 PM
// Design Name: 
// Module Name: tb_Cryptography_Module
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


module tb_Cryptography_Module();

//define signals
logic [31:0] sim_din;
logic [31:0] sim_key;
logic [1:0] sim_count;
logic sim_sel;
logic [31:0] sim_result;

//link signals to module 
 Cryptography_Module crypto_mod(.data_in(sim_din), .key(sim_key), .cnt(sim_count), .sel(sim_sel), .result(sim_result));

//set up test cases
initial begin
    sim_din = 32'hdead_beef;
    sim_key = 32'hc0ff_eeee;
    sim_count = 0;
    sim_sel = 0;
    sim_result = 32'h0000_0000;
    #10;
    
    sim_count = 1;
    #10;
    
    sim_count = 2;
    #10;
    
    sim_count = 3;
    #10;
    
    #10;
    
    sim_din = 32'h1c025000;
    sim_key = 32'hc0ff_eeee;
    sim_count = 0;
    sim_sel = 1;
    sim_result = 32'h0000_0000;
    #10;
    
    sim_count = 1;
    #10;
    
    sim_count = 2;
    #10;
    
    sim_count = 3;
    #10;
    
    #10;

end


endmodule
