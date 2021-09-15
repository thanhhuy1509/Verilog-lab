`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:38 06/28/2021 
// Design Name: 
// Module Name:    Bit_Counter 
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
module Bit_Counter(
    input i_clk,
    input i_rst_n,
    input i_start,
    input i_load,
    input [7:0] i_data,
    output [3:0] o_sum,
    output o_done
    );
  reg selD;
  reg [7:0] data_in; 
  reg [3:0] sum_in;
  reg [3:0] sum_reg;
  reg done_reg;
  wire z;
  reg [1:0] current_state,next_state; 
  reg [3*40:1] DISLAY_STATE;
  parameter idle = 0,ready = 1, process = 2, finish = 3;
  
   
 always @(posedge i_clk or negedge i_rst_n)  
  begin 	
	   if (!i_rst_n) 
	    current_state <= idle;
	   else
	    current_state <= next_state;
  end 
  
 always@(*) 
  begin
     case(current_state) 
  
      idle:begin  
	  
	    if(!i_start) 
	     next_state =idle;
       else
	     next_state = ready;
       end
	
      ready:begin 
	
	    if(!i_load)	 
	     next_state = ready;
	    else
	     next_state = process; 
       end
	 
	   process:begin 
	    if (!z)
	     next_state = process;
	    else
	     next_state = finish;
	    end
	 
      finish:begin 
       if (!i_start)
        next_state = finish;
       else
	     next_state = idle; 
	    end 
	  
	  default: next_state = idle; 
	  
    endcase 	  
 end 
  
 always@(*)
  
  begin 
   case(current_state)
     
	  idle:begin  
		 selD = 1'b1;
	  end
    
	  ready:begin 
	    selD = 1'b1;
	  end
		
     process:begin 
		 selD =1'b0;
	  end
		  
	  finish:begin
		 selD = 1'b0;
	  end
	  
   endcase 
 end	

 
  //shift, sum data  
 
 always@(posedge i_clk or negedge i_rst_n) 
 
   if(!i_rst_n) begin
    
   	sum_in <= 0;
 
   end else if(selD == 1'b1) begin 
     
 	   data_in <= i_data ;
      sum_in <= 0; 
  
   end else begin if (data_in[7] == 1) begin    
      
		sum_in <= sum_in + 1;
      data_in <= data_in << 1;			 
  
   end else begin  
		
		sum_in <= sum_in;
	   data_in <= data_in << 1;
  
   end 
 end
	
  assign z = (data_in[7:0] == 0)? 1'b1:1'b0;  
  assign o_done = done_reg ;
  assign o_sum = sum_reg ;

  //register 
  
 always @(*)
   begin
	
	  if(!i_rst_n) begin

       data_in <= 8'hZ;  
	    done_reg <=1'hZ; 
	    sum_reg <= 3'hZ;  
	  
	  
	  end else begin if (current_state == finish) begin
        
	    done_reg <= 1'b1;
       sum_reg <= sum_in; 
	
	  end else if (current_state == idle && i_start == 1)  
	 
	    done_reg <= 1'b0;
	 
	 
	  else if (next_state == idle)
	  
	    sum_reg <= 1'b0;
		 
    end
 end

 
 always @(current_state) begin
    case (current_state)     
     
   	 idle: DISLAY_STATE ="IDLE";   
		 ready: DISLAY_STATE ="READY";
       process: DISLAY_STATE ="Process ";          
       finish: DISLAY_STATE =" Finish ";
          
    endcase
 end
endmodule
