module ControlUnit(
	input Clock,			// System clock
	input Reset,			// State machine reset
	output [7:0]D_Addr,		// Data memory address
	output D_Wr,			// Data memory write enable
	output RF_s,			// Mux select line
	output [3:0]RF_Ra_Addr,	// Register file A-side read address
	output [3:0]RF_Rb_Addr,	// Register file B-side read address
	output RF_W_en,			// Register file write enable
	output [3:0]RF_W_Addr,	// Register file write address
	output [2:0]ALU_s0,		// ALU function select
	output [3:0]State,		// Current state of FSM
	output [3:0]NextState,	// Next state of FSM
	output [15:0]IR_Out,	// Instruction out of register
	output [6:0]PC_Out);	// Address from program counter

	logic [15:0]instIn, instOut;	// Instruction into / out of register
	logic [6:0]instAddr;			// Address of instruction from memory
	logic PC_clr, PC_up, IR_ld;	// PC clear, count up, and IR load signals

	FSM Controller(Clock, Reset, instOut, PC_clr, IR_ld, PC_up, D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, State, NextState);
	InstMemory Instructions(instAddr, Clock, instIn);
	IR Register(Clock, IR_ld, instIn, instOut);
	PC Counter(Clock, PC_clr, PC_up, instAddr);

	assign IR_Out = instOut;
	assign PC_Out = instAddr;
	
endmodule

`ifdef MODEL_TECH
`timescale 1 ps/1 ps
module ControlUnit_tb;
	logic Clock;			// System clock
	logic Reset;			// State machine reset
	logic [7:0]D_Addr;		// Data memory address
	logic D_Wr;				// Data memory write enable
	logic RF_s;				// Mux select line
	logic [3:0]RF_Ra_Addr;	// Register file A-side read address
	logic [3:0]RF_Rb_Addr;	// Register file B-side read address
	logic RF_W_en;			// Register file write enable
	logic [3:0]RF_W_Addr;	// Register file write address
	logic [2:0]ALU_s0;		// ALU function select
	logic [3:0]State;		// Current state of FSM
	logic [3:0]NextState;	// Next state as output
	logic [15:0]IR_Out;		// Instruction out of register
	logic [6:0]PC_Out;		// Address from program counter

	ControlUnit DUT(Clock, Reset, D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, State, NextState, IR_Out, PC_Out);

	always begin
		Clock = 0; #10;
		Clock = 1; #10;
	end

	initial begin
		Reset = 0; #800;
		Reset = 1; #20;
		Reset = 0; #180;
		$stop;
	end

	initial $monitor("D_Addr %h, D_Wr %b, RF_s %b, RF_Ra_Addr %h, RF_Rb_Addr %h, RF_W_en %b, RF_W_Addr %h, ALU_s0 %b",
					D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0);

endmodule
`endif