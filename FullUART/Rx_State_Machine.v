`timescale 1ns / 1ps
//****************************************************************//
//  File Name: Rx_State_Machine.v											//
//																						//
//  Created by Jacob Nguyen on 10/23/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: The Rx State Machine for the Receive Engine is 		//
//				  responsible for ensuring that the Start bit is 		//
//				  able to be sampled by remaining active until the		//
//				  mid-bit time. When half the bit time has elapsed, 	//
//				  the receive engine will then continue to process 	//
//				  data at normal bit time until finished. Outputs 		//
//				  are START and DOIT: START indicates looking for the //
//				  first bit, and DOIT indicates that the engine			//
//				  is reading and processing data.							//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module Rx_State_Machine(clk, reset, RX, BTU, DONE, START, DOIT);

	input clk, reset, RX, BTU, DONE;
	
	output START, DOIT;
	
	//***************************************
	// Declare state constants
	//**************************************
	parameter Idle = 2'b00,
				 Start = 2'b01,
				 Data_Collection = 2'b10;
				 
	//***************************************
	// Declare state registers and outputs
	//**************************************			 
	reg [1:0] p_s, n_s,
				 p_o, n_o;			
				 
	//******************************************
	// State Register Logic
	//******************************************
	always @(posedge clk, posedge reset) begin
		if (reset) {p_s, p_o} <= 4'b0; else
					  {p_s, p_o} <= {n_s, n_o};
	end
	
	//*******************************************
	// Next State and Output Logic
	//*******************************************
	always @* begin
		case(p_s)
			Idle: 
				begin
					// START = 0
					// DOIT	= 0
					
					if (RX) {n_s, n_o} = {Idle,  2'b00};
					else	  {n_s, n_o} = {Start, 2'b11};
				end
			Start:
				begin
					// START = 1
					// DOIT	= 1

					if (~RX & ~BTU) {n_s, n_o} = {Start, 2'b11}; else
					if (~RX & BTU)	 {n_s, n_o} = {Data_Collection, 2'b01}; else
										 {n_s, n_o} = {Idle, 2'b00};
				end
			Data_Collection:
				begin
					// START = 0
					// DOIT	= 1

					if (DONE) {n_s, n_o} = {Idle, 2'b00}; else
								 {n_s, n_o} = {Data_Collection, 2'b01};
				end
			default: {n_s, n_o} = 4'h0; 
		endcase
	end
	
	//***********************************
	// Assign statements for Outputs
	//***********************************
	assign {START, DOIT} = p_o;
	
endmodule
