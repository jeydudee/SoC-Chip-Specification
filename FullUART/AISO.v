`timescale 1ns / 1ps
//****************************************************************//
//  File Name: AISO.v															//
//																						//
//  Created by Jacob Nguyen on 09/10/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//  Abstract: AISO (a.k.a. asynchronous in, synchronous out)      //
//				  is used to prevent the effects of metastability     //
//				  caused by the reset button. It involves the use     //
//				  of a synchronization flop in order to sync reset    //
//				  with the rest of the design.                        //
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module AISO(clk, reset, sync_rst);

	input clk, 			// clk
			reset;		// reset
			
	output sync_rst;	//synchronous reset
	
	reg q_meta,			// synchonization flop
		 q_ok;			// "ok" flop
	
	always @ (posedge clk, posedge reset)
		if (reset) begin
			q_meta <= 1'b0;
			q_ok 	 <= 1'b0;
		end
		else begin
			q_meta <= 1'b1;	 // Vcc
			q_ok 	 <= q_meta;
		end
			
	/*
		invert the sync reset so that when the flops get reset, reset signal
		to the system is 1.
	 */
	assign sync_rst = ~q_ok;


endmodule
