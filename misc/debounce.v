`timescale 1ns / 1ps
//****************************************************************//
//  File Name: debounce.v														//
//																						//
//  Created by Jacob Nguyen on 09/10/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//  Abstract: The debounce module is used to bypass the effects   //
//				  "bouncing" caused by a button press. Also known 	   //
//				  as a digital filter, it filters out the brief       //
//				  period of time when a button bounces between logic  //
//				  0 and 1. Instead, it provides a delayed signal of   //
//				  either 1 or 0 after the bouncing has subsided. It   //
//				  is done by implementing a Modified Moore FSM,       //
//				  meaning there is a present output and next output   //
//				  signal. 															//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//

// Note: Much of the module is based off of Pong Chu's debounce 
//			module within his textbook.

module debounce(clk, reset, btn, p_o);
	
	input  clk, 
			 reset, 
			 btn;
			
	output p_o;
	
	//***************************************
	// Declare state registers and signals
	//**************************************
	reg [2:0] p_s, // present state
				 n_s; // next state

	reg 	 p_o,		// present output
			 n_o;		// next output
	
	/***************************************
			Generates a 10 ms pulse
	***************************************/
	wire 			tick;
	reg [19:0] count;
	assign tick = (count == 999999);
	
	always @ (posedge clk, posedge reset)	begin
		if (reset)  count <= 20'b0; else
		if (tick)	count <= 20'b0; else
						count <= count + 20'b1;
	end
	/***************************************/
	
	//******************************************
	// State Register Logic
	//******************************************
	always @ (posedge clk, posedge reset) begin
		if (reset) {p_s, p_o} <= 4'b0;
		else		  {p_s, p_o} <= {n_s, n_o};
	end
	
	
	//*******************************************
	// Next State and Output Logic
	//*******************************************
	always @* begin 
		
		//default signal
		{n_s, n_o} = {p_s, 1'b0};
		
		case (p_s)
			3'b000: if (btn) n_s = 3'b001;
						
			3'b001: if (~btn) n_s = 3'b000; else
					  if (tick) n_s = 3'b010;
			3'b010: if (~btn) n_s = 3'b000; else
					  if (tick) n_s = 3'b011;
			3'b011: if (~btn) n_s = 3'b000; else
					  if (tick) n_s = 3'b100;
					  
			3'b100: begin
						n_o = 1'b1;
						if (~btn) n_s = 3'b101;
					  end
					  
			3'b101: begin
						n_o = 1'b1;
						if (btn) n_s = 3'b100; else
						if (tick)n_s = 3'b110;
					  end
					  
			3'b110: begin
						n_o = 1'b1;
						if (btn) n_s = 3'b100; else
						if (tick)n_s = 3'b111;
					  end
					  
			3'b111: begin
						n_o = 1'b1;
						if (btn) n_s = 3'b100; else
						if (tick)n_s = 3'b000;
					  end
					  
			default: {n_s, n_o} = 4'b0;
		endcase
	end
	

	
endmodule
