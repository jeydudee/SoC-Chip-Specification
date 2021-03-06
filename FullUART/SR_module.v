`timescale 1ns / 1ps
//****************************************************************//
//  File Name: SR_module.v														//
//																						//
//  Created by Jacob Nguyen on 09/12/18.                          //
//  Copyright � 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: SR flop, used for "set" and "reset" of interrupt		//
//				  signals to the Tramelblaze. Set will set it to 1		//
//				  and Reset to set it to 0.									//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//

module SR_module(clk, reset, s, r, q);

	input  clk, reset, s, r;
	output reg q;
	
	always @(posedge clk, posedge reset)
		if (reset) q <= 1'b0; else
		if (s)	  q <= 1'b1; else
		if (r)	  q <= 1'b0; else
					  q <= q;

endmodule
