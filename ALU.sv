// Spring 2022 - TCES 330
// Module Writer: Jane Kennerly
// Module Reviewer: Richard Chou

// Course Project - Processor - ALU

module ALU(A, B, sel, Q);
parameter bits = 16;
input [(bits - 1):0] A, B; //operands
input [2:0] sel; //op code
output logic [(bits - 1):0] Q;

always @(*) //if sel is..., Q is ...
case (sel) //ALUQ or ReadData
0: Q = 0; // everything 0
1: Q = (A + B); //addition
2: Q = (A - B); //subtraction
3: Q = A; // pass-through A
4: Q = A ^ B; // A XOR B (bitwise)
5: Q = A | B; // A OR B (bit-wise)
6: Q = A & B; // A AND B (bit-wise)
7: Q = A + 1'b1; // increment 1 to A

endcase

endmodule

//testbench
module ALU_tb;
localparam bits = 4;
//localparam bits = 4;
logic [(bits - 1):0] A, B; //operands
logic [2:0] sel; //op code
logic [(bits - 1):0] Q;

ALU #(.bits(bits))DUT (A, B, sel, Q);
initial begin
for (int i = 0; i < 8; i++) begin //test every function
for (int j = 0; j < 3; j++) begin //test each function 3x with random numbers
$monitor($time,,,, "A = %b \t B = %b \t Select = %d \t Output = %b", A, B, sel, Q);
sel = i; {A, B} = $random;
#10;
end
$display;
end
end

endmodule