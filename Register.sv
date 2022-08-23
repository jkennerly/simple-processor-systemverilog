// Spring 2022 - TCES 330
// Module Writer: Richard Chou
// Module Tester: Jane Kennerly
// Processor project
// This is a Verilog description for an 16 x 16 register file
module Register(
	input clk, 						// system clock
	input write, 					// write enable
	input [3:0] wrAddr, 			// write address
	input [15:0] wrData, 			// write data
	input [3:0] rdAddrA, 			// A-side read address
	output [15:0] rdDataA, 			// A-side read data
	input [3:0] rdAddrB,			// B-side read address
	output [15:0] rdDataB); 		// B-sdie read data
	logic [15:0] regfile [0:15];	// the registers
	
	// read the registers
	assign rdDataA = regfile[rdAddrA];
	assign rdDataB = regfile[rdAddrB];
	
	// write to register
	always @(posedge clk) begin
		if (write) regfile[wrAddr] <= wrData;
	end
endmodule

module Register_tb;
	logic clk; 						// system clock
	logic write; 					// write enable
	logic [3:0] wrAddr; 			// write address
	logic [15:0] wrData; 			// write data
	logic [3:0] rdAddrA; 			// A-side read address
	logic [15:0] rdDataA; 			// A-side read data
	logic [3:0] rdAddrB;			// B-side read address
	logic [15:0] rdDataB; 			// B-sdie read data
	
	Register DUT(clk, write, wrAddr, wrData, rdAddrA, rdDataA, rdAddrB, rdDataB);

	always begin
		clk=0;#10;
		clk=1;#10;
	end
	
	initial begin
		rdAddrA=0;
		rdAddrB=0;
		write=1;
		$display("Writing random values to the register.");
		for(int i = 0; i < 16; i++) begin
			wrAddr=i;wrData=$random;#20;
			$display("Address %d data: %h ", i, DUT.regfile[i]);
		end
		write=0;

		$display("\nAssign address i to A and read it");
		for(int i = 0; i < 16; i++) begin
			rdAddrA=i;#10;
			$display("Address A%d: %h", i, rdDataA);
		end

		$display("\nAssign address i to B and read it");
		for(int i = 0; i < 16; i++) begin
			rdAddrB=i;#10;
			$display("Address B%d: %h", i, rdDataB);
		end
		$stop;
	end
endmodule
