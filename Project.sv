// Spring 2022 - TCES 330
// Module Writer: Jane Kennerly
// Module Reviewer: Richard Chou
// Course Project Project.sv to be tested with DE2 board

module Project (	CLOCK_50, SW, KEY,
						LEDR, LEDG, 
						HEX7, HEX6, HEX5, HEX4,HEX3, HEX2, HEX1, HEX0);

	input CLOCK_50;		// system clock
	input [17:0] SW; 		// vector of slide switches
	input [3:0] KEY; 		// vector of pushbutton KEYs
	output [17:0] LEDR; 	// vector of red LEDs
	output [3:0] LEDG; 	// vector of green LEDs
	output logic[0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 ; 
	
	//Intermediate signals
	wire Bo; 				// Button Sync output - KeyFilter Input
	wire Out; 				// Filtered output pulse from KeyFilter
	reg [15:0]ALU_A;		// ALU input A
	reg [15:0]ALU_B;		// ALU input B
	reg [15:0]ALU_Out;	// ALU output
	reg [3:0]State;		// Current state output
	reg [3:0]NextState;	// Next state output
	reg [15:0]IR_Out;		// Instruction out of register
	reg [6:0]PC_Out;		// Address of instruction from memory
	reg [15:0] zero = 0;// register of filler 0s
	reg [15:0] M;			// 8 to 1 mux output
	
	// hardware signal assignments
	assign LEDR = SW; 	// switches are now wired to red LEDs
	assign LEDG = ~KEY;	// indicates when a KEY is pressed
	
	//ButtonSyncReg( Clk, Bis, Bo );
	ButtonSyncReg BSync(CLOCK_50, ~KEY[2], Bo);
	
	//KeyFilter(Clock, In, Out, Strobe);
	KeyFilter KeyF(CLOCK_50, 
						Bo, 
						Out); 
						//Strobe); //unused
						
	/*module Processor(
	input Clock,			// System clock
	input Reset,			// State machine reset
	output [15:0]ALU_A,		// ALU input A
	output [15:0]ALU_B,		// ALU input B
	output [15:0]ALU_Out,	// ALU output
	output [3:0]State,		// Current state output
	output [3:0]NextState,	// Next state output
	output [15:0]IR_Out,	// Instruction out of register
	output [6:0]PC_Out);	// Address of instruction from memory */
	
	Processor proc(
	Out,				// System clock from KeyFilter
	KEY[0],			// State machine reset
	IR_Out,			// Instruction out of register
	PC_Out,			// Address of instruction from memory
	State,			// Current state output
	NextState,		// Next state output
	ALU_A,			// ALU input A
	ALU_B,			// ALU input B
	ALU_Out);			// ALU output
	
	/*Muxnw8to1(S, A, B, C, D, E, F, G, H, M);
	parameter n = 16;
	input [2:0]S; 
	input [n-1:0]A, B, C, D, E, F, G, H;
	output logic [n-1:0]M; */
	
	
	Muxnw8to1 mx8 (SW[17:15], 						// select bits
						{zero[0:0], PC_Out, zero[3:0], State},	// {PC Out, State Out}
						ALU_A, 							// A operand of ALU
						ALU_B, 							// B operand of ALU
						ALU_Out, 						// ALU output
						{zero[11:0],NextState}, 	// NextState
						zero, //unused
						zero, //unused
						zero, //unused
						M);
	
	/*module Decoder(B, Hex);
	input [3:0] B; 		// input lines, 4 binary number
	output logic [0:6] Hex; 	// seven segments, 7 bits */
	Decoder H7 (M[15:12], HEX7);
	Decoder H6 (M[11:8], HEX6);
	Decoder H5 (M[7:4], HEX5);
	Decoder H4 (M[3:0], HEX4);
	Decoder H3 (IR_Out[15:12], HEX3);
	Decoder H2 (IR_Out[11:8], HEX2);
	Decoder H1 (IR_Out[7:4], HEX1);
	Decoder H0 (IR_Out[3:0], HEX0);
	
endmodule
