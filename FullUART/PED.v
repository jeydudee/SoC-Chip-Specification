`timescale 1ns / 1ps
//****************************************************************//
//  File Name: PED.v																//
//																						//
//  Created by Jacob Nguyen on 09/10/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//  Abstract: PED, or positive edge detector, provides a          //
//				  one-clock-wide pulse when it detects a positive-    //
//				  edge signal                                         //
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module PED(clk, reset, d_in, d_out);
	
	input clk, 
			reset, 
			d_in;		// signal to be detected
			
	reg 	signal;	// delayed signal
	output d_out;	// 1-clock-wide pulse
	
	// delay register
	always @ (posedge clk, posedge reset) begin
		if (reset == 1'b1)
			signal <= 1'b0;
		else
			signal <= d_in;
	end		
	
	// assignment logic
	assign d_out = ~signal & d_in;

endmodule
