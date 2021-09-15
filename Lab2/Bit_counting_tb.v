`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:04 09/14/2021 
// Design Name: 
// Module Name:    Bit_counting_tb 
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
module Bit_counting_tb();

	reg ACLK;
	reg ARESETN;
	reg start;
	reg LoadA;
	reg [7:0] A;
	wire done;
	wire [2:0] B;
	
	Bit_counting uut (.ACLK(ACLK),
							.ARESETN(ARESETN),
							.start(start),
							.LoadA(LoadA),
							.A(A),
							.done(done),
							.B(B)
							);
	
	initial begin
		// Initialize Inputs
		ACLK = 0;
		start = 0;
		ARESETN = 0;
		A = 8'd0;

		// Wait 100 ns for global reset to finish
		#100;
      ARESETN = 1;
		// Add stimulus here
	end
	initial begin
		forever begin 
			#10 ACLK=!ACLK;
		end 
	end 
	initial begin
		#100
		A = 8'd15;
		#50
		LoadA = 1;
		start = 1;
		#400
		LoadA = 0;
		start = 0;
		#400
		A = 8'd6;
		LoadA = 1;
		start = 1;
	end

endmodule
