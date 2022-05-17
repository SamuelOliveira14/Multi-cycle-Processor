/*Processador Multiciclos implementado para a disciplina de Laboratório de Arquitetura e Organização de computadores II.
Alunos: Renan Unsonst Cruz e Samuel Augusto Oliveira Magalhães
TODO: 
	Verificar possivel problema de sincronismo no controle: always@(STEP) pode dar problema no primeiro passo (T0).
	Adicionar reset nos componentes
*/
module Processador(clock,DIN,run,reset,out_ADDR,out_DOUT,out_W,Done);
	input clock,run,reset;
	input [15:0] DIN;
	output [15:0] out_ADDR,out_DOUT;
	output out_W,Done;
	
	wire IR_in,G_in,A_in,ADDR_in,DOUT_in,incr_PC,PC_in,W_D,G_or;
	wire [15:0] out_G,out_ULA,out_A,out_mux,out_PC,out_RegFile;
	wire [9:0] out_IR;
	wire [1:0] mux_control;
	wire [3:0] ULA_control;
	wire [6:0] register_in;
	wire [2:0] register_out;
	
	
	//Multiplexador(mux_control,DIN_out,register_out,PC_out,G_out,out);
	Multiplexador MUX(mux_control,DIN,out_RegFile,out_PC,out_G,out_mux); //Incompleto 
	
	//Registrador(clock,Rin,out,data);
	RegistradorIR IR(clock,IR_in,out_IR,DIN[15:6]);
	Registrador G(clock,G_in,out_G,out_ULA);
	Registrador A(clock,A_in,out_A,out_mux);
	Registrador ADDR(clock,ADDR_in,out_ADDR,out_mux);
	Registrador DOUT(clock,DOUT_in,out_DOUT,out_mux);
	
	//RegistradorW(clock,out,data);
	RegistradorW W(clock,out_W,W_D);
	
	//PC(clock,incr_PC,Rin,out,data)
	PC PC(clock,incr_PC,PC_in,out_PC,out_mux);
	
	//BancoDeRegistradores(clock,data_bus,registers_in,register_out,out);
	BancoDeRegistradores RegFile(clock,out_mux,register_in,register_out,out_RegFile);
	
	//ULA(Ra, Ry, operacao, out);
	ULA ULA(out_A,Ry,ULA_control,out_ULA);
	
	//Controle(clock,run,reset,IR,G_or,IR_in, ADDR_in, DOUT_in, W_D, G_in, A_in, incr_PC, PC_in, mux_control, ULA_control,register_in,register_out);
	assign G_or = |out_G;
	Controle Controle(clock,run,reset,out_IR,G_or, IR_in, ADDR_in, DOUT_in, W_D, G_in, A_in, incr_PC, PC_in, mux_control, ULA_control,register_in,register_out);
endmodule