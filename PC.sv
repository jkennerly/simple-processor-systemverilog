// Spring 2022 - TCES 330
// Module Writer: Jane Kennerly
// Module Reviewer: Richard Chou
// PC - Program Counter increments through the instruction register

module PC(Clk, Clr, Up, Addr);
	parameter width = 6;	//default width is 7 bits
	input 	Clk, // clock
			Clr, // clear
			Up;	 // enable signal to increment address
	output logic [width:0] Addr = 0;	//address

// start address at 0
// Case 1: Clear signal resets clock to 0
// Case 2: No clear and Count up
// Case 3: Else...no change

	always_ff @(posedge Clk) begin
		if (Clr) Addr <= 0;
		else if (!Clr && Up) Addr <= Addr + 1'b1;
		else Addr <= Addr;
	end

endmodule

module PC_tb;
	localparam width = 3;
	logic Clk, Clr, Up;
	logic [width:0] Addr;

//Initialize instance of program counter (PC)
	PC #(.width(width)) pc_test (Clk, Clr, Up, Addr);

//20 ps clock period
	always #10 Clk = ~Clk;

	initial begin
	$monitor($time,,,"Clock = %b", Clk,,,"Clear = %b", Clr,,,"Up = %b", Up,,,"Address = %h", Addr);

//Initialize all inputs to 0
	Clk = 0; Clr = 0; Up = 0; #20;
	
	// Show Normal operation with Clear off and Up on
	// clear = 0, up = 1
	$display("Normal operation");
	Up = 1; #300;

	// Show Clear will reset counter
	// clear = 1, up = 1
	$display("\nShow Clear will reset counter");
	Clr = 1; #40;

	//Resume counter
	// clear = 0, up = 1
	$display("\nResume counter");
	Clr = 0; #100;

	// Show up is required to increment counter
	$display("\nShow Up = 0 freezes counter");
	Up = 0; #40;

	$stop;
	end //initial begin's end
endmodule