// Spring 2022 - TCES 330
// Module Writer: Jane Kennerly
// Module Tester: Richard Chou
// Processor project
// This module latches the instruction from instruction memory

module IR(
	input clk, 						// system clock
	input Id, 						// load instruction enable
	input [15:0] instIn, 			// instruction from instruction memory
	output logic [15:0] instOut); 		// output instruction
	
	// latch instruction
	always @(posedge clk) begin
		if (Id) instOut <= instIn;
	end
endmodule

module IR_tb;
	logic clk; 						// system clock
	logic Id; 						// load instruction enable
	logic [15:0] instIn; 			// instruction from instruction memory
	logic [15:0] instOut; 			// output instruction
	
	IR DUT(clk, Id, instIn, instOut);

	always begin
		clk=0;#10;
		clk=1;#10;
	end
	
	initial begin
		Id = 0; 	// Initially disabled load enable
		instIn = 0;	// Initial input set to 0
		$display("Loading random values to the register.");
		for(int i = 0; i < 16; i++) begin
			Id = $random; instIn = $random; #20;
			$display("Id = %b \tinstIn = %h \t instOut = %h ", Id, instIn, instOut);
		end
		$stop;
	end
endmodule