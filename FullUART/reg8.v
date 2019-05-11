`timescale 1ns / 1ps
//****************************************************************//
//  File Name: reg8.v 															//
//																						//
//  Created by Jacob Nguyen on 10/1/18.	                        //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: 8-bit register file to be loaded with OUT_PORT[7:0] //
//				  of the Tramelblaze.											//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module reg8(clk, reset, ld, d, q);

	input	clk, reset, ld;
	input [7:0] 		 d;
	
	output reg [7:0]  q;
	
	always @(posedge clk, posedge reset)
		if (reset) q <= 8'b0; else
		if (ld)	  q <= d;	  else
					  q <= q;


endmodule
