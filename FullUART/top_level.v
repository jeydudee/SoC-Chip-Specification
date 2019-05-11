`timescale 1ns / 1ps
//****************************************************************//
//  File Name: top_level.v														//
//																						//
//  Created by Jacob Nguyen on 10/23/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Top level of Full UART with Tramelblaze			 		//
//				  implementation. 												//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module top_level(clk, reset, EIGHT, PEN, OHEL, RX, BAUD, TX, Led);
					  
	input clk, 			// clk 100MHz
			reset, 		// reset
			EIGHT,		// Read Eighth bit
			PEN,			// Parity Enable
			OHEL,			// Odd Hi / Even Lo Parity
			RX;			// Receive Data Signal for Rx Engine
			
			
	input [3:0] BAUD;	// Baud Rate Select
	
	wire reset_s,				// synchronous reset signal
		  UART_INTR,			// UART signal for interrupts
		  PED_to_SR,			// PED to Set and Reset
		  intr,					// Interrupt request
		  inta,					// Interrupt acknowledge
		  WRITE_STROBE,		// Write signal
		  READ_STROBE;			// Read signal
	
	wire [7:0]	UART_DATA;	// UART_DATA to IN_PORT of Tramelblaze
	
	wire [15:0] PORT_ID, 
					OUT_PORT,
					READS0,		// Address Decoder Lines
					WRITES0,
					READS1,
					WRITES1,
					READS2,
					WRITES2,
					READS3,
					WRITES3;	  
					
	// TSI I/O wires				
	wire clk_TSI,
		  reset_TSI,
		  EIGHT_TSI,
		  PEN_TSI,
		  OHEL_TSI,
		  RX_TSI,
		  TX_TSI;
	wire [3:0] BAUD_TSI;
	wire [7:0] LED_TSI;
					
	output 		  TX;	// Tx Signal
	output [7:0] Led;
	
	TSI TSI(
		.clk_I(clk),
		.button_I(reset),
		.switch_I({BAUD, EIGHT, PEN, OHEL}),
		.LED_I(LED_TSI),
		.RX_I(RX),
		.TX_I(TX_TSI),
		.clk_O(clk_TSI),
		.button_O(reset_TSI),
		.switch_O({BAUD_TSI, EIGHT_TSI, PEN_TSI, OHEL_TSI}),
		.LED_O(Led),
		.RX_O(RX_TSI),
		.TX_O(TX)
	);
	
	
	AISO AISO (
		.clk(clk_TSI), 
		.reset(reset_TSI), 
		.sync_rst(reset_s)
	);
	
	UART UART (
		.clk(clk_TSI),
		.reset(reset_s),
		.READ_DATA(READS0[0]), 
		.READ_STATUS(READS0[1]),
		.Tx_load(WRITES0[0]),
		.OUT_PORT_DATA(OUT_PORT),
		.BAUD(BAUD_TSI),
		.EIGHT(EIGHT_TSI),
		.PEN(PEN_TSI),
		.OHEL(OHEL_TSI),
		.RX(RX_TSI),
		.TX(TX_TSI),
		.UART_INTR(UART_INTR),
		.UART_DATA_OUT(UART_DATA)
	);
	
	SR_module sr (
		.clk(clk_TSI), 
		.reset(reset_s), 
		.s(UART_INTR), 
		.r(inta), 
		.q(intr)
	);
	
	tramelblaze_top tbt(
		.CLK(clk_TSI), 
		.RESET(reset_s), 
		.IN_PORT({8'b0, UART_DATA}), 
		.INTERRUPT(intr), 
      .OUT_PORT(OUT_PORT), 
		.PORT_ID(PORT_ID), 
		.READ_STROBE(READ_STROBE), 
		.WRITE_STROBE(WRITE_STROBE), 
		.INTERRUPT_ACK(inta)
	);
	
	adrs_decode adrs_decode (
		.PORT_ID(PORT_ID), 
		.READ_STROBE(READ_STROBE), 
		.WRITE_STROBE(WRITE_STROBE), 
		.READS0(READS0),
		.WRITES0(WRITES0),
		.READS1(READS1),
		.WRITES1(WRITES1),
		.READS2(READS2),
		.WRITES2(WRITES2),
		.READS3(READS3),
		.WRITES3(WRITES3)
	);
	
	reg8 r8 (
		.clk(clk),
		.reset(reset_s),
		.ld(WRITES0[1]),
		.d(OUT_PORT[7:0]),
		.q(LED_TSI)
	);
endmodule
