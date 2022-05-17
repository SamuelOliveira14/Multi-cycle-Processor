module BancoDeRegistradores(clock,data_bus,registers_in,register_out,out);
	input clock;
	input [15:0] data_bus;    //Dado de escrita
	input [2:0] register_out; //Informa qual registrador terá sua saída lida
	input [6:0] registers_in; //Informa quais registradores serão escritos com data_bus
	output [15:0] out;
	wire [15:0] register_file_output [6:0]; //Wire auxiliar que contém as saidas de cada registrador.
	
	//Registrador(clock,Rin,out,data);
	Registrador r0(clock,registers_in[0],register_file_output[0],data_bus);
	Registrador r1(clock,registers_in[1],register_file_output[1],data_bus);
	Registrador r2(clock,registers_in[2],register_file_output[2],data_bus);
	Registrador r3(clock,registers_in[3],register_file_output[3],data_bus);
	Registrador r4(clock,registers_in[4],register_file_output[4],data_bus);
	Registrador r5(clock,registers_in[5],register_file_output[5],data_bus);
	Registrador r6(clock,registers_in[6],register_file_output[6],data_bus);
	
	assign out = register_file_output[register_out];
	
endmodule