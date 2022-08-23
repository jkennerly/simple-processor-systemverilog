s// TCES 330, Spring 2022
// Jane Kennerly
// 4/18/2022
// HW3 Q1 Decoder for Hexidecimal 7-segment display
// This will generate signals for 0 - F

module Decoder(B, Hex);
	input [3:0] B; 		// input lines, 4 binary number
	output logic [0:6] Hex; 	// seven segments, 7 bits

always @(B) //if B is..., Hex is 7'b...
case (B) //abcdefg
0: Hex = 7'b0000001; 
1: Hex = 7'b1001111; 
2: Hex = 7'b0010010; 
3: Hex = 7'b0000110; 

4: Hex = 7'b1001100; 
5: Hex = 7'b0100100; 
6: Hex = 7'b0100000; 
7: Hex = 7'b0001111; 

8: Hex = 7'b0000000; 
9: Hex = 7'b0000100; 
10: Hex = 7'b0001000; 
11: Hex = 7'b1100000; 

12: Hex = 7'b0110001; 
13: Hex = 7'b1000010; 
14: Hex = 7'b0110000; 
15: Hex = 7'b0111000; 

endcase

endmodule



