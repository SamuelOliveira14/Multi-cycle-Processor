module RegistradorW(clock,out,data);
	input clock;
	input data;
	output reg out;
	
	initial begin
		out = 0;
	end
	
	always@(posedge clock) begin 
			out = data;
	end
endmodule