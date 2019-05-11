`timescale 1ns / 1ps
//****************************************************************//
//  File Name: d_flipflop.v 													//
//																						//
//  Created by Jacob Nguyen on 10/1/18.	                        //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Simple d-flip-flop with positive edge sensitivity	//
//				  to the clock and reset.										//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module d_flipflop(clk, reset, d, q);
	input clk , reset, d;
	output reg q;
	
	always @(posedge clk, posedge reset)
		if (reset) q <= 1'b0; else
					  q <= d;

endmodule
