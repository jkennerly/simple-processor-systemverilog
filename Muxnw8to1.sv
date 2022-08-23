module Muxnw8to1(S, A, B, C, D, E, F, G, H, M);
	parameter n = 16;
	input [2:0]S; 
	input [n-1:0]A, B, C, D, E, F, G, H;
	output logic [n-1:0]M;
	
	//Mux8to1 unit2(S, A[2], B[2], C[2], D[2], E[2], F[2], G[2], H[2], M[2]);
	//Mux8to1 unit1(S, A[1], B[1], C[1], D[1], E[1], F[1], G[1], H[1], M[1]);
	//Mux8to1 unit0(S, A[0], B[0], C[0], D[0], E[0], F[0], G[0], H[0], M[0]);
	
	always @* begin
		case (S)
			0:M=A;
			1:M=B;
			2:M=C;
			3:M=D;
			4:M=E;
			5:M=F;
			6:M=G;
			7:M=H;
		endcase
	end
	
endmodule

module Muxnw8to1_tb;
	logic [15:0]A, B, C, D, E, F, G, H, M;
	logic [2:0] S;

	Muxnw8to1 m0(S, A, B, C, D, E, F, G, H, M);
	
	initial begin
		S=0;A=7;B=0;C=0;D=0;E=0;F=0;G=0;H=0;#10;
		S=1;A=0;B=7;C=0;D=0;E=0;F=0;G=0;H=0;#10;
		S=2;A=0;B=0;C=7;D=0;E=0;F=0;G=0;H=0;#10;
		S=3;A=0;B=0;C=0;D=7;E=0;F=0;G=0;H=0;#10;
		S=4;A=0;B=0;C=0;D=0;E=7;F=0;G=0;H=0;#10;
		S=5;A=0;B=0;C=0;D=0;E=0;F=7;G=0;H=0;#10;
		S=6;A=0;B=0;C=0;D=0;E=0;F=0;G=7;H=0;#10;
		S=7;A=0;B=0;C=0;D=0;E=0;F=0;G=0;H=7;#10;
	end
endmodule
