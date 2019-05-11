`timescale 1ns / 1ps
//****************************************************************//
//  File Name: decode_shr.v													//
//																						//
//  Created by Jacob Nguyen on 10/01/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Decoder block to decide what data is loaded in		//
//				  the two most significant bits of the shift register.//
//				  Inputs for sending the eight bit (EIGHT), Parity		//
//				  Enable (PEN), and Odd/Even Parity (OHEL) determined //
//				  by the user.	Uses bitwise operations for odd/even	//
//				  parity.															//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module decode_shr(EIGHT, PEN, OHEL, LOAD_DATA, DATA_OUT);

	input EIGHT, PEN, OHEL;
	input [7:0] LOAD_DATA;
	
	output [1:0] DATA_OUT;
	
	assign DATA_OUT = ({EIGHT, PEN, OHEL} == 3'b000) ? 2'b11 : 
							({EIGHT, PEN, OHEL} == 3'b001) ? 2'b11 :
							({EIGHT, PEN, OHEL} == 3'b010) ? {1'b1, ^ LOAD_DATA[6:0]} :
							({EIGHT, PEN, OHEL} == 3'b011) ? {1'b1, ~^LOAD_DATA[6:0]} :
							({EIGHT, PEN, OHEL} == 3'b100) ? {1'b1, LOAD_DATA[7]} :
							({EIGHT, PEN, OHEL} == 3'b101) ? {1'b1, LOAD_DATA[7]} :
							({EIGHT, PEN, OHEL} == 3'b110) ? {^ LOAD_DATA, LOAD_DATA[7]} :
							({EIGHT, PEN, OHEL} == 3'b111) ? {~^LOAD_DATA, LOAD_DATA[7]} :
																		2'b11;

endmodule
