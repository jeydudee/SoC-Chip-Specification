`timescale 1ns / 1ps
//****************************************************************//
//  File Name: adrs_decode.v													//
//																						//
//  Created by Jacob Nguyen on 10/01/18.                          //
//  Copyright © 2018 Jacob Nguyen. All rights reserved.           //
//																						//
//	 Abstract: Decoder block for reading and writing data to and	//
//				  from the Tramelblaze. Consists of 4 16-bit Write		//
//				  lines and 4 16-bit Read line, for a total of 64 		//
//				  possible addresses to access memory. The decoder 	//
//				  block consists of two procedural blocks: one to 		//
//				  decode the specified address with sensitivity to		//
//				  PORT_ID[3:0], and the second to choose which one		//
//				  of the 4 Write OR Read lines (depending on the 		//
//				  Read and Write Strobes) with sensitivity to 			//
//				  PORT_ID[15:14].													//
//																						//
//  In submitting this file for class work at CSULB               //
//  I am confirming that this is my work and the work             //
//  of no one else. In submitting this code I acknowledge that 	//
//  plagiarism in student project work is subject to dismissal 	//
//  from the class 																//
//****************************************************************//
module adrs_decode(PORT_ID, READ_STROBE, WRITE_STROBE, 
						 READS0, WRITES0,
						 READS1, WRITES1,
						 READS2, WRITES2,
						 READS3, WRITES3);
	
	input [15:0] PORT_ID;
	input			 READ_STROBE, WRITE_STROBE;
	
	reg [15:0] ADRS;
	
	output reg [15:0] READS0, WRITES0,
							READS1, WRITES1,
							READS2, WRITES2,
							READS3, WRITES3;
	
	always @* begin
		case (PORT_ID[3:0])
			4'h0: ADRS = 16'h0001;
			4'h1: ADRS = 16'h0002;
			4'h2: ADRS = 16'h0004;
			4'h3: ADRS = 16'h0008;
			4'h4: ADRS = 16'h0010;
			4'h5: ADRS = 16'h0020;
			4'h6: ADRS = 16'h0040;
			4'h7: ADRS = 16'h0080;
			4'h8: ADRS = 16'h0100;
			4'h9: ADRS = 16'h0200;
			4'hA: ADRS = 16'h0400;
			4'hB: ADRS = 16'h0800;
			4'hC: ADRS = 16'h1000;
			4'hD: ADRS = 16'h2000;
			4'hE: ADRS = 16'h4000;
			4'hF: ADRS = 16'h8000;
			default: ADRS = 16'h0;
		endcase
	end
	
	always @* begin
		
		// default signal
		{READS0, WRITES0} = 32'h0;
		{READS1, WRITES1} = 32'h0;
		{READS2, WRITES2} = 32'h0;
		{READS3, WRITES3} = 32'h0;
		
		case (PORT_ID[15:14])
			2'b00:
				begin
					if (READ_STROBE)  READS0  = ADRS;  else
					if (WRITE_STROBE) WRITES0 = ADRS; 
				end
			2'b01:
				begin
					if (READ_STROBE)  READS1  = ADRS;  else
					if (WRITE_STROBE) WRITES1 = ADRS; 
				end
			2'b10:
				begin
					if (READ_STROBE)  READS2  = ADRS;  else
					if (WRITE_STROBE) WRITES2 = ADRS; 
				end
			2'b11:
				begin
					if (READ_STROBE)  READS3  = ADRS;  else
					if (WRITE_STROBE) WRITES3 = ADRS; 
				end
			default:
				begin
					if (READ_STROBE)  READS0  = ADRS;  else
					if (WRITE_STROBE) WRITES0 = ADRS; 
				end
		endcase
	end

endmodule
