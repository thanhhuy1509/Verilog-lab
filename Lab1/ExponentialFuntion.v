`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:49:58 06/19/2021 
// Design Name: 
// Module Name:    ExponentialFuntion 
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
module ExponentialFunction(input ACLK,
								   input ARESETN,
									input start,
								   input  [1:0] X,
								   input  [1:0] A,
								   output [3:0] P,
									output done
								   );
	//Activities signal
	reg	selA;
	reg 	selP;
	//State signal
	wire	Z;
	//Counter register
	reg	[1:0]		cnt;
	//Ouput
	reg	[3:0]		P1;
	reg	[3:0]		P_reg;
	wire	[3:0]		P_temp;
	//Finish signal
	reg 	done_reg;
	reg	stop;
	
	parameter IDLE 		= 2'b00,
				 PROCESS		= 2'b01,
				 FINISH		= 2'b10;
	reg 	[1:0]		current_state, next_state;
	
	//Set state for current_state
	always @(posedge ACLK or negedge ARESETN) begin
		if(!ARESETN) begin
			current_state 	<= IDLE;
		end
		else
			current_state 	<= next_state;
	end
	
	//Change state base on signal
	always @(*) begin
		case(current_state)
			IDLE: begin
				if(!start)
					next_state <= IDLE;
				else
					next_state <= PROCESS;
			end
			
			PROCESS: begin
				if(!Z)
					next_state <= PROCESS;
				else
					next_state <= FINISH;
			end
			
			FINISH: begin
				if(!start) 
					next_state <= IDLE;
				else
					next_state <= FINISH;
			end
			default: next_state <= IDLE;
		endcase
	end
	
	//Activities signal
	always @(*)begin
		case(current_state)
			IDLE: begin
				selA <= 1'b1;
				selP <= 1'b1;
			end
			
			PROCESS: begin
				selA <= 1'b0;
				selP <= 1'b0;
			end
			
			FINISH: begin
				selA <= 1'b0;
				selP <= 1'b0;
			end
			
		endcase
	end
	
	//Counter function
	always @(posedge ACLK) begin
		if(selA)
			cnt <= A - 1;
		else
			cnt <= cnt - 1;
	end
	
	assign Z = (cnt == 2'b00)? 1'b1:1'b0;
	
	//Multiply function
	always @(posedge ACLK) begin
		if(selP)
			P1 <= 1;
		else if(!done)
			P1 <= P_temp;
	end
	
	assign P_temp = P1 * X;
	assign P = P_reg;
	assign done = done_reg;
	
	always @(posedge ACLK or negedge ARESETN) begin
		if(!ARESETN)begin
			done_reg <= 1'b0;
			stop		<= 1'b0;
		end 
		else begin 
			if(next_state == FINISH) begin
				done_reg <= 1'b1;
				stop		<= 1'b1;
			end
			else if(next_state == IDLE)
				done_reg <= 0;
			else if(current_state == FINISH)
				stop	<= 1'b0;
		end
	end
	
	always @(posedge ACLK) begin
		if(stop)
			P_reg	<= P1;
	end
endmodule
