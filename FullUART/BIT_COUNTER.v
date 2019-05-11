`timescale 1ns / 1ps
//****************************************************************//
//  File Name: BIT_COUNTER.v													//
//																						//
//  Created by Jacob Nguyen on 10/01/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Counter to keep track of how many bits are being		//
//				  sent to the Tx signal. For our UART, it is always	//
//				  11 bits. Once the counter reaches 11, transmission	//
//				  will complete and Tx Ready will be asserted again.	//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module BIT_COUNTER(clk, reset, DOIT, BTU, BIT_COUNTER_UP);

	input clk, reset, DOIT, BTU;
	output BIT_COUNTER_UP;
	
	reg [3:0] BIT_COUNTER;
	
	assign BIT_COUNTER_UP = (BIT_COUNTER == 11);
	
	always @(posedge clk, posedge reset) 
		if (reset)		  BIT_COUNTER <= 4'b0; else
		if (DOIT & BTU)  BIT_COUNTER <= BIT_COUNTER + 4'b1; else
		if (DOIT & ~BTU) BIT_COUNTER <= BIT_COUNTER; else
							  BIT_COUNTER <= 4'b0;
	

endmodule
