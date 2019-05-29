`timescale 1ns / 1ps

//Please set tab width to 8.
module tb
(
	input clk,		//P57

	input btn0,		//P47
	input btn1,		//P48
	input btn2,		//P49

	output green_light,	//P90
	output orange_light,	//P88
	output red_light,	//P87
	

				// 0   1   2   3   4   5   6
	output [6:0] disp_0,	//P03, 04, 05, 06, 07, 08, 10
	output [6:0] disp_1,	//P11, 12, 13, 15, 16, 18, 19
	output [6:0] disp_2,	//P20, 21, 24, 25, 27, 28, 29
	output [6:0] disp_3,	//P55, 58, 59, 60, 62, 63, 64
	output [6:0] disp_4,	//P68, 69, 70, 71, 72, 75, 76
	output [6:0] disp_5	//P77, 78, 79, 82, 83, 84, 85

);

	wire areset;

	assign areset = (btn0 | btn1 | btn2);

	wire [7:0] imem_data;
	wire [7:0] imem_addr;
	wire [7:0] tb_data;  

	// Instantiate the Unit Under Test (UUT)
	cpu uut (
		.clk(clk), 
		.areset(areset), 
		.imem_addr(imem_addr), 
		.imem_data(imem_data), 
		.tb_data(tb_data)
	);


	reg [2:0] test_level;			
	reg [7:0] tester_memory[(3 << 6) - 1:0];

	reg test_phase;		
	reg [7:0] cycle_count;  
	reg [7:0] accumulator;	
	reg [7:0] n_errors;	

	wire [7:0] tester_arithop;
	wire [7:0] tester_memop;
	wire [7:0] tester_instruction;

	wire [1:0] jmp, load, store, arith;
	wire [1:0] add, sub, nop;
	wire [1:0] r0, r1, r2, r3;

	assign jmp = 2'b00;
	assign load = 2'b01;
	assign store = 2'b10;
	assign arith = 2'b11;

	assign add = 2'b01;
	assign sub = 2'b10;
	assign nop = 2'b11;

	assign r0 = 2'b00;
	assign r1 = 2'b01;
	assign r2 = 2'b10;
	assign r3 = 2'b11;

	always @(posedge clk)
	begin
		if(areset)
		begin
			test_phase <= 0;
			accumulator <= 0;
			n_errors <= 0;
			cycle_count <= 0;

			test_level <= btn0 ? 3'b000 : (btn1 ? 3'b001 : 3'b010);	//Template distribution (3 levels)
			//------------------------------Level 0------------------------------
			
			tester_memory[0]	<= 8'b11110000;	//NOP		
			tester_memory[1]	<= {load, r0, r1, 2'b00};	
			tester_memory[2]	<= {load, r2, r1, 2'b00};	
			tester_memory[3]	<= {arith, add, r0, r0};	
			tester_memory[4]	<= {arith, add, r0, r0};	
			tester_memory[5]	<= {arith, add, r0, r0};	
			tester_memory[6]	<= {arith, add, r0, r0};	
			tester_memory[7]	<= {arith, add, r0, r0};	
			tester_memory[8]	<= {arith, add, r0, r2};	
			tester_memory[9]	<= {arith, add, r0, r2};	
			tester_memory[10]	<= {store, r0, r2, 2'b00};	
			tester_memory[11]	<= {load, r0, r2, 2'b00};	
			tester_memory[12]	<= 8'b00000000;
			tester_memory[13]	<= 8'b00000000;
			tester_memory[14]	<= 8'b00000000;
			tester_memory[15]	<= 8'b00000000;
			tester_memory[16]	<= 8'b00000000;
			tester_memory[17]	<= 8'b00000000;
			tester_memory[18]	<= 8'b00000000;
			tester_memory[19]	<= 8'b00000000;
			tester_memory[20]	<= 8'b00000000;
			tester_memory[21]	<= 8'b00000000;
			tester_memory[22]	<= 8'b00000000;
			tester_memory[23]	<= 8'b00000000;
			tester_memory[24]	<= 8'b00000000;
			tester_memory[25]	<= 8'b00000000;
			tester_memory[26]	<= 8'b00000000;
			tester_memory[27]	<= 8'b00000000;
			tester_memory[28]	<= 8'b00000000;
			tester_memory[29]	<= 8'b00000000;
			tester_memory[30] 	<= 8'b00000000;
			tester_memory[31] 	<= 8'b00000000;

			tester_memory[32 + 0]	<= 8'h01;
			tester_memory[32 + 1]	<= 8'h22;
			tester_memory[32 + 2]	<= 8'h03; 
			tester_memory[32 + 3]	<= 8'h04; 
			tester_memory[32 + 4]	<= 8'h05; 
			tester_memory[32 + 5]	<= 8'h06; 
			tester_memory[32 + 6]	<= 8'h07; 
			tester_memory[32 + 7]	<= 8'h08; 
			tester_memory[32 + 8]	<= 8'h09; 
			tester_memory[32 + 9]	<= 8'h10; 
			tester_memory[32 + 10]	<= 8'h11; 
			tester_memory[32 + 11]	<= 8'h12; 
			tester_memory[32 + 12]	<= 8'h13; 
			tester_memory[32 + 13]	<= 8'h14; 
			tester_memory[32 + 14]	<= 8'h15; 
			tester_memory[32 + 15]	<= 8'h16; 
			tester_memory[32 + 16]	<= 8'h17; 
			tester_memory[32 + 17]	<= 8'h18; 
			tester_memory[32 + 18]	<= 8'h19; 
			tester_memory[32 + 19]	<= 8'h20; 
			tester_memory[32 + 20]	<= 8'h21; 
			tester_memory[32 + 21]	<= 8'h22; 
			tester_memory[32 + 22]	<= 8'h23; 
			tester_memory[32 + 23]	<= 8'h24; 
			tester_memory[32 + 24]	<= 8'h25; 
			tester_memory[32 + 25]	<= 8'h26; 
			tester_memory[32 + 26]	<= 8'h27; 
			tester_memory[32 + 27]	<= 8'h28; 
			tester_memory[32 + 28]	<= 8'h29; 
			tester_memory[32 + 29]	<= 8'h30; 
			tester_memory[32 + 30]	<= 8'h31; 
			tester_memory[32 + 31]	<= 8'h32; 


			//------------------------------Level 1------------------------------
			tester_memory[(2 << 5) + 0]	<= 8'b11110000;
			tester_memory[(2 << 5) + 1]	<= 8'b11110000;
			tester_memory[(2 << 5) + 2]	<= {load, r0, r1, 2'b00};
			tester_memory[(2 << 5) + 3]	<= {jmp, 6'h0d};	 
			tester_memory[(2 << 5) + 4]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 5]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 6]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 7]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 8]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 9]	<= 8'b00000000;
			tester_memory[(2 << 5) + 10]	<= {load, r0, r2, 2'b00};
			tester_memory[(2 << 5) + 11]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 12]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 13]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 14]	<= 8'b00000000;	
			tester_memory[(2 << 5) + 15]	<= {jmp, 6'h41};		
			tester_memory[(2 << 5) + 16]	<= {load, r2, r1, 2'b00};	
			tester_memory[(2 << 5) + 17]	<= {arith, add, r0, r0};	
			tester_memory[(2 << 5) + 18]	<= {arith, add, r0, r0};	
			tester_memory[(2 << 5) + 19]	<= {arith, add, r0, r0};	
			tester_memory[(2 << 5) + 20]	<= {arith, add, r0, r0};	
			tester_memory[(2 << 5) + 21]	<= {arith, add, r0, r0};	
			tester_memory[(2 << 5) + 22]	<= {arith, add, r2, r2};	
			tester_memory[(2 << 5) + 23]	<= {arith, add, r0, r2};	
			tester_memory[(2 << 5) + 24]	<= {arith, add, r2, r2};	
			tester_memory[(2 << 5) + 25]	<= {store, r0, r2, 2'b00};	
			tester_memory[(2 << 5) + 26]	<= {jmp, 6'h30};		
			tester_memory[(2 << 5) + 27]	<= 8'b00000000;
			tester_memory[(2 << 5) + 28]	<= 8'b00000000;
			tester_memory[(2 << 5) + 29]	<= 8'b00000000;
			tester_memory[(2 << 5) + 30] 	<= 8'b00000000;
			tester_memory[(2 << 5) + 31] 	<= 8'b00000000;

			tester_memory[(3 << 5) + 0]	<= 8'h01;
			tester_memory[(3 << 5) + 1]	<= 8'h02;
			tester_memory[(3 << 5) + 2]	<= 8'h03;
			tester_memory[(3 << 5) + 3]	<= 8'h04;
			tester_memory[(3 << 5) + 4]	<= 8'h22;
			tester_memory[(3 << 5) + 5]	<= 8'h06;
			tester_memory[(3 << 5) + 6]	<= 8'h07;
			tester_memory[(3 << 5) + 7]	<= 8'h08;
			tester_memory[(3 << 5) + 8]	<= 8'h09;
			tester_memory[(3 << 5) + 9]	<= 8'h10;
			tester_memory[(3 << 5) + 10]	<= 8'h11;
			tester_memory[(3 << 5) + 11]	<= 8'h12;
			tester_memory[(3 << 5) + 12]	<= 8'h13;
			tester_memory[(3 << 5) + 13]	<= 8'h14;
			tester_memory[(3 << 5) + 14]	<= 8'h15;
			tester_memory[(3 << 5) + 15]	<= 8'h16;
			tester_memory[(3 << 5) + 16]	<= 8'h17;
			tester_memory[(3 << 5) + 17]	<= 8'h18;
			tester_memory[(3 << 5) + 18]	<= 8'h19;
			tester_memory[(3 << 5) + 19]	<= 8'h20;
			tester_memory[(3 << 5) + 20]	<= 8'h21;
			tester_memory[(3 << 5) + 21]	<= 8'h22;
			tester_memory[(3 << 5) + 22]	<= 8'h23;
			tester_memory[(3 << 5) + 23]	<= 8'h24;
			tester_memory[(3 << 5) + 24]	<= 8'h25;
			tester_memory[(3 << 5) + 25]	<= 8'h26;
			tester_memory[(3 << 5) + 26]	<= 8'h27;
			tester_memory[(3 << 5) + 27]	<= 8'h28;
			tester_memory[(3 << 5) + 28]	<= 8'h29;
			tester_memory[(3 << 5) + 29]	<= 8'h30;
			tester_memory[(3 << 5) + 30]	<= 8'h31;
			tester_memory[(3 << 5) + 31]	<= 8'h32;

			//------------------------------Level 2------------------------------
			tester_memory[(4 << 5) + 0]	<= {8'hff};			
			tester_memory[(4 << 5) + 1]	<= {load, r0, r0, 2'b01};
			tester_memory[(4 << 5) + 2]	<= {load, r1, r0, 2'b00};
			tester_memory[(4 << 5) + 3]	<= {load, r2, r1, 2'b01};
			tester_memory[(4 << 5) + 4]	<= {arith, add, r2, r1};	
			tester_memory[(4 << 5) + 5]	<= {load, r3, r2, 2'b10};
			tester_memory[(4 << 5) + 6]	<= {arith, add, r3, r2};	
			tester_memory[(4 << 5) + 7]	<= {store, r0, r2, 2'b01};	
			tester_memory[(4 << 5) + 8]	<= {arith, add, r2, r3};
			tester_memory[(4 << 5) + 9]	<= {store, r2, r0, 2'b01};
			tester_memory[(4 << 5) + 10]	<= {arith, add, r2, r3};
			tester_memory[(4 << 5) + 11]	<= {arith, add, r1, r1};	
			tester_memory[(4 << 5) + 12]	<= {arith, sub, r2, r1};
			tester_memory[(4 << 5) + 13]	<= {store, r2, r1, 2'b00};	
			tester_memory[(4 << 5) + 14]	<= {arith, add, r2, r0};
			tester_memory[(4 << 5) + 15]	<= {store, r2, r1, 2'b01};	
			tester_memory[(4 << 5) + 16]	<= {load, r2, r3, 2'b01};
			tester_memory[(4 << 5) + 17] 	<= {store, r1, r2, 2'b01};
			tester_memory[(4 << 5) + 18] 	<= {load, r3, r1, 2'b01};	
			tester_memory[(4 << 5) + 19]	<= {8'hff};
			tester_memory[(4 << 5) + 20]	<= {8'hff};
			tester_memory[(4 << 5) + 21]	<= {8'hff};
			tester_memory[(4 << 5) + 22]	<= {8'hff};
			tester_memory[(4 << 5) + 23]	<= {8'hff};
			tester_memory[(4 << 5) + 24]	<= {8'hff};
			tester_memory[(4 << 5) + 25]	<= {8'hff};
			tester_memory[(4 << 5) + 26]	<= {8'hff};
			tester_memory[(4 << 5) + 27]	<= {8'hff};
			tester_memory[(4 << 5) + 28]	<= {8'hff};
			tester_memory[(4 << 5) + 29]	<= {8'hff};
			tester_memory[(4 << 5) + 30] 	<= {8'hff};
			tester_memory[(4 << 5) + 31] 	<= {8'hff};

			tester_memory[(5 << 5) + 0]	<= 8'h01;
			tester_memory[(5 << 5) + 1]	<= 8'h02;
			tester_memory[(5 << 5) + 2]	<= 8'h03;
			tester_memory[(5 << 5) + 3]	<= 8'h17;
			tester_memory[(5 << 5) + 4]	<= 8'h05;
			tester_memory[(5 << 5) + 5]	<= 8'h06;
			tester_memory[(5 << 5) + 6]	<= 8'h20;
			tester_memory[(5 << 5) + 7]	<= 8'h22;
			tester_memory[(5 << 5) + 8]	<= 8'h09;
			tester_memory[(5 << 5) + 9]	<= 8'h02;
			tester_memory[(5 << 5) + 10]	<= 8'h11;
			tester_memory[(5 << 5) + 11]	<= 8'h12;
			tester_memory[(5 << 5) + 12]	<= 8'h13;
			tester_memory[(5 << 5) + 13]	<= 8'h14;
			tester_memory[(5 << 5) + 14]	<= 8'h15;
			tester_memory[(5 << 5) + 15]	<= 8'h16;
			tester_memory[(5 << 5) + 16]	<= 8'h17;
			tester_memory[(5 << 5) + 17]	<= 8'h18;
			tester_memory[(5 << 5) + 18]	<= 8'h19;
			tester_memory[(5 << 5) + 19]	<= 8'h20;
			tester_memory[(5 << 5) + 20]	<= 8'h21;
			tester_memory[(5 << 5) + 21]	<= 8'h22;
			tester_memory[(5 << 5) + 22]	<= 8'h23;
			tester_memory[(5 << 5) + 23]	<= 8'h24;
			tester_memory[(5 << 5) + 24]	<= 8'h06;
			tester_memory[(5 << 5) + 25]	<= 8'h26;
			tester_memory[(5 << 5) + 26]	<= 8'h27;
			tester_memory[(5 << 5) + 27]	<= 8'h28;
			tester_memory[(5 << 5) + 28]	<= 8'h29;
			tester_memory[(5 << 5) + 29]	<= 8'h30;
			tester_memory[(5 << 5) + 30]	<= 8'h31;
			tester_memory[(5 << 5) + 31]	<= 8'h32;
			
		end
		else if(test_phase == 1)
		begin
			if(accumulator[0] && (tester_memory[(test_level << 6) | 8'b00100000 | {4'h0, accumulator[5:1]}] != tb_data))
			begin
				n_errors <= n_errors + 1;
			end
			accumulator <= accumulator + (accumulator[6] ? 0 : 1);
		end
		else if(tb_data == 8'h22 | cycle_count == 8'd100)
		begin
			test_phase <= 1;
		end
		else
		begin
			cycle_count <= cycle_count + 1;
		end
	end
	
	assign tester_arithop = (accumulator < 2 ? 8'b11100000 : 8'b11010001 );
	assign tester_memop = (accumulator < 2 ? 8'b01010000  : 8'b01100000);
	assign tester_instruction = (accumulator[6] ? 8'b11000000 : (accumulator[0] ? tester_memop : tester_arithop));
	assign imem_data = (test_phase ? tester_instruction : (imem_addr < 32 ? tester_memory[(test_level << 6) | imem_addr] : 8'b11000000));

	assign orange_light = test_phase ? 0 : 1;
	assign green_light = (n_errors && test_phase) ? 0 : 1;
	assign red_light = n_errors ? 1 : 0;

	display seven_seg(	.clk(clk), .areset(areset),
				.test_phase(test_phase),
				.test_level(test_level),
				.n_errors(n_errors),
				.disp_0(disp_0),
				.disp_1(disp_1),
				.disp_2(disp_2),
				.disp_3(disp_3),
				.disp_4(disp_4),
				.disp_5(disp_5));

endmodule

module memory
(
	input clk,
	input areset,

	input write,	//0 : read mode, 1 : write mode
	input [7:0] addr,
	input [7:0] write_data,
	
	output [7:0] read_data
);
	reg [7:0] data_memory[31:0];	//32 bytes.

	always @(posedge clk)
	begin
		if(areset)
		begin
			data_memory[0]	<= 8'h01;
			data_memory[1]	<= 8'h02; 
			data_memory[2]	<= 8'h03; 
			data_memory[3]	<= 8'h04; 
			data_memory[4]	<= 8'h05; 
			data_memory[5]	<= 8'h06; 
			data_memory[6]	<= 8'h07; 
			data_memory[7]	<= 8'h08; 
			data_memory[8]	<= 8'h09; 
			data_memory[9]	<= 8'h10; 
			data_memory[10]	<= 8'h11; 
			data_memory[11]	<= 8'h12; 
			data_memory[12]	<= 8'h13; 
			data_memory[13]	<= 8'h14; 
			data_memory[14]	<= 8'h15; 
			data_memory[15]	<= 8'h16; 
			data_memory[16]	<= 8'h17; 
			data_memory[17]	<= 8'h18; 
			data_memory[18]	<= 8'h19; 
			data_memory[19]	<= 8'h20; 
			data_memory[20]	<= 8'h21; 
			data_memory[21]	<= 8'h22; 
			data_memory[22]	<= 8'h23; 
			data_memory[23]	<= 8'h24; 
			data_memory[24]	<= 8'h25; 
			data_memory[25]	<= 8'h26; 
			data_memory[26]	<= 8'h27; 
			data_memory[27]	<= 8'h28; 
			data_memory[28]	<= 8'h29; 
			data_memory[29]	<= 8'h30; 
			data_memory[30] <= 8'h31; 
			data_memory[31] <= 8'h32; 
			
		end
		else if(write != 0)
		begin
			data_memory[addr] <= write_data;
		end
	end

	assign read_data = (write || addr > 32) ? 8'hff : data_memory[addr];

endmodule


module display
(
	input clk,
	input areset,
	input test_phase,
	input [2:0] test_level,
	input [7:0] n_errors,

	output reg[6:0] disp_0,
	output reg[6:0] disp_1,
	output reg[6:0] disp_2,
	output reg[6:0] disp_3,
	output reg[6:0] disp_4,
	output reg[6:0] disp_5 
);

	reg [24:0] clk_accumulator;
	
	wire [4:0] string_length;
	reg [4:0] flow_accumulator;

	reg [7:0] success_msg[15:0];
	reg [7:0] failed_msg[15:0];

	wire [7:0] test_level_decoded;
	wire [7:0] err_count_decoded[1:0];

	always @(posedge clk)
	begin
		if(areset)
		begin
			flow_accumulator <= 0;
			clk_accumulator <= 0;

			success_msg[0]	<= 8'b00001110;	
			success_msg[1]	<= 8'b01001111;	
			success_msg[2]	<= 8'b00011110;	
			success_msg[3]	<= 8'b01001111;	
			success_msg[4]	<= 8'b00001110;	
			success_msg[5]	<= 8'b00000000;	
			success_msg[6]	<= 8'b00000000;	
			success_msg[7]	<= 8'b00000000;	
			success_msg[8]	<= 8'b01100111;	
			success_msg[9]	<= 8'b01110111;	
			success_msg[10]	<= 8'b01011011;	
			success_msg[11]	<= 8'b01011011;	
			success_msg[12]	<= 8'b01001111;	
			success_msg[13]	<= 8'b00111101;	
			success_msg[14]	<= 8'b00001000;	
			success_msg[15]	<= 8'b00000000;
			
			failed_msg[0]	<= 8'b00001110;	
			failed_msg[1]	<= 8'b00000000;	
			failed_msg[2]	<= 8'b00000000;	
			failed_msg[3]	<= 8'b01000111;	
			failed_msg[4]	<= 8'b01110111;	
			failed_msg[5]	<= 8'b00000110;	
			failed_msg[6]	<= 8'b00001110;	
			failed_msg[7]	<= 8'b01001111;	
			failed_msg[8]	<= 8'b00111101;	
			failed_msg[9]	<= 8'b00001000;	
			failed_msg[10]	<= 8'b00001000;	
			failed_msg[11]	<= 8'b01001110;	
			failed_msg[12]	<= 8'b00000000;	
			failed_msg[13]	<= 8'b00000000;	
			failed_msg[14]	<= 8'b01111000;	
			failed_msg[15]	<= 8'b00000000;	
			
		end
		else
		begin
			if(clk_accumulator[24])
			begin
				success_msg[6] <= test_level_decoded;
				failed_msg[1] <= test_level_decoded;
				failed_msg[12] <= err_count_decoded[0];
				failed_msg[13] <= err_count_decoded[1];

				flow_accumulator <= ((flow_accumulator + 1) & string_length);
				clk_accumulator <= 0;

				disp_0 <= n_errors ? failed_msg[(flow_accumulator + 0) & string_length][6:0] : success_msg[(flow_accumulator + 0) & string_length][6:0];
				disp_1 <= n_errors ? failed_msg[(flow_accumulator + 1) & string_length][6:0] : success_msg[(flow_accumulator + 1) & string_length][6:0];
				disp_2 <= n_errors ? failed_msg[(flow_accumulator + 2) & string_length][6:0] : success_msg[(flow_accumulator + 2) & string_length][6:0];
				disp_3 <= n_errors ? failed_msg[(flow_accumulator + 3) & string_length][6:0] : success_msg[(flow_accumulator + 3) & string_length][6:0];
				disp_4 <= n_errors ? failed_msg[(flow_accumulator + 4) & string_length][6:0] : success_msg[(flow_accumulator + 4) & string_length][6:0];
				disp_5 <= n_errors ? failed_msg[(flow_accumulator + 5) & string_length][6:0] : success_msg[(flow_accumulator + 5) & string_length][6:0];
			end
			else
			begin
				clk_accumulator <= clk_accumulator + 1;
			end

		end
	end

	assign string_length = (test_phase << 3) | 4'b0111;

	wire [3:0] errcnt_i0;
	wire [7:0] errcnt_i1;
	
	assign errcnt_i0 = (n_errors < 10 ? 4'h0 : (n_errors < 20 ? 4'h1 : (n_errors < 30 ? 4'h2 : 4'h3)));
	assign errcnt_i1 = n_errors - (n_errors < 10 ? 8'h00 : (n_errors < 20 ? 8'h0A : (n_errors < 30 ? 8'h14 : 8'h1E)));
	
	num_to_sevenseg test_level_decoder(.ipt({1'b0, test_level}), .opt(test_level_decoded));
	num_to_sevenseg err_count_decoder0(.ipt(errcnt_i0), .opt(err_count_decoded[0]));
	num_to_sevenseg err_count_decoder1(.ipt(errcnt_i1[3:0]), .opt(err_count_decoded[1]));
	
endmodule

module num_to_sevenseg
(
	input [3:0] ipt,
	output [7:0] opt
);

	assign opt = 	(ipt == 4'h0 ? 8'b01111110 :
			(ipt == 4'h1 ? 8'b00110000 :
			(ipt == 4'h2 ? 8'b01101101 :
			(ipt == 4'h3 ? 8'b01111001 :
			(ipt == 4'h4 ? 8'b00110011 :
			(ipt == 4'h5 ? 8'b01011011 :
			(ipt == 4'h6 ? 8'b01011111 :
			(ipt == 4'h7 ? 8'b01110010 :
			(ipt == 4'h8 ? 8'b01111111 :
			(ipt == 4'h9 ? 8'b01111011 : 8'h00))))))))));

endmodule
