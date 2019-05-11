`timescale 1ns / 1ps
//****************************************************************//
//  File Name: BIT_COUNTER_DECODE.v											//
//																						//
//  Created by Jacob Nguyen on 10/24/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: 	Decoder to calculate how many bits to count in 		//
//					the serial input to the Receive Engine based			//
//					on the inputs of EIGHT AND PEN.							//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module BIT_COUNTER_DECODE(SEL, COUNT_VAL);
	input  [1:0] SEL;
	output [3:0] COUNT_VAL;

	assign COUNT_VAL = (SEL == 2'b00) ? 4'd8:	// EIGHT = 0, PEN = 0
							 (SEL == 2'b01) ? 4'd9:	// EIGHT = 0, PEN = 1
							 (SEL == 2'b10) ? 4'd9:	// EIGHT = 1, PEN = 0
							 (SEL == 2'b11) ? 4'd10:	// EIGHT = 1, PEN = 1
													4'd8;
endmodule
