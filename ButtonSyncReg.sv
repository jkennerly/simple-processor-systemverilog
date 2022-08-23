// TCES 330, Spring 2022
// Button Sync State Machine
// Ensures a button press is 
// only one clock period long


module ButtonSyncReg( Clk, Bi, Bo );
  input Bi;      // unregistered input button press
  input Clk;      // system clock
  
  output logic Bo;  // our output

  logic Bi_; // can introduce more to register 
  
  // State assignments
  localparam S_A = 2'h0, 
             S_B = 2'h1,
             S_C = 2'h2,
             S_D = 2'h3;
             
  logic [1:0] State = S_A, StateNext;
  logic Bii = 0;  // registered input
  
  // CombLogic
  always_comb begin
	  Bo = 0;  // default
		
    case ( State )
      
      S_A: begin
        if ( Bii )
          StateNext = S_B;  // button push detected
			  else
				  StateNext = S_A;
      end
      
      S_B: begin
        Bo = 1; // turn output ON
        if ( Bii )
          StateNext = S_C; 
				else
				  StateNext = S_A;
      end
      
      S_C: begin
        if ( Bii )
          StateNext = S_C;  // stay in this state
        else
          StateNext = S_A;  // otherwise, back to A
      end
      
      S_D: begin  // the only other possible value of State
        Bo = 0;
        StateNext = S_A;
      end
      
    endcase
  end // always
    
  // StateReg
  always_ff @( posedge Clk ) begin
        Bi_ <= Bi;
  	Bii <= Bi_;
    State <= StateNext;   // otherwise go to the state we set
  end  // always
  
endmodule
  
//********************************************//
//                 Testbench	                //
//********************************************//
module ButtonSyncReg_testbench;

  logic Clock,
	      ButtonIn,
				ButtonOut;

  ButtonSyncReg DUT( Clock, ButtonIn, ButtonOut );
  
  // develop a clock (50 MHz)
  always begin
    	Clock <= 0;
    	#10;
    	Clock <= 1;
    	#10;
    end  
  
  initial	// Test stimulus
    begin
      ButtonIn = 0;
      #100 ButtonIn = 1;
      #110 ButtonIn = 0;
      #100 $stop;
    end
    
    // view waveforms

endmodule

                   