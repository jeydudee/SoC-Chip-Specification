`timescale 1ns / 1ps
//****************************************************************//
//  File Name: RECEIVE_ENGINE.v												//
//																						//
//  Created by Jacob Nguyen on 10/23/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract:	Top level block of the Receive Engine for UART.		//
//					The goal of the Rx Engine is to synchronize the 	//
//					data collection with the Tx communication. The 		//
//					Rx Engine is always polling the Rx input and 		//
//					looking for a high-to-low transition, indicating	//
//					the arrival of a start bit. The Rx Engine also		//
//					detects any errors when processing the data such	//
//					as framing error, parity error, and overflow.		//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module RECEIVE_ENGINE(clk, reset, BAUD_K, BAUD_KD2, EIGHT, PEN, OHEL, RX, CLR,
							RX_RDY, P_ERR, F_ERR, OVF, RX_DATA);
	
	input clk, 
			reset,
			EIGHT,
			PEN,
			OHEL,
			RX,
			CLR;
			
	input [18:0] BAUD_K, BAUD_KD2;
	
	output RX_RDY,
			 P_ERR,
			 F_ERR,
			 OVF;
			 
	output [7:0] RX_DATA;
	
	wire RX_RDY,	
		  BTU,
		  DONE,
		  DONED1,
		  START,
		  DOIT,
		  DOIT1,
		  shift,
		  P_GEN,
		  P_RECEIVE,
		  P_ERR_D,
		  P_ERR_S,
		  STOP_BIT,
		  F_ERR_S,
		  OVF_S;
	
	wire [3:0] BC_VAL;	
	wire [9:0] SHIFT_REG;
	wire [9:0] REMAP_DATA;
	wire [18:0]	BAUD_COMPARE;
	
	assign BAUD_COMPARE = (START == 1'b1) ? BAUD_KD2 : BAUD_K;
	assign DOIT1 = (DOIT & ~START);
	assign shift = (BTU & ~START);
	
	assign P_GEN = ({EIGHT, OHEL} == 2'b00) ? (^REMAP_DATA[6:0]):
						({EIGHT, OHEL} == 2'b01) ? (~^REMAP_DATA[6:0]):
						({EIGHT, OHEL} == 2'b10) ? (^REMAP_DATA[7:0]):
						({EIGHT, OHEL} == 2'b11) ? (~^REMAP_DATA[7:0]):
															(^REMAP_DATA[6:0]);
	assign P_RECEIVE = (EIGHT == 1'b1) ? REMAP_DATA[8] : REMAP_DATA[7];	
	assign P_ERR_D = (P_GEN ^ P_RECEIVE);
	assign P_ERR_S = (PEN & P_ERR_D & DONE);

	assign STOP_BIT = ({EIGHT, PEN} == 2'b00) ? REMAP_DATA[7]:
							({EIGHT, PEN} == 2'b01) ? REMAP_DATA[8]:
							({EIGHT, PEN} == 2'b10) ? REMAP_DATA[8]:
							({EIGHT, PEN} == 2'b11) ? REMAP_DATA[9]:
															  REMAP_DATA[7];
															  
	assign F_ERR_S = (DONE & ~STOP_BIT);
	assign OVF_S = (DONE & RX_RDY);
	
	assign RX_DATA = (EIGHT == 1'b1) ? 			 REMAP_DATA[7:0]:
												  {1'b0, REMAP_DATA[6:0]};
	Rx_State_Machine RxSM(
		.clk(clk), 
		.reset(reset), 
		.RX(RX), 
		.BTU(BTU), 
		.DONE(DONE), 
		.START(START), 
		.DOIT(DOIT)
	);
	
	BIT_TIME_COUNTER BTC (
		.clk(clk),
		.reset(reset), 
		.compare(BAUD_COMPARE), 
		.DOIT(DOIT),  
		.BTU_out(BTU)
	);
	
	BIT_COUNTER_DECODE BCD (
		.SEL({EIGHT, PEN}),
		.COUNT_VAL(BC_VAL)
	);
		
	BIT_COUNTER_RX BC_RX (
		.clk(clk),
		.reset(reset),
		.compare(BC_VAL),
		.DOIT(DOIT1),
		.BTU(BTU),
		.BIT_COUNTER_UP(DONE)
	);
	
	d_flipflop dff3 (
		.clk(clk),
		.reset(reset),
		.d(DONE),
		.q(DONED1)
	);
	
	shift_reg shr (
		.clk(clk),
		.reset(reset),
		.shift(shift),
		.SDI(RX),
		.shift_reg(SHIFT_REG)
	);
	
	REMAPPING RMP (
		.DATA_IN(SHIFT_REG),
		.EIGHT(EIGHT),
		.PEN(PEN),
		.DATA_OUT(REMAP_DATA)
	);
	
	SR_module RX_RDY_Q (
		.clk(clk),
		.reset(reset),
		.s(DONED1),
		.r(CLR),
		.q(RX_RDY)
	);
	
	SR_module P_ERR_Q (
		.clk(clk),
		.reset(reset),
		.s(P_ERR_S),
		.r(CLR),
		.q(P_ERR)
	);
	
	SR_module F_ERR_Q (
		.clk(clk),
		.reset(reset),
		.s(F_ERR_S),
		.r(CLR),
		.q(F_ERR)
	);
	
	SR_module OVF_Q (
		.clk(clk),
		.reset(reset),
		.s(OVF_S),
		.r(CLR),
		.q(OVF)
	);
endmodule
