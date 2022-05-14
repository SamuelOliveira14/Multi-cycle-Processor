module Registrador(clock,Rin,out,data);
	input clock, Rin;
	input [15:0] data;
	output reg [15:0] out;
	
	initial begin
		out = 16'b0;
	end
	
	always@(posedge clock) begin 
		if(Rin) begin
			out = data;
		end
	end
endmodule