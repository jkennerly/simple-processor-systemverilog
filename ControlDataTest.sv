module ControlDataTest(
	input Clock,			// System clock
	input Reset,			// State machine reset
	output [15:0]ALU_inA,	// ALU input A
	output [15:0]ALU_inB,	// ALU input B
	output [15:0]ALU_out,	// ALU output
	output [3:0]State,		// Current state output
	output [3:0]NextState);	// Next state output
	
	logic [7:0]D_Addr;		// Data memory address
	logic D_Wr;				// Data memory write enable
	logic RF_s;				// Mux select line
	logic [3:0]RF_Ra_Addr;	// Register file A-side read address
	logic [3:0]RF_Rb_Addr;	// Register file B-side read address
	logic RF_W_en;			// Register file write enable
	logic [3:0]RF_W_Addr;	// Register file write address
	logic [2:0]ALU_s0;		// ALU function select
	
	ControlUnit CtrlUnit(Clock, Reset, D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, State, NextState);
	Datapath DatapathUnit(Clock, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, ALU_inA, ALU_inB, ALU_out);
	
endmodule

`timescale 1 ps/1 ps
module ControlDataTest_tb;
	logic Clock;			// System clock
	logic Reset;			// State machine reset
	logic [15:0]ALU_inA;	// ALU input A
	logic [15:0]ALU_inB;	// ALU input B
	logic [15:0]ALU_out;	// ALU output
	logic [3:0]State;		// Current state output
	logic [3:0]NextState;	// Next state output
	
	ControlDataTest DUT(Clock, Reset, ALU_inA, ALU_inB, ALU_out, State, NextState);
	
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
