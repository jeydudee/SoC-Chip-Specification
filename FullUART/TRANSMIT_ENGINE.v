`timescale 1ns / 1ps
//****************************************************************//
//  File Name: TRANSMIT_ENGINE.v												//
//																						//
//  Created by Jacob Nguyen on 10/23/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Transmit Engine module of the UART. 						//
//											At the heart of the design is		//
//				  a 11-bit shift register that will be loaded with 	//
//				  the correct data and then outputted serially via		//	
//				  the Tx signal. The UART configuration allows the 	//
//				  user to decide the Baud rate, enable the eight bit, //
//				  enable parity, and switch between odd and even 		//
//				  parity (if enabled). The design also has the Tx		//		
//				  Ready signal which will be asserted upon reset 		//	
//				  and send an interrupt to the Tramelblaze and 			//
//				  perform a transmission, deasserting Tx Ready.			//
//				  When transmission is finished, Tx Ready will be		//
//				  asserted again and communicate to the Tramelblaze	//
//				  that it is ready to send more data.						//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module TRANSMIT_ENGINE(clk, reset, load, BAUD_K, EIGHT, PEN, OHEL, 
							  OUT_PORT_DATA, TX_RDY, TX);
	
	input clk,
			reset, 
			load,
			EIGHT,
			PEN,
			OHEL;
			
	input [7:0]  OUT_PORT_DATA;
	input [18:0] BAUD_K;
	
	output TX_RDY, 
				  TX;
		
	wire		  DONE,		// Stop counting and sending bits
				  DONE_D1,	// Resets Tx Ready
				  WRITE_D1,	// Load to shift register
				  DO_IT,		// Allows counting and sending bits
				  BTU;		// Asserted for each bit time period
				  
	wire [7:0] LOAD_DATA;
	wire [1:0] decode_shr_lines;	
	
	TX_RDY sr1 (
		.clk(clk),
		.reset(reset),
		.s(DONE_D1),
		.r(load),
		.q(TX_RDY)
	);
	
	SR_module sr2 (
		.clk(clk),
		.reset(reset),
		.s(load),
		.r(DONE),
		.q(DO_IT)
	);
	
	reg8 reg8 (
		.clk(clk),
		.reset(reset),
		.ld(load),
		.d(OUT_PORT_DATA),
		.q(LOAD_DATA)
	);
	
	d_flipflop dff1 (
		.clk(clk),
		.reset(reset),
		.d(load),
		.q(WRITE_D1)
	);
	
	decode_shr dshr (
		.EIGHT(EIGHT),
		.PEN(PEN),
		.OHEL(OHEL),
		.LOAD_DATA(LOAD_DATA),
		.DATA_OUT(decode_shr_lines)
	);

	
	shift_register shift_register (
		.clk(clk),
		.reset(reset),
		.load(WRITE_D1),
		.shift(BTU),
		.data_in({decode_shr_lines, LOAD_DATA[6:0], 2'b01}),
		.TX(TX)
	);	
	
	BIT_TIME_COUNTER BTC (
		.clk(clk),
		.reset(reset), 
		.compare(BAUD_K), 
		.DOIT(DO_IT),  
		.BTU_out(BTU)
	);
	
	
	BIT_COUNTER BC (
		.clk(clk),
		.reset(reset),
		.DOIT(DO_IT),
		.BTU(BTU),
		.BIT_COUNTER_UP(DONE)
	);
	
	d_flipflop dff2 (
		.clk(clk),
		.reset(reset),
		.d(DONE),
		.q(DONE_D1)
	);
			  
	
endmodule
