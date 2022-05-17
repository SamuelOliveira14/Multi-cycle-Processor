module RegistradorIR(clock,Rin,out,data);
	input clock, Rin;
	input [9:0] data;
	output reg [9:0] out;
	
	initial begin
		out = 10'b0;
	end
	
	always@(posedge clock) begin 
		if(Rin) begin
			out = data;
		end
	end
endmodule