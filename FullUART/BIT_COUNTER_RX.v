`timescale 1ns / 1ps
//****************************************************************//
//  File Name: BIT_COUNTER_RX.v												//
//																						//
//  Created by Jacob Nguyen on 10/24/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: 	Counter to keep track of how many bits to the 		//
//					Receive Engine reads before the data is remapped	//
//					and set as the Rx output data. Once the counter		//
//					reaches the number of bits to be read based upon	//
//					the UART configuration, RX_RDY is asserted on the	//
//					next clock signal.											//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module BIT_COUNTER_RX(clk, reset, compare, DOIT, BTU, BIT_COUNTER_UP);

	input clk, reset, DOIT, BTU;
	input [3:0] compare;
	
	output BIT_COUNTER_UP;
	
	reg [3:0] BIT_COUNTER;
	
	assign BIT_COUNTER_UP = (BIT_COUNTER == compare);
	
	always @(posedge clk, posedge reset) 
		if (reset)		  BIT_COUNTER <= 4'b0; else
		if (DOIT & BTU)  BIT_COUNTER <= BIT_COUNTER + 4'b1; else
		if (DOIT & ~BTU) BIT_COUNTER <= BIT_COUNTER; else
							  BIT_COUNTER <= 4'b0;


endmodule
