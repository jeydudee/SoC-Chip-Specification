`timescale 1ns / 1ps
//****************************************************************//
//  File Name: REMAPPING.v														//
//																						//
//  Created by Jacob Nguyen on 10/24/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: 	Remapping is responsible for "right justification"	//
//					of the received data based upon UART configuration //
//					for the eighth bit and parity enable.					//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module REMAPPING(DATA_IN, EIGHT, PEN, DATA_OUT);

	input EIGHT, PEN;
	input [9:0] DATA_IN;

	output [9:0] DATA_OUT;
	
	assign DATA_OUT = ({EIGHT, PEN} == 2'b00) ? {2'b0, DATA_IN[9:2]}:
							({EIGHT, PEN} == 2'b01) ? {1'b0, DATA_IN[9:1]}:
							({EIGHT, PEN} == 2'b10) ? {1'b0, DATA_IN[9:1]}:
							({EIGHT, PEN} == 2'b11) ? DATA_IN:
															  DATA_IN;
endmodule
