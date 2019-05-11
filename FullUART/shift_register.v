`timescale 1ns / 1ps
//****************************************************************//
//  File Name: shift_register.v												//
//																						//
//  Created by Jacob Nguyen on 10/01/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: The shift register is responsible for being loaded	//
//				  with the correct information then being shifted  	//
//				  and outputted the correct number of times to the		//
//				  tx signal. Tx signal is one bit because UART 			//
//				  configuration is parallel-in-serial-out. Upon			//
//				  reset, the shift register is loaded with "1's",		//
//				  marking the Tx signal as inactive. Only when a		//
//				  "0" is shifted into the Tx signal will it be 			//
//				  considered the start bit and begin transmission.		//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module shift_register(clk, reset, load, shift, data_in, TX);

	input 		 clk,
					 reset,
					 load,
					 shift;
	
	input [10:0] data_in;
	
	output TX;
	
	reg [10:0] shift_reg;

	always @(posedge clk, posedge reset) begin
		if (reset) shift_reg <=   					 11'h3FF; else
		if (load)  shift_reg <= 					 data_in; else 
		if (shift) shift_reg <= {1'b1, shift_reg[10:1]}; else
					  shift_reg <= shift_reg;
	end

	assign TX = shift_reg[0];
	
endmodule
