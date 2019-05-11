`timescale 1ns / 1ps
//****************************************************************//
//  File Name: shift_reg.v														//
//																						//
//  Created by Jacob Nguyen on 10/24/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: 10-bit shift register is responsible for reading in //
//				  data from the Rx signal and then being remapped and //
//				  sent as an input to the Tramelblaze (IN_PORT). 		//
//				  Since Rx is one bit wide, the shift register 			//
//				  supports a serial-in-parallel-out protocol. Data		//
//				  is shifted in whenever "Bit Time Up" is asserted.	//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module shift_reg(clk, reset, shift, SDI, shift_reg);

	input clk, reset, shift, SDI;
	output reg [9:0] shift_reg;
	
	always @(posedge clk, posedge reset)
		if (reset) shift_reg <= 10'b0; else
		if (shift) shift_reg <= {SDI, shift_reg[9:1]}; else
					  shift_reg <= shift_reg;


endmodule
