`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:49:29 06/28/2021
// Design Name:   Bit_Counter
// Module Name:   E:/Project/project1/Bit_Counter/Bit_CounterTB.v
// Project Name:  Bit_Counter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Bit_Counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Bit_CounterTB;

	// Inputs
	reg i_clk;
	reg i_rst_n;
	reg i_start;
	reg i_load;
	reg [7:0] i_data;

	// Outputs
	wire [3:0] o_sum;
	wire o_done;

	// Instantiate the Unit Under Test (UUT)
	Bit_Counter uut (
		.i_clk(i_clk), 
		.i_rst_n(i_rst_n), 
		.i_start(i_start), 
		.i_load(i_load), 
		.i_data(i_data), 
		.o_sum(o_sum), 
		.o_done(o_done)
	);

	initial begin
		// Initialize Inputs
		i_clk = 0;
		i_rst_n = 0;
		i_start = 0;
		i_load = 0;
		i_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
  initial begin
 forever begin 
#10 i_clk=!i_clk;
 end 
 end 
 initial begin 
 i_start=0;

#200
 i_rst_n = 1; 
 i_start= 1;
 i_data = 8'b11111111;

#20
 i_start=0;
 
#50
 i_load = 1;

#20
 i_load = 0;
 
#300
 i_start = 1;

#20
 i_start = 0;
 

 
#200
 i_start = 1;
 i_data = 8'b00111000;    

#20
 i_start = 0;
#50
 i_load =1;
#20
 i_load = 0;
 
 
 
#200
 i_start = 0; 
 i_rst_n = 0;
 
#200
 i_start = 1;
 i_rst_n = 1;
 i_data = 8'b00000011;    
 
#20
 i_start = 0; 
#50 
 i_load = 1;
#20 
 i_load =0;
 
#200 
 i_start = 0;
 i_rst_n = 0;
 
#200
 i_start = 1;
 i_rst_n = 1;
 i_data = 8'b00001111;
 
#20 
 i_start = 0; 
#50 
 i_load = 1; 
#20 
 i_load = 0;
 
#200
 i_start = 0; 
  
 
 
#10;
  i_rst_n =1;
 end
endmodule

