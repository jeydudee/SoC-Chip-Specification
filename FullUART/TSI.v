`timescale 1ns / 1ps
//****************************************************************//
//  File Name: TSI.v																//
//																						//
//  Created by Jacob Nguyen on 12/08/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: 	Techonology-specific instantiation module for		//
//					I/O components for the Spartan 6 FPGA family.		//
//					Clocks require BUFG while inputs and outputs use	//
//					IBUF and OBUF respectively.								//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module TSI(clk_I, button_I, switch_I, LED_I, RX_I, TX_I,
			  clk_O, button_O, switch_O, LED_O, RX_O, TX_O);
			  
	input clk_I, button_I, RX_I, TX_I;
	input [6:0]switch_I;
	input [7:0] LED_I;
	
	output clk_O, button_O, RX_O, TX_O;
	output [6:0] switch_O;
	output [7:0] LED_O;
	
	
	BUFG clk(
		.I(clk_I),
		.O(clk_O)
	);

	IBUF button(
		.I(button_I),
		.O(button_O)
	);
	
	IBUF Rx(
		.I(RX_I),
		.O(RX_O)
	);	
	IBUF switch [6:0](
		.I(switch_I),
		.O(switch_O)
	);
	OBUF Tx(
		.I(TX_I),
		.O(TX_O)
	);	 
	OBUF LED [7:0](
		.I(LED_I),
		.O(LED_O)
	);
endmodule
