module Controle(clock,run,reset,IR,mux_control,IR_in, ADDR_in, DOUT_in, W_D, G_in, A_in, incr_PC, PC_in, mux_control, ULA_control,register_in,register_out,G_or);

	input clock,run,reset,G_or;
	input [9:0] IR; //[(opcode - 4bits) - (Rx - 3 bits) - (Ry - 3 bits)] = 10 bits
	
	output reg IR_in, ADDR_in, DOUT_in, W_D, G_in, A_in, incr_PC, PC_in; // Habilita a escrita nos demais registradores.
	
	output reg[1:0] mux_control;	//Informa qual dado irá sair no multiplexador
	output reg[3:0] ULA_control; 	//Informa a operação a ser realizada pela ULA
	output reg[6:0] register_in;	//Informa quais registradores serão escritos
	output reg[2:0] register_out; //Informa qual registrador será lido
	reg [2:0] step; //Passo atual da instrução
	reg done;
	
	wire [2:0] Rx;
	wire [2:0] Ry;
	wire [3:0] opcode;
	
	assign opcode = IR [9:6];
	assign Rx = IR[5:3];
	assign Ry = IR [2:0];
	
	//Opcodes
	localparam LD = 4'b0000,ST = 4'b0001,MVNZ = 4'b0010,MV = 4'b0011,MVI = 4'b0100,ADD = 4'b0101,SUB = 4'b0110,OR = 4'b0111,SLT = 4'b1000,SLL = 4'b1001,SRL = 4'b1010;

	initial begin
		step = 0;
	end
	
	always@(posedge clock or posedge reset) begin
		if(reset) begin 
			step = 0;
		end
		if(run) begin 
			step = step + 1;
		end
		if(done) begin 
			step = 0;
		end
	end
	
	/*
	Multiplexadores
	2'b00: out = DIN_out;
	2'b01: out = register_out;
	2'b10: out = PC_out;
	2'b11: out = G_out;
	*/
	
	always @(step) begin
		//Inicializa as variáveis
		IR_in = 0; ADDR_in = 0; DOUT_in = 0; W_D = 0; G_in = 0; A_in = 0; incr_PC = 0; PC_in = 0;
		mux_control = 2'b0;
		ULA_control = 3'b0;
		register_in = 7'b0;
		register_out = 3'b0;
		
		case(step) 
			3'b000: begin //T0: Leitura do registrador IR
				IR_in = 1; //Recebe a instrucao
				incr_PC = 1; //Incrementa PC
			end
			3'b001: begin //T1: 
				case(opcode)//opcode
					ADD,SUB,OR,SLT,SLL,SRL: begin
						mux_control = 2'b01; // Rx_out;
						register_out = Rx;	//Rx_out;
						A_in = 1;
					end
					LD,ST: begin 
						mux_control = 2'b01; //Ry_out;
						register_out = Ry;	//Ry_out;
						ADDR_in = 1; //Habilita a escrita no registrador que armazena o endereço de memória.
					end
					MV: begin
						register_in[Rx] = 1; //Rx_in
						mux_control = 2'b01;	//Ry_out
						register_out = Ry;	//Ry_out
						done = 1;				//Termina a instrucao
					end
					MVNZ: begin
						if(G_or == 1) begin
							register_in[Rx] = 1; //Rx_in
							register_out = Ry; 	//Ry_out
							mux_control = 2'b01;	//Ry_out
						end
						done = 1; //Fim de instrucao
					end
					MVI: begin
						mux_control = 2'b10; //PC_out
						ADDR_in = 1; 	//ADDR_in
					end
				endcase
			end
			3'b010: begin //T2: 
				case(opcode)
					ADD,SUB,OR,SLT,SLL,SRL: begin
						mux_control = 2'b01; //Ry_out
						register_out = Ry;	//Ry_out
						ULA_control = opcode; //Informa a operação a ser realizada pela ULA
						G_in = 1;				//G_in
					end
					LD: begin
						mux_control = 2'b00; //DIN_out
						register_in[Rx] = 1;	//Rx_in
						done = 1;				//Fim de instrucao
					end
					ST: begin
						register_out = Rx; 	//Rx_out
						mux_control = 2'b01; //Rx_out
						W_D = 1;					//Habilita a escrita na memória
						DOUT_in = 1;			//DOUT_in
						done = 1;				//Fim de instrucao
					end
					MVI: begin
						mux_control = 2'b00; //DIN_out
						register_in[Rx] = 1;	//Rx_in
						incr_PC = 1;			//Incr_PC para ir pra proxima instrucao
						done = 1;				//Fim de instrucao
					end
				endcase	
			end		
			3'b011: begin //T3:
				case(opcode)
					ADD,SUB,OR,SLT,SLL,SRL: begin
						register_in[Rx] = 1; //Rx_in
						mux_control = 2'b11;	//G_out
						done = 1;				//Fim de instrucao
					end
				endcase
			end
		endcase //End case(step)
			
	end//End always
	
	
endmodule