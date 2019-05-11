`timescale 1ns / 1ps

//****************************************************************//
//  File Name: top_level_tb.v													//
//																						//
//  Created by Jacob Nguyen on 10/23/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Test Fixture for Full UART w/ TramelBlaze 				//
//				  implementation. 												//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//

module top_level_tb;

	// Inputs
	reg clk;
	reg reset;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg RX;
	reg [3:0] BAUD;

	// Outputs
	wire TX;
	wire [7:0] Led;

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.reset(reset), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL),
		.RX(RX),
		.BAUD(BAUD), 
		.TX(TX), 
		.Led(Led)
	);

	always #5 clk = ~clk;
	
	reg [0:0] mem [0:999_999];
	integer i, old_i, new_i, j;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		EIGHT = 1;
		PEN = 0;
		OHEL = 0;
		RX	= 1;
		BAUD = 4'b1011;

		// Add stimulus here
		@(negedge clk)
			reset = 1;
		@(negedge clk)
			reset = 0;
			
		$readmemb("output.txt", mem);
		mem_dump;	
		old_i = 0;
		new_i = old_i + 7 + EIGHT + PEN;
		
		#700_000
		for (j=0; j<6; j=j+1) begin
			#1085
			RX = 0; // start bit
			for (i=old_i; i<new_i; i = i+1) begin
				#1085
				RX = mem[i];
			end
			old_i = new_i;
			new_i = new_i + 7 + EIGHT + PEN;
			#1085
			RX = 1; // stop bit
		end
		
	end
	
	task mem_dump;
		for (i=0; i<48; i = i+1) begin
			$display("mem[%d]: %b", i, mem[i]);
		end
   endtask
	
endmodule

