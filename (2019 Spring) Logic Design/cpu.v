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

	//PC module
	wire [7:0] sign_ext;
	wire jump;

	program_counter pc(	.clk(clk), .areset(areset),
			.imem_addr(imem_addr), .sign_ext(sign_ext),
			.jump(jump), .pc_addr(imem_addr));
/*
	//Register file module
	wire write_enable, write_data, read_data1, read_data2;
	wire [1:0] read_reg1, read_reg2, write_reg;

	register_file reg_file(	.clk(clk), .areset(areset),
			.write_enable(write_enable),
			.read_reg1(read_reg1), .read_reg2(read_reg2),
			.write_reg(write_reg), .write_data(write_data),
			.read_data1(read_data1), .read_data2(read_data2));

	//Control logic module
*/

endmodule

module program_counter
(
	input	clk,
	input	areset,
	
	input	[7:0] imem_addr,
	input	[7:0] sign_ext,
	input	jump,

	output	[7:0] pc_addr
);
	reg [7:0] curr_pc_addr;
	reg [7:0] new_pc_addr;

	always @(posedge clk)
	begin
		if(jump)
			new_pc_addr <= imem_addr + sign_ext;
		else
			new_pc_addr <= imem_addr + 8'h01;

		if(areset)
			curr_pc_addr <= 8'h00;
		else
			curr_pc_addr <= new_pc_addr;
	end

	assign pc_addr = curr_pc_addr;

endmodule

/*
module register_file
(
	input	clk,
	input	areset,

	input	write_enable,

	input	[7:0] instr,
	input	mem_write,
	input	reg_dst,

	input	read_data,
	input	//

	output	read_data1, read_data2
);
	reg [1:0] regs[3:0];

	always @(posedge clk)
	begin
		if(areset)
		begin
			regs[0] <= 2'b00;
			regs[1] <= 2'b00;
			regs[2] <= 2'b00;
			regs[3] <= 2'b00;
		end
		else if(write_enable)
		begin
			regs[write_reg] <= write_data;
		end
	end

	assign read_data1 = regs[read_reg1];
	assign read_data2 = regs[read_reg2];

endmodule

module control_logic
(
	input	[7:0] instr,
	
	output	alu_src,
	output	alu_op,
	output	mem_write,
	output	reg_dst,
	output	mem_to_reg,
	output	reg_write,
	output	jump
);

	always @(instr)
	begin
		// TODO
	end

endmodule

module sign_extension_unit
(

);

endmodule

module alu
(

);

endmodule

module data_memory
(

);

endmodule

module isa
(

);

endmodule