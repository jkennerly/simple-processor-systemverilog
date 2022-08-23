module Processor(
//Clock, Reset, IR_Out, PC_Out, State, NextState, ALU_inA, ALU_inB, ALU_out
	input Clock,			// System clock
	input Reset,			// State machine reset
	output [15:0]IR_Out,	// Instruction out of register
	output [6:0]PC_Out,	// Address of instruction from memory
	output [3:0]State,		// Current state output
	output [3:0]NextState,	// Next state output
	output [15:0]ALU_A,		// ALU input A
	output [15:0]ALU_B,		// ALU input B
	output [15:0]ALU_Out);	// ALU output

	
	
	logic [7:0]D_Addr;		// Data memory address
	logic D_Wr;				// Data memory write enable
	logic RF_s;				// Mux select line
	logic [3:0]RF_Ra_Addr;	// Register file A-side read address
	logic [3:0]RF_Rb_Addr;	// Register file B-side read address
	logic RF_W_en;			// Register file write enable
	logic [3:0]RF_W_Addr;	// Register file write address
	logic [2:0]ALU_s0;		// ALU function select
	
	ControlUnit CtrlUnit(Clock, ~Reset, D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, State, NextState, IR_Out, PC_Out);
	Datapath DatapathUnit(Clock, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, ALU_A, ALU_B, ALU_Out);
	
endmodule

`timescale 1 ps/1 ps
module Processor_tb;
	logic Clock;			// System clock
	logic Reset;			// State machine reset
	logic [15:0]ALU_inA;	// ALU input A
	logic [15:0]ALU_inB;	// ALU input B
	logic [15:0]ALU_out;	// ALU output
	logic [3:0]State;		// Current state output
	logic [3:0]NextState;	// Next state output
	logic [15:0]IR_Out;		// Instruction out of register
	logic [6:0]PC_Out;		// Address of instruction from memory
	
	Processor DUT(Clock, Reset, IR_Out, PC_Out, State, NextState, ALU_inA, ALU_inB, ALU_out);
	
	always begin
		Clock = 0; #10;
		Clock = 1; #10;
	end
	
	initial begin
		Reset = 0; #1000;
		Reset = 1; #20;
		Reset = 0; #800;
		$stop;
	end
	
endmodule
