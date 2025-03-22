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


module first_stage(
    input clk, 
    input reset,
    input [31:0] reg_A,
    input [31:0] reg_B,
    output reg [24:0] mantissa_first_stage,
    output reg [7:0] expo_first_stage,
    output reg sign_first_stage
    //output reg done_first_stage
    );
    
    reg [31:0] A, B;
    reg [7:0] exp1, exp2, exp_diff, expo_first_stage_reg;
    reg sign1, sign2, sign_first_stage_reg;
    reg [23:0] mantissa1, mantissa2, mantissa_first_stage_reg;
    reg [23:0] mantissa1_reg, mantissa2_reg;
    
always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        A <= 32'd0;
        B <= 32'd0;
//       mantissa_first_stage <= 25'b0;
//        sign_first_stage <= 1'b0;
//        expo_first_stage <= 8'b0;
    end
    else begin
        A <= reg_A;
        B <= reg_B;
        //mantissa_first_stage <= mantissa_first_stage_reg;
        //expo_first_stage <= expo_first_stage_reg;
        //sign_first_stage <= sign_first_stage_reg;
    end
end

always@ (*) begin
   //Assign values to exponents, signs and mantissas
   exp1 = A[30:23];
   exp2 = B[30:23];

   sign1 = A[31];
   sign2 = B[31];
   
   /*normalized mantissas, with 1 up in front*/
   mantissa1 = {1'b1, A[22:0]};
   mantissa2 = {1'b1, B[22:0]};

   // checking exponents
   if (exp1 == exp2) begin
      expo_first_stage = exp1;
      exp_diff = 8'd0;
      mantissa1_reg = mantissa1 >> 0;
      mantissa2_reg = mantissa2 >> 0;
   end
   else if (exp1 > exp2) begin
      expo_first_stage = exp1;
      exp_diff = exp1 - exp2;
      mantissa1_reg = mantissa1 >> 0;
      mantissa2_reg = mantissa2 >> exp_diff;
   end
   else begin
      expo_first_stage = exp2;
      exp_diff = exp2 - exp1;
      mantissa1_reg = mantissa1 >> exp_diff;
      mantissa2_reg = mantissa2 >> 0;
   end
   
   /*Check the mantissas values*/
   if(mantissa1_reg == mantissa2_reg) begin
       if(sign1 == sign2) begin
           mantissa_first_stage = mantissa1_reg + mantissa2_reg;
           sign_first_stage = sign1;
       end
       else begin
           mantissa_first_stage = 24'b0;
           sign_first_stage = 0;
           
       end
   end
   else if(mantissa1_reg > mantissa2_reg) begin
       if(sign1 == sign2) begin
           mantissa_first_stage = mantissa1_reg + mantissa2_reg;
           sign_first_stage = sign1;
       end
       else begin
           mantissa_first_stage = mantissa1_reg - mantissa2_reg;
           sign_first_stage = sign1;
       end
   end
   else begin
       if(sign1 == sign2) begin
           mantissa_first_stage = mantissa1_reg + mantissa2_reg;
           sign_first_stage = sign2;
       end
       else begin
           mantissa_first_stage = mantissa2_reg - mantissa1_reg;
           sign_first_stage = sign2;
       end
   end
   
end

endmodule