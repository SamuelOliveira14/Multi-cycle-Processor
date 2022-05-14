module Multiplexador(mux_control,DIN_out,register_out,PC_out,G_out,out);
	input [1:0] mux_control;
	input [15:0] DIN_out,register_out,PC_out,G_out;
	output reg[15:0] out;
	
	always@(mux_control) begin 
		case(mux_control)
			2'b00: out = DIN_out;
			2'b01: out = register_out;
			2'b10: out = PC_out;
			2'b11: out = G_out;
		endcase
	end
	
endmodule