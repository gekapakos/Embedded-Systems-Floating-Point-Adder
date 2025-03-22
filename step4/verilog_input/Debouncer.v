module debouncer(
    input button,
    input clk,
    output debounced
    );
 
/*********** Internal Variables **********/
 
wire Q1, Q2, enable, Q3, Cout;
parameter N = 24; // Counts from 0 to 2^[N-1], 
reg [N-1:0] count;
reg Cout_reg;
/************** Main Code ******************/
 
/*Synchronizer*/
 
DFF D1(clk, reset, button, Q1);
DFF D2(clk, reset, Q1, Q2);
 
xor g1(enable,Q1,Q2); 
  
/*27 bit counter implementation*/
always@ (posedge clk) begin
    if(enable == 1'd1) begin
        count <= 24'd0;
        Cout_reg <= 0;
    end
    else if(count == 24'd10_000_000) begin
        Cout_reg <= button;
        count <= 24'd0;
    end
    else
        count <= count + 24'd1;
end

assign Cout = Cout_reg;
 
DFF D3(clk, reset, Cout, Q3);
 
assign debounced = Q3;
 
endmodule