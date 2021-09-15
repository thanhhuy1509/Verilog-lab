`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:22:08 06/19/2021 
// Design Name: 
// Module Name:    ExponentialFunction_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ExponentialFunction_tb();
	
	reg ACLK;
	reg ARESETN;
	reg [1:0] X;
	reg [1:0] A;
	wire [3:0] P;
	reg start;
	wire done;
	
	ExponentialFunction uut (.ACLK(ACLK),
									 .ARESETN(ARESETN),
									 .start(start),
									 .X(X),
									 .A(A),
									 .P(P),
									 .done(done)
									 );
	
	initial begin
		// Initialize Inputs
		ACLK = 0;
		start = 0;
		ARESETN = 0;
		A = 0;
		X = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
 end
 initial begin
 forever begin 
 #10 ACLK=!ACLK;
 end 
 end 
 initial begin 
 start=0;
 #100
ARESETN = 1; 
 start= 1;
 A = 1;
 X = 2;
 #100
start= 0;
#100
 start = 1;
 A = 3;
 X = 2;
 #100
 start = 0;
 #100
 start = 1;
 A = 2;
 X = 2;
 #100
 start = 0;
 #100
 start = 1;
 A = 3;
 X = 2;
 #100
 start = 0;
 #100
 start = 1;
 A = 0;
 X = 2;
 #100
  start = 1;
 #10;
 ARESETN =0;
end

endmodule
