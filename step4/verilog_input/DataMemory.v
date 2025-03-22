module DataMemory( 
                  input clk, 
                  input reset, 
                  input button_signal, 
                  output reg [31:0] outA,/*Represends the input value of the first element to be added*/
                  output reg [31:0] outB); /*Represends the input value of the second element to be added*/

reg [63:0] memory [0:9];
reg [3:0] ptr; //pointer to change the inputs for the fp adder
reg button_check;

/*Initialize the memory block with the values of the .hex file*/
always @(posedge clk or posedge reset) begin
    if(reset) begin
        memory[0] <= {32'h3f800000, 32'h40000000};
        memory[1] <= {32'hbf800000, 32'h3f800000};
        memory[2] <= {32'hc2de8000, 32'h45155e00};
        memory[3] <= {32'h6b64b235, 32'h6ac49214};
        memory[4] <= {32'h2ac49214, 32'h6ac49214};
        memory[5] <= {32'hbfc66666, 32'h3fc7ae14};
        memory[6] <= {32'hc565ee8b, 32'h4565ee8a};
        memory[7] <= {32'h447a4efa, 32'hc47a1ccd};
        memory[8] <= {32'h00000000, 32'h00000000};
        memory[9] <= {32'h38108900, 32'hbb908900};
    end
    else begin
        memory[0] <= {32'h3f800000, 32'h40000000};
        memory[1] <= {32'hbf800000, 32'h3f800000};
        memory[2] <= {32'hc2de8000, 32'h45155e00};
        memory[3] <= {32'h6b64b235, 32'h6ac49214};
        memory[4] <= {32'h2ac49214, 32'h6ac49214};
        memory[5] <= {32'hbfc66666, 32'h3fc7ae14};
        memory[6] <= {32'hc565ee8b, 32'h4565ee8a};
        memory[7] <= {32'h447a4efa, 32'hc47a1ccd};
        memory[8] <= {32'h00000000, 32'h00000000};
        memory[9] <= {32'h38108900, 32'hbb908900};
    end
end

/*Change the ptr depending on the button value*/
always @(posedge clk or posedge reset) begin
	if(reset) begin
		ptr <= 0;
	end
	else begin
		if(button_signal == 1'b1) begin 
			if(ptr == 4'd9) begin /*if the pointer reaches 9, which is the final value reset it back to zero.*/
				ptr <= 0;
			end
			else 
				ptr <= ptr + 4'd1;
		end
		else begin
			ptr <= ptr + 4'd0;
		end
		/*Assign the output values, depending on the pointer we are now*/
		outA <= memory[ptr][63:32];
		outB <= memory[ptr][31:0];
    end
end

endmodule
