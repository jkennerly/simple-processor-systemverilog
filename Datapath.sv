// Spring 2022 - TCES 330
// Module Writer: Richard Chou
// Module Tester: Jane Kennerly
// Processor project
module Datapath(
	input Clock,			// Clock
	input [7:0]D_Addr,		// Data Memory address
	input D_Wr,				// Data Memory write enable
	input RF_s,				// Mux select
	input [3:0]RF_W_Addr,	// Register file write address
	input RF_W_en,			// Register file write enable
	input [3:0]RF_Ra_Addr,	// Register file A address
	input [3:0]RF_Rb_Addr,	// Register file B address
	input [2:0]ALU_s0,		// ALU select bit
	output [15:0]ALU_inA,	// ALU input A
	output [15:0]ALU_inB,	// ALU input B
	output [15:0]ALU_out);	// ALU output

	logic [15:0]D_Data;		// Memory data
	logic [15:0]Mux_Data;	// Mux output data
	
	DataMemory DRAMunit(
		D_Addr,			// Memory Address
		Clock,			// System clock
		ALU_inA,		// Memory write data
		D_Wr,			// Memory write enable
		D_Data);		// Memory read data
		
	// Mux2to1(ALUQ, RFSelect, ReadData, WriteData); 0 is ALU, 1 is Memory
	Mux MUXunit(ALU_out, RF_s, D_Data, Mux_Data);
	
	Register REGISTERunit(
		Clock, 			// system clock
		RF_W_en, 		// write enable
		RF_W_Addr, 		// write address
		Mux_Data, 		// write data
		RF_Ra_Addr, 	// A-side read address
		ALU_inA, 		// A-side read data
		RF_Rb_Addr,		// B-side read address
		ALU_inB); 		// B-side read data
	
	// ALU(A, B, sel, Q);
	ALU ALUunit(ALU_inA, ALU_inB, ALU_s0, ALU_out);
	
endmodule

`timescale 1 ps/ 1 ps
module Datapath_tb;
	logic Clock;			// Clock
	logic [7:0]D_Addr;		// Data Memory address
	logic D_Wr;				// Data Memory write enable
	logic RF_s;				// Mux select
	logic [3:0]RF_W_Addr;	// Register file write address
	logic RF_W_en;			// Register file write enable
	logic [3:0]RF_Ra_Addr;	// Register file A address
	logic [3:0]RF_Rb_Addr;	// Register file B address
	logic [2:0]ALU_s0;		// ALU select bit
	logic [15:0]ALU_inA;	// ALU input A
	logic [15:0]ALU_inB;	// ALU input B
	logic [15:0]ALU_out;	// ALU output
	
	Datapath DUT(Clock,D_Addr,D_Wr,RF_s,RF_W_Addr,RF_W_en,RF_Ra_Addr,RF_Rb_Addr,ALU_s0,ALU_inA,ALU_inB,ALU_out);
	
	always begin
		Clock=0;#10;
		Clock=1;#10;
	end
	
	initial begin
		D_Wr = 0;			// Disable write initially
		RF_Ra_Addr = 0;		// Initialize A address to 0
		RF_Rb_Addr = 0;		// Initialize B address to 0
		ALU_s0 = 0;			// Initialize ALU selection to 0
		//ALU_inA = 0;		// Initialize ALU A to 0
		//ALU_inB = 0;		// Initialize ALU B to 0
		RF_s = 0;			// Initialize Register File select to 0
		RF_W_Addr = 0;		// Initialize RF Write to 0;
		RF_W_en = 0;		// Initially write to register disabled

		D_Addr = 8'h1A;		// Memory address to get data
		#20;

		RF_s = 1;			// Select data from memory
		RF_W_en = 1;		// Enable write to register
		RF_W_Addr = 8'hA;	// Register address to write to
		#20;				// Perform Write to Register

		D_Addr = 8'h2B;		// Memory address to get data
		#20;					// Write is enabled and mux is picking memory
		RF_W_Addr = 8'hB;	// Register address to write to
		#20;				// Perform Write to Register

		RF_W_en = 0; 		// Disable register write
		RF_Ra_Addr = 8'hA;	// Register address A / ALU input A
		RF_Rb_Addr = 8'hB;  	// Register Address B / ALU input B
		ALU_s0 = 1;			// Select addition;
		#20;				// Perform Addition

		RF_s = 0;			// Select alu output
		RF_W_en = 1;		// Enable write to register
		RF_W_Addr = 8'h0;	// Register address to write to
		#20;				// Perform Write to Register

		RF_W_en = 0;		// Disable write to register
		RF_Ra_Addr = 8'h0;	// Select addition result
		D_Wr = 1;			// Enable write to memory
		D_Addr = 8'h00;		// Data memory address to write to
		#20;				// Perform Write to Memory
 		D_Wr = 1;           // Disable write to memory
        RF_s = 1;           // Select data from memory
        #20;                // Read from memory address
		$stop;
	end
endmodule
