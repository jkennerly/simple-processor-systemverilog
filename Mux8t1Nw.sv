// TCES 330, Spring 2022
// Jane Kennerly
// 4/21/2022
// This module is a 8-to-1 MUX
// S# are the selecting signals

// S2, S1, S0
// A = 000 	B = 001		C = 010		D = 011
// E = 100	F = 101		G = 110		H = 111

module Mux8to1Nw (a, b, c, d, e, f, g, h, s, m); 
	parameter n = 16;
	input logic [2:0] s; 	// mux select lines
	input logic [n-1:0] a, b, c, d, e, f, g, h;	// mux inputs
	output logic [n-1:0] m;		// mux output
	
always @(*) //if S2,S1,S0 is..., m is one of the inputs a, b,...
case (s) // control signals 
0: m = a; 1: m = b; 2: m = c; 3: m = d;
4: m = e; 5: m = f; 6: m = g; 7: m = h;
endcase

endmodule


// Testbench
module Mux8to1Nw_tb();

	logic [2:0] S;				// mux select lines
	logic A, B, C, D, E, F, G, H;	// mux inputs 
	logic M;						// mux output

// instance the mux under testing: 
	Mux8to1Nw test (A, B, C, D, E, F, G, H, S2, S1, S0, M);
 
 initial begin
// S2, S1, S0
// A = 000 	B = 001		C = 010		D = 011
// E = 100	F = 101		G = 110		H = 111
$monitor("%d \t %b %b \t %b %b \t %b %b \t %b %b \t %b %b %b \t %b",  $time, A, B, C, D, E, F, G, H, S2, S1, S0, M);
	A = 0; B = 0; C = 0; D = 0; E = 1; F = 1; G = 1; H = 1; S = 0; #10; // A
	A = 1; B = 1; C = 1; D = 1; E = 0; F = 0; G = 0; H = 0; S = 0; #10; // A
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S = 1; #10; // B
	A = 0; B = 1; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S = 1; #10; // B

	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S = 0; #10; // C
	A = 0; B = 0; C = 1; D = 0; E = 0; F = 0; G = 0; H = 0; S = 0; #10; // C
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S2 = 0; S1 = 1; S0 = 1; #10; // D
	A = 0; B = 0; C = 0; D = 1; E = 0; F = 0; G = 0; H = 0; S2 = 0; S1 = 1; S0 = 1; #10; // D

	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S2 = 1; S1 = 0; S0 = 0; #10; // E
	A = 0; B = 0; C = 0; D = 0; E = 1; F = 0; G = 0; H = 0; S2 = 1; S1 = 0; S0 = 0; #10; // E
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S2 = 1; S1 = 0; S0 = 1; #10; // F
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 1; G = 0; H = 0; S2 = 1; S1 = 0; S0 = 1; #10; // F

	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S2 = 1; S1 = 1; S0 = 0; #10; // G
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 1; H = 0; S2 = 1; S1 = 1; S0 = 0; #10; // G
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; S2 = 1; S1 = 1; S0 = 1; #10; // H
	A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 1; S2 = 1; S1 = 1; S0 = 1; #10; // H 

	for (int i = 0; i < 32; i++) begin
	{A, B, C, D, E, F, G, H, S2, S1, S0} = $random;	
	#10;
	end;

end
endmodule
