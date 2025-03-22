`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2024 12:27:40 PM
// Design Name: 
// Module Name: second_stage
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


module second_stage(
    input clk,
    input reset,
    input [7:0] expo_second_stage,
    input sign_second_stage,
    input [24:0] mantissa_second_stage,
    output reg [31:0] result
    );

reg [23:0] normalized_mantissa;
reg [7:0] expo_second_stage_reg;
reg [23:0] mantissa1_reg;
reg [23:0] mantissa2_reg;

//always @ (posedge clk or posedge reset) begin
//    if (reset == 1'b1) begin
//        result <= 0;
//        expo_second_stage_reg <= 0;
//    end
//    else begin
//        expo_second_stage_reg <= expo_second_stage;
//    end
//end

always @ (*) begin
    expo_second_stage_reg = expo_second_stage;
   /*Repeat the post normalization process*/
   if ((mantissa_second_stage[24] == 1) && (mantissa_second_stage[23] == 0)) begin
        normalized_mantissa = mantissa_second_stage[24:1];
        if (normalized_mantissa[22:0] == 23'd0) begin
            expo_second_stage_reg = 8'd0;
        end
        else begin
            expo_second_stage_reg = expo_second_stage_reg + 8'd1;
        end
   end
   else begin
       normalized_mantissa = mantissa_second_stage;
       repeat(24) begin
           if(normalized_mantissa[23] == 1'b1) begin
               normalized_mantissa = normalized_mantissa << 0;
               expo_second_stage_reg = expo_second_stage_reg - 8'd0;
           end
           else begin
                normalized_mantissa = normalized_mantissa << 1;
                expo_second_stage_reg = expo_second_stage_reg - 8'd1;
           end
       end
   end    

   if (mantissa_second_stage == 24'd0) begin
        result[30:23] = 8'd0;
   end
   else begin
        result[30:23] = expo_second_stage_reg;
   end
   
   result[22:0] = normalized_mantissa[22:0];
   result[31] = sign_second_stage;
   
end
endmodule
