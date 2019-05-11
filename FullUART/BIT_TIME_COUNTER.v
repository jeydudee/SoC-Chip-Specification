`timescale 1ns / 1ps
//****************************************************************//
//  File Name: BIT_TIME_COUNTER.v											//
//																						//
//  Created by Jacob Nguyen on 10/01/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Counter to specify how long a bit stays on the Tx	//
//				  signal with respect to the Baud Rate. The Baud 		//
//				  Decoder block will determine the "compare" value.	//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module BIT_TIME_COUNTER(clk, reset, compare, DOIT, BTU_out);
	
	input clk, reset, DOIT;
	input [18:0] compare;
	
	output wire BTU_out;
	
	reg [18:0] BIT_TIME_COUNTER;
	
	assign BTU_out = (BIT_TIME_COUNTER == compare);
	
	always @(posedge clk, posedge reset)
		if (reset)		  	   BIT_TIME_COUNTER <= 19'b0; else
		if (DOIT & ~BTU_out) BIT_TIME_COUNTER <= BIT_TIME_COUNTER + 19'b1; else
								   BIT_TIME_COUNTER <= 19'b0;

endmodule
