`timescale 1ns / 1ps
//****************************************************************//
//  File Name: BAUD_DECODE.v													//
//																						//
//  Created by Jacob Nguyen on 10/01/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Decoder block that calculates the counter value		//
//				  for a specified Baud Rate with respect to a 100MHz	//
//				  clock.																//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module BAUD_DECODE(BAUD, BAUD_RATE);
	input  [3:0]  BAUD;
	output [18:0] BAUD_RATE;
	
	/*
		BAUD_RATE = (100,000,000 / Baud Rate)
		Ex:
			BAUD_RATE = (100,000,000 / 300 bits/sec ) = 333,333.33
	*/
	
	assign BAUD_RATE = (BAUD == 4'b0000) ? 19'd333_333 : // 300
							 (BAUD == 4'b0001) ? 19'd83_333 :  // 1200
							 (BAUD == 4'b0010) ? 19'd41_667 :  // 2400
							 (BAUD == 4'b0011) ? 19'd20_833 :  // 4800
							 (BAUD == 4'b0100) ? 19'd10_417 :  // 9600
 							 (BAUD == 4'b0101) ? 19'd5_208 :   // 19200
							 (BAUD == 4'b0110) ? 19'd2_604 :   // 38400
							 (BAUD == 4'b0111) ? 19'd1_736 :   // 57600
							 (BAUD == 4'b1000) ? 19'd868 : 	  // 115200
							 (BAUD == 4'b1001) ? 19'd434 :	  // 230400
							 (BAUD == 4'b1010) ? 19'd217 : 	  // 460800
							 (BAUD == 4'b1011) ? 19'd109 : 	  // 921600
														19'd333_333;
							 

	
endmodule
