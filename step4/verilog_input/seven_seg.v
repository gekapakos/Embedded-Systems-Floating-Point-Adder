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

module counter(
    input clk,
    input rst,
    output [4:0] counter_out
);

reg [4:0] count;

always @ (posedge clk or posedge rst) begin
    if (rst == 1) begin
        count <= 5'd0;
    end
    else begin
        count <= count + 5'd1;
    end
end

assign counter_out = count;

endmodule
 

module seven_seg(
    input clk, 
    input rst, 
    input [7:0] in,
    output [7:0] seg_out
);

wire [4:0] count;
reg anode;
reg [6:0] led;

always @ (posedge clk or posedge rst) begin
    if (rst == 1) begin
        anode <= 1;
    end
    else begin
        if (count == 5'd31) begin
            anode <= ~anode;
        end
    end
end

counter anode_counter(clk, rst, count);

always @ (*) begin
    if (anode == 1) begin
        if (rst) begin
            led = 7'b0000001;
        end
        else begin
            case (in[7:4])
                4'h0: led = 7'b1111110;
                4'h1: led = 7'b0110000;
                4'h2: led = 7'b1101101;
                4'h3: led = 7'b1111001;
                4'h4: led = 7'b0110011;
                4'h5: led = 7'b1011011;
                4'h6: led = 7'b1011111;
                4'h7: led = 7'b1110000;
                4'h8: led = 7'b1111111;
                4'h9: led = 7'b1111011;
                4'ha: led = 7'b1110111;
                4'hb: led = 7'b0011111;
                4'hc: led = 7'b1001110;
                4'hd: led = 7'b0111101;
                4'he: led = 7'b1001111;
                4'hf: led = 7'b1000111;
                default: led = 7'b0000001;
            endcase
        end
    end
    else begin
        case (in[3:0])
                4'h0: led = 7'b1111110;
                4'h1: led = 7'b0110000;
                4'h2: led = 7'b1101101;
                4'h3: led = 7'b1111001;
                4'h4: led = 7'b0110011;
                4'h5: led = 7'b1011011;
                4'h6: led = 7'b1011111;
                4'h7: led = 7'b1110000;
                4'h8: led = 7'b1111111;
                4'h9: led = 7'b1111011;
                4'ha: led = 7'b1110111;
                4'hb: led = 7'b0011111;
                4'hc: led = 7'b1001110;
                4'hd: led = 7'b0111101;
                4'he: led = 7'b1001111;
                4'hf: led = 7'b1000111;
                default: led = 7'b0000001;
        endcase
    end
end

assign seg_out = {anode, led};

endmodule