`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSL 
// Engineer: Nikos Bellas
// 
// Create Date: 03/29/2024 05:16:54 PM
// Design Name: Akraio DEsign.v
// Module Name: DFF
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


module DFF(
    input clk,
    input reset,
    input D,
    output reg Q
    );
     
always @(posedge clk) begin
    if(reset == 1'b1)
        Q <= 0;
     else
        Q <= D;
end

endmodule