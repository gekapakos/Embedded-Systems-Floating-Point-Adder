`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTH
//
// Design Name:
// Module Name:   fpadd_single
// Project Name: 32 bit Floating Point Unit - Add
// Target Devices: Zedboard
// Tool versions: Vivado 2020.2
//
// Description: 32-bit FP adder with a single pipeline stage (everything happens in one cycle)
//  The module does not check the input for subnormal and NaN numbers,
//  and assumes that the two inputs are normal FP32 numbers with 0<exp<255.
//  We also assume that the output does not overflow or undeflow, so there is no need to check for these conditions.
//  An FP32 number has 1 sign bit, 8 exponent bits(biased by 127), and 23 mantissa bits.
//////////////////////////////////////////////////////////////////////////////////
module fpadd_single (input clk,
                     input reset,
                     input [31:0]reg_A,
                     input [31:0]reg_B,
                     output reg[31:0] out);

reg [31:0] A, B, result;
reg [7:0] exp1, exp2, exp_diff;
reg sign1, sign2, cout;
reg [23:0] mantissa1, mantissa2;
reg [23:0] mantissa1_reg, mantissa2_reg;
reg [23:0] normalized_mantissa;
reg [24:0] mantissa_res;
reg [7:0] final_expo;

// Register the two inputs, and use A and B in the combinational logic.
always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1)
        out <= 32'b0;
    else begin
        A <= reg_A;
        B <= reg_B;
        out <= result;
    end
end

//Combinational Logic to (a) compare and adjust the exponents,
//                       (b) shift appropriately the mantissa if necessary,
//                       (c) add the two mantissas, and
//                       (d) perform post-normalization.
//                           Make sure to check explicitly for zero output.
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
   /*If exponents have the same value, don't shift the mantissas*/
   if (exp1 == exp2) begin
      final_expo = exp1; /*final exponent is exp1 or exp2*/
      exp_diff = 8'd0;
      mantissa1_reg = mantissa1 >> 0;
      mantissa2_reg = mantissa2 >> 0;
   end
   /*If the 1st exponent is bigger, then shift the the 2nd mantissa by the difference between the 2 exponents*/
   else if (exp1 > exp2) begin
      final_expo = exp1; /*final exponent is equal to exp1, because it is bigger*/
      exp_diff = exp1 - exp2;
      mantissa1_reg = mantissa1 >> 0;
      mantissa2_reg = mantissa2 >> exp_diff;
   end
   /*If the 2nd exponent is bigger, then shift the the 1st mantissa by the difference between the 2 exponents*/
   else begin
      final_expo = exp2; /*final exponent is equal to exp2, because it is bigger*/
      exp_diff = exp2 - exp1;
      mantissa1_reg = mantissa1 >> exp_diff;
      mantissa2_reg = mantissa2 >> 0;
   end
   
   /*Check the mantissas values
   We check the mantissas so that we can substract correctly*/
   
   /*If the mantissas are the same and the signs are the same, add them, else if the signs are unequal set the value to zero*/
   if(mantissa1_reg == mantissa2_reg) begin
       if(sign1 == sign2) begin
           mantissa_res = mantissa1_reg + mantissa2_reg;
           result[31] = sign1;
       end
       else begin
           mantissa_res = 24'b0;
           result[31] = 0;
           
       end
   end
   /*If mantissa 1 is bigger then substract mantiisa 2 from mantissa 1*/
   else if(mantissa1_reg > mantissa2_reg) begin
       if(sign1 == sign2) begin
           mantissa_res = mantissa1_reg + mantissa2_reg;
           result[31] = sign1;
       end
       else begin
           mantissa_res = mantissa1_reg - mantissa2_reg;
           result[31] = sign1;
       end
   end
   /*If mantissa 2 is bigger then substract mantiisa 1 from mantissa 2*/
   else begin
       if(sign1 == sign2) begin
           mantissa_res = mantissa1_reg + mantissa2_reg;
           result[31] = sign2;
       end
       else begin
           mantissa_res = mantissa2_reg - mantissa1_reg;
           result[31] = sign2;
       end
   end
   
   /*Repeat the post normalization process
   If there is a carry out in the process shift right and adjust exponent*/
   if ((mantissa_res[24] == 1) && (mantissa_res[23] == 0)) begin
        normalized_mantissa = mantissa_res[24:1];
        if (normalized_mantissa[22:0] == 23'd0) begin
            final_expo = 8'd0;
        end
        else begin
            final_expo = final_expo + 8'd1;
        end
   end
   /*Shift left, if the mantissa is not yet normalized*/
   else begin
       normalized_mantissa = mantissa_res;
       repeat(24) begin
           if(normalized_mantissa[23] == 1'b1) begin
               normalized_mantissa = normalized_mantissa << 0;
               final_expo = final_expo - 8'd0;
           end
           else begin
                normalized_mantissa = normalized_mantissa << 1;
                final_expo = final_expo - 8'd1;
           end
       end
   end    
   
   /*Special Case: Addition of zeros*/
   if (mantissa_res == 24'd0) begin
        result[30:23] = 8'd0;
   end
   else begin
        result[30:23] = final_expo;
   end
   
   result[22:0] = normalized_mantissa[22:0];
   
end

endmodule
