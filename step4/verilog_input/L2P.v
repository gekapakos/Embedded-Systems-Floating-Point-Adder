
module L2P(
           input debounced_level,
           input clk,
           input reset,
           output out_pulse);

reg [1:0] curr_state, next_state;
reg out_pulse_reg;

parameter low_state = 2'b00,
          edge_state = 2'b01,
          high_state = 2'b11;

/*Create an FSM, 3-stage Moore, with 2 always blocks */

/*Sequential Block*/
always @(posedge clk or posedge reset) begin
    if(reset) begin
        curr_state <= 2'b00;
    end
    else
        curr_state <= next_state;
end

/*Combinational Block*/
always @(*) begin
    next_state = curr_state;
    case(curr_state)
        low_state: begin
            out_pulse_reg = 0;
            if(debounced_level == 1'd1) begin
                next_state = edge_state;
            end
            else
                next_state = low_state;
        end
        edge_state: begin
            out_pulse_reg = 1;
            if(debounced_level == 1'd1) begin
                next_state = high_state;
            end
            else
                next_state = low_state;
        end
        high_state: begin
            out_pulse_reg = 0;
            if(debounced_level == 1'd1) begin
                next_state = high_state;
            end
            else
                next_state = low_state;
        end
        default: begin
            out_pulse_reg = 0;
            next_state = low_state;
        end
    endcase
end

assign out_pulse = out_pulse_reg;

endmodule