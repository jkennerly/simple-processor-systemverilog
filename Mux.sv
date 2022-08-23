// Spring 2022 - TCES 330
// Module Writer: Jane Kennerly
// Module Reviewer: Richard Chou

// Course Project - Processor - 2x1 Mux
// MUX selects between ALU or Data Memory
// Select 0 for ALU | 1 for Data Memory

module Mux(ALUQ, RFSelect, ReadData, WriteData);

input [15:0] ALUQ, ReadData;
input RFSelect; //when 0 - ALU | when 1 - datamemory
output logic [15:0] WriteData;

always @(*) //if RFSelect is..., WriteData is ...
case (RFSelect) //ALUQ or ReadData
0: WriteData = ALUQ; 
1: WriteData = ReadData; 

endcase
endmodule

//testbench
module Mux_tb;

logic [15:0] ALUQ, ReadData;
logic RFSelect; //when 0 - ALU | when 1 - datamemory
logic [15:0] WriteData;

Mux test (ALUQ, RFSelect, ReadData, WriteData);
initial begin
for (int i = 0; i < 16; i++) begin // randomly test 16 selections
$monitor($time,,,, "ALU input = %h \t Select = %h \t ReadData = %h \t Output = %h", ALUQ, RFSelect, ReadData, WriteData);
{ALUQ, RFSelect, ReadData} = $random;
#10;
end
end
endmodule
