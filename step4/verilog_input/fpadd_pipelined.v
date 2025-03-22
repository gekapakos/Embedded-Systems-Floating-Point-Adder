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
module fpadd_pipeline (input clk,
                     input reset,
                     input [31:0]reg_A,
                     input [31:0]reg_B,
                     output [31:0] out);

reg [31:0] result;
reg [23:0] normalized_mantissa;
reg [24:0] pipeline_mantissa;
reg [7:0] pipeline_expo;
reg pipeline_sign;
wire [24:0] mantissa_first_stage, mantissa_second_stage;
wire [7:0] expo_first_stage, expo_second_stage;
wire sign_first_stage, sign_second_stage;

// Register the two inputs, and use A and B in the combinational logic.
always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        pipeline_mantissa <= 25'd0;
        pipeline_expo <= 8'd0;
        pipeline_sign <= 0;
    end
    else begin
        pipeline_mantissa <= mantissa_first_stage;
        pipeline_expo <= expo_first_stage;
        pipeline_sign <= sign_first_stage;
//        $display("%h %h %h\n", pipeline_mantissa, pipeline_expo, pipeline_sign);
    end
end

assign expo_second_stage = pipeline_expo;
assign sign_second_stage = pipeline_sign;
assign mantissa_second_stage = pipeline_mantissa;


first_stage stage1(clk, reset, reg_A, reg_B, mantissa_first_stage, expo_first_stage, sign_first_stage);
second_stage stage2(clk, reset, expo_second_stage, sign_second_stage, mantissa_second_stage, out);

endmodule