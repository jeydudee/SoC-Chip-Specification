`timescale 1ns / 1ps
//****************************************************************//
//  File Name: UART.v															//
//																						//
//  Created by Jacob Nguyen on 10/23/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: A complete UART module with both a Receive and		//
//				  Transmit Engine. The UART allows for both engines	//
//				  to share the same configurations such as baud rate,	//
//				  eighth bit enable, parity enable, and odd/even 		//
//				  parity. It supports full duplex serial 					//
//				  communication. The module also includes 				//
//				  supplmental logic such as baud rate decoder 			//
//				  generating k and k/2, a mux selecting between			//
//				  UART data and UART status, and the TX_RDY and 		//
//				  RX_RDY being fed through PED circuits to generate	//
//				  interrupt signals to the Tramelblaze.					//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module UART(clk, reset, READ_DATA, READ_STATUS, Tx_load, OUT_PORT_DATA, BAUD, 
				EIGHT, PEN, OHEL, RX, TX, UART_INTR, UART_DATA_OUT);
	
	input 		clk, 
					reset,
					READ_DATA,		// Select line to read Rx Data. Also clears Status flops
					READ_STATUS,	// Select line to read Status Register
					Tx_load,			// Initializes Tx
					EIGHT, 				
					PEN, 
					OHEL,
					RX;				// Rx input
	input [3:0] BAUD;			
	input [7:0] OUT_PORT_DATA;	// Data coming from OUT_PORT[7:0] of Tramelblaze
	
	output 	  		TX, UART_INTR;
	output [7:0]	UART_DATA_OUT;	// Data fed to IN_PORT[7:0] of Tramelblaze
	
	wire [18:0] BAUD_RATE,		// Count value for specified Baud Rate
					BAUD_KD2;		// Count value divided by 2
	wire [7:0]	RX_DATA,			// Receive Engine Data
					UART_STATUS;	//	UART Status Register
	
	// Status flops
	wire RX_RDY,
		  TX_RDY,
		  RX_RDY_PULSE,	// RX_RDY After PED
		  TX_RDY_PULSE,	// TX_RDY After PED
		  P_ERR,
		  F_ERR,
		  OVF;
	
	
	assign BAUD_KD2 		= (BAUD_RATE >> 1);
	assign UART_STATUS   = {3'b0, OVF, F_ERR, P_ERR, 	TX_RDY, RX_RDY};
	assign UART_DATA_OUT = (READ_DATA 	== 1'b1) ? RX_DATA :
								  (READ_STATUS == 1'b1) ? UART_STATUS :
																  8'b0;
	assign UART_INTR	   = (RX_RDY_PULSE | TX_RDY_PULSE);
	
	BAUD_DECODE BD (
		.BAUD(BAUD),
		.BAUD_RATE(BAUD_RATE)
	);
	
	TRANSMIT_ENGINE Tx_Engine(
		.clk(clk),
		.reset(reset),
		.load(Tx_load),
		.BAUD_K(BAUD_RATE),
		.EIGHT(EIGHT),
		.PEN(PEN),
		.OHEL(OHEL),
		.OUT_PORT_DATA(OUT_PORT_DATA),
		.TX_RDY(TX_RDY),
		.TX(TX)
	);
	
	RECEIVE_ENGINE Rx_Engine(
	.clk(clk), 
	.reset(reset), 
	.BAUD_K(BAUD_RATE), 
	.BAUD_KD2(BAUD_KD2), 
	.EIGHT(EIGHT), 
	.PEN(PEN), 
	.OHEL(OHEL), 
	.RX(RX),
	.CLR(READ_DATA),
	.RX_RDY(RX_RDY), 
	.P_ERR(P_ERR), 
	.F_ERR(F_ERR),
	.OVF(OVF), 
	.RX_DATA(RX_DATA)
	);
	
	PED ped_rx (
		.clk(clk),
		.reset(reset),
		.d_in(RX_RDY),
		.d_out(RX_RDY_PULSE)
	);
	
	PED ped_tx (
		.clk(clk),
		.reset(reset),
		.d_in(TX_RDY),
		.d_out(TX_RDY_PULSE)
	);
endmodule
