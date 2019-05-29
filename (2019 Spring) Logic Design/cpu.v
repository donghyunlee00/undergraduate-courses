`timescale 1ns/1ps

//Machine code layout

/*
Jump:	00 [offset 6b]
Load:	01 [rt] [rs] [off] -> rt = rs[off]
Loading to any register should update tb_data of TB wiring (Handled by TA).

Store: 	10 [rs] [rd] [off] -> rd[off] = rs

Arith:	11 [op] [rd] [rs]
	11 00 NOP
	11 01 ADD	rd += rs
	11 10 SUB	rd -= rs
	11 11 NOP
*/


module cpu	//Do not change top module name or ports.
(
	input	clk,
	input	areset,

	output	[7:0] imem_addr,	//Request instruction memory
	input	[7:0] imem_data,	//Returns 

	output	[7:0] tb_data		//Testbench wiring.
);

	//Data memory and testbench wiring. you may rename them if you like.
	wire dmem_write;
	wire [7:0] dmem_addr, dmem_write_data, dmem_read_data;
	
	//Data memory module in tb.v.
	memory dmem(	.clk(clk), .areset(areset),
			.write(dmem_write), .addr(dmem_addr),
			.write_data(dmem_write_data), .read_data(dmem_read_data));

	assign tb_data = dmem_read_data;
	//Testbench wiring end.

	//Write your code here.

endmodule

