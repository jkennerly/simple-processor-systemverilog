// Spring 2022 - TCES 330
// Module Writer: Richard Chou
// Module Reviewer: Jane Kennerly

// Course Project - Processor - Controller State Machine

module FSM(
	input Clock,					// System clock
	input Reset,					// State machine reset
	input [15:0]Inst,				// Instruction
	output logic PC_clr,			// Program counter clear command
	output logic IR_ld,				// Instruction load command
	output logic PC_up,				// PC increment command
	output logic [7:0]D_Addr,		// Data memory address
	output logic D_Wr,				// Data memory write enable
	output logic RF_s,				// Mux select line
	output logic [3:0]RF_Ra_Addr,	// Register file A-side read address
	output logic [3:0]RF_Rb_Addr,	// Register file B-side read address
	output logic RF_W_en,			// Register file write enable
	output logic [3:0]RF_W_Addr,	// Register file write address
	output logic [2:0]ALU_s0,		// ALU function select
	output logic [3:0]STATE,		// Current state as output
	output logic [3:0]NEXTSTATE);	// Next state as output
	
	logic [3:0] State, NextState;
	assign STATE = State;
	assign NEXTSTATE = NextState;

	localparam 	Init = 4'b0000,
				Fetch = 4'b0001,
				Decode = 4'b0010,
				NOOP = 4'b0011,
				LOAD_A = 4'b0100,
				LOAD_B = 4'b0101,
				STORE = 4'b0110,
				ADD = 4'b0111,
				SUB = 4'b1000,
				HALT = 4'b1001;

	always_comb begin
		case(State)
			Init: begin // Initial state
					NextState = Fetch;
					IR_ld = 0;
					PC_up = 0;
					D_Addr = 0;
					D_Wr = 0;
					RF_s = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
			Fetch: begin // Fetch instruction
					NextState = Decode;
					PC_up = 1;
					IR_ld = 1;
					RF_W_en = 0;
					D_Wr = 0;
					D_Addr = 0;
					RF_s = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
			Decode: begin // Decode instruction
					case(Inst[15:12])
						4'b0000: NextState = NOOP;
						4'b0001: NextState = STORE;
						4'b0010: NextState = LOAD_A;
						4'b0011: NextState = ADD;
						4'b0100: NextState = SUB;
						4'b0101: NextState = HALT;
						default: NextState = Fetch;
					endcase
					PC_up = 0;
					IR_ld = 0;
					D_Addr = 0;
					D_Wr = 0;
					RF_s = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
			NOOP:	begin
					NextState = Fetch; // No operation
					IR_ld = 0;
					PC_up = 0;
					D_Addr = 0;
					D_Wr = 0;
					RF_s = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
			LOAD_A: begin // Prepare data from memory to be written {D_Addr, RF_Addr}
					NextState = LOAD_B;
					D_Addr = Inst[11:4];
					RF_s = 1;
					RF_W_Addr = Inst[3:0];
					IR_ld = 0;
					PC_up = 0;
					D_Wr = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					ALU_s0 = 0;
				end
			LOAD_B: begin // Write data from memory to register {D_Addr, RF_Addr}
					NextState = Fetch;
					D_Addr = Inst[11:4];
					RF_s = 1;
					RF_W_Addr = Inst[3:0];
					RF_W_en = 1;
					IR_ld = 0;
					PC_up = 0;
					D_Wr = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					ALU_s0 = 0;
				end
			STORE: begin // Write data from register to memory {RF_Addr, D_Addr}
					NextState = Fetch;
					D_Addr = Inst[7:0];
					D_Wr = 1;
					RF_Ra_Addr = Inst[11:8];
					IR_ld = 0;
					PC_up = 0;
					RF_s = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
			ADD: begin // Select addition operation and write result to register, {A_Addr, B_Addr, S_Addr}
					NextState = Fetch;
					RF_W_Addr = Inst[3:0];
					RF_W_en = 1;
					RF_Ra_Addr = Inst[11:8];
					RF_Rb_Addr = Inst[7:4];
					ALU_s0 = 3'b001;
					RF_s = 0;
					IR_ld = 0;
					PC_up = 0;
					D_Addr = 0;
					D_Wr = 0;
				end
			SUB: begin // Select subtraction operation and write result to register {A_Addr, B_Addr, S_Addr}
					NextState = Fetch;
					RF_W_Addr = Inst[3:0];
					RF_W_en = 1;
					RF_Ra_Addr = Inst[11:8];
					RF_Rb_Addr = Inst[7:4];
					ALU_s0 = 3'b010;
					RF_s = 0;
					IR_ld = 0;
					PC_up = 0;
					D_Addr = 0;
					D_Wr = 0;
				end
			HALT: begin
					NextState = HALT; // Halt all operations; must reset
					IR_ld = 0;
					PC_up = 0;
					D_Addr = 0;
					D_Wr = 0;
					RF_s = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
			default: begin // Default goes to initial state and initializes all the outputs
					NextState = Init;
					IR_ld = 0;
					PC_up = 0;
					D_Addr = 0;
					D_Wr = 0;
					RF_s = 0;
					RF_Ra_Addr = 0;
					RF_Rb_Addr = 0;
					RF_W_en = 0;
					RF_W_Addr = 0;
					ALU_s0 = 0;
				end
					
		endcase
		
	end

	always_ff @(negedge Clock) begin
		if(!Reset) begin
			State <= NextState;
			PC_clr <= 0;
		end
		else begin
			State <= Init;
			PC_clr <= 1;
		end
	end

endmodule

`ifdef MODEL_TECH

module FSM_tb;
	logic Clock;			// System clock
	logic Reset;			// State machine reset
	logic [15:0]Inst;		// Instruction
	logic PC_clr;			// Program counter clear command
	logic IR_ld;			// Instruction load command
	logic PC_up;			// PC increment command
	logic [7:0]D_Addr;		// Data memory address
	logic D_Wr;				// Data memory write enable
	logic RF_s;				// Mux select line
	logic [3:0]RF_Ra_Addr;	// Register file A-side read address
	logic [3:0]RF_Rb_Addr;	// Register file B-side read address
	logic RF_W_en;			// Register file write enable
	logic [3:0]RF_W_Addr;	// Register file write address
	logic [2:0]ALU_s0;		// ALU function select
	logic [3:0]State;		// Current state as output
	logic [3:0]NextState;	// Next state as output

	FSM DUT(Clock, Reset, Inst, PC_clr, IR_ld, PC_up, D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, State, NextState);
	
	always begin
		Clock = 0; #10;
		Clock = 1; #10;
	end
	
	initial begin
		Reset = 0;
		Inst = 16'h0000; #100;
		Inst = 16'h21A0; #100;
		Inst = 16'h22B1; #100;
		Inst = 16'h23C2; #100;
		Inst = 16'h24D3; #100;
		Inst = 16'h401A; #80;
		Inst = 16'h3A2A; #80;
		Inst = 16'h43AA; #80;
		Inst = 16'h1AEF; #60;
		Inst = 16'h5000; #100;
		Inst = 16'h0000; #80;
		Reset = 1; #20; Reset = 0;
		Inst = 16'h0000; #40;
		Inst = 16'h401A; #80;
		$stop;
	end
	
	initial $monitor("PC_clr %b, IR_ld %b, PC_up %b, D_Addr %h, D_Wr %b, RF_s %b, RF_Ra_Addr %h, RF_Rb_Addr %h, RF_W_en %b, RF_W_Addr %h, ALU_s0 %b, State %b, NextState",
					PC_clr, IR_ld, PC_up, D_Addr, D_Wr, RF_s, RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, State, NextState);
endmodule
`endif