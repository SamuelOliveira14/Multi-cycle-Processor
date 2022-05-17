module PC(clock,incr_PC,Rin,out,data);
	input clock, Rin, incr_PC;
	input [15:0] data;
	output reg [15:0] out;
	reg [15:0] Q;
	
	
	initial begin
		Q = 16'b0; //Inicializa na primeira instrucao
	end
	
	always@(posedge clock) begin 
		if(Rin) begin
			Q = data;
		end
		if(incr_PC) begin
			Q = Q + 16'b1;
		end
		out = Q;
	end
endmodule