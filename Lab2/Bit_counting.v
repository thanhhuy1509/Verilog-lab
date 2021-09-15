`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:25:31 09/14/2021 
// Design Name: 
// Module Name:    Bit_counting 
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
module Bit_counting(input ACLK,
						  input ARESETN,
						  input start,
						  input LoadA,
						  input [7:0] A,
						  output done,
						  output [2:0] B
						  );
	//Registers
	reg [7:0] A_temp;
	reg [7:0] A_reg;
	reg [2:0] add1;
	reg [2:0] add1_temp;
	reg [2:0] B_temp;
	reg [2:0] B_reg;
	reg done_reg;
	//Control signals
	reg loadA, shiftA, loadB, addB;
	//States
	parameter IDLE				= 2'b00,
				 Load_Data		= 2'b01,
				 Bit_Counting	= 2'b10,
				 Finish			= 2'b11;
	reg [1:0] current_state, next_state;
	//Other signals
	wire Z;
	
	//States processing
	always @(posedge ACLK or negedge ARESETN) begin
		if(!ARESETN)
			current_state <= IDLE;
		else
			current_state <= next_state;
	end
	
	always @(*) begin
		case(current_state)
			IDLE: begin
				if(ARESETN)
					next_state <= Load_Data;
				else
					next_state <= IDLE;
			end
			Load_Data: begin
				if(LoadA && start)
					next_state <= Bit_Counting;
				else
					next_state <= Load_Data;
			end
			Bit_Counting: begin
				if(Z)
					next_state <= Finish;
				else
					next_state <= Bit_Counting;
			end
			Finish: begin
				if(!start)
					next_state <= IDLE;
				else
					next_state <= Finish;
			end
		endcase
	end
	
	//Inter signals processing
	always @(*) begin
		case(current_state)
			IDLE: begin
				loadA		<= 1'b0;
				shiftA	<= 1'b0;
				loadB		<= 1'b0;
				addB		<= 1'b0;
			end
			Load_Data: begin
				loadA		<= 1'b1;
				shiftA	<= 1'b0;
				loadB		<= 1'b1;
				addB		<= 1'b0;
			end
			Bit_Counting: begin
				loadA		<= 1'b0;
				shiftA	<= 1'b1;
				loadB		<= 1'b0;
				addB		<= 1'b1;
			end
			Finish: begin
				loadA		<= 1'b0;
				shiftA	<= 1'b0;
				loadB		<= 1'b0;
				addB		<= 1'b0;
			end
		endcase
	end
	
	assign a0 = (A_reg[7] == 1'b1)? 1'b1:1'b0;
	assign Z  = (A_reg == 8'b0)? 1'b1:1'b0;
	
	//Load A to A_temp
	always @(*) begin
		if(loadA)
			A_temp <= A;
		else
			A_temp <= 8'b0;
	end
	
	//Load A_temp to A_reg
	always @(posedge ACLK) begin
		if(LoadA)
			A_reg <= A_temp;
		if(shiftA)
			A_reg <= A_reg << 1;
	end
	
	//Adder
	always @(*) begin
		if(a0)
			add1 <= B_reg + 3'd1;
		else
			add1 <= B_reg;
	end
	
	//Set-up add_temp;
	always @(*) begin
		if(addB)
			add1_temp <= add1;
		else
			add1_temp <= B_reg;
	end
	
	//Set-up B_reg
	always @(posedge ACLK) begin
		if(loadB)
			B_reg <= 3'd0;
		else
			B_reg <= add1_temp;
	end
	
	always @(posedge ACLK or negedge ARESETN) begin
		if(!ARESETN) begin
			done_reg <= 1'b0;
			B_temp <= 3'd0;
		end
		else
			if(current_state == Finish) begin
				B_temp <= B_reg;
				done_reg <= 1'b1;
			end
	end
	
	assign B = B_temp;
	assign done = done_reg;	
	
endmodule
