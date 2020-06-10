`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2020 08:46:30 AM
// Design Name: 
// Module Name: tb_qlue_cisc
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


module tb_qlue_cisc();
    logic clk;
    logic reset;
    
qlue_cisc DUT(.clk(clk), .reset(reset));

parameter PERIOD = 4;

always begin
  clk = 1'b0; #(PERIOD/2);
  clk = 1'b1; #(PERIOD/2);
end

initial begin
    reset = 1; #10;
    reset = 0; #1000;
    $finish;
end;
endmodule
