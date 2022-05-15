module ULA(Ra, Ry, operacao, out);
	input [15:0] Ra, Ry;
	input [3:0] operacao;
	output reg [15:0] out;
	
	localparam ADD	= 4'b0101, SUB	= 4'b0110, OR = 4'b0111, SLT = 4'b1000, SRL = 4'b1001, SLL =4'b1010; //Códigos de operacao
	
	always@(Ra or Ry or operacao) begin 
		case(operacao)
			ADD: out = Ra + Ry;
			SUB: out = Ra - Ry;
			OR: out = Ra | Ry;
			SLT: out = Ra < Ry ? 16'b1:16'b0;
			SRL: out = Ra >> Ry;
			SLL: out = Ra << Ry;
			default: out = 16'b0;
		endcase
	end
endmodule