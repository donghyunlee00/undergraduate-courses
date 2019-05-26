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
	wire [7:0] pc_addr, instr_sign_ext;
	wire jump;

	program_counter pc(	.clk(clk), .areset(areset),
			.pc_addr(pc_addr), .instr_sign_ext(instr_sign_ext),
			.jump(jump), .addr(pc_addr));

	assign imem_addr = pc_addr;

	//Register file module
	wire reg_write, mem_write, reg_dst, mem_to_reg;
	wire [7:0] instr, reg_read_data1, reg_read_data2;

	register_file reg_file(	.clk(clk), .areset(areset),
			.write_enable(reg_write), .instr(instr),
			.mem_write(mem_write), .reg_dst(reg_dst),
			.dmem_read_data(dmem_read_data), .dmem_addr(dmem_addr),
			.mem_to_reg(mem_to_reg), .read_data1(reg_read_data1),
			.read_data2(reg_read_data2));

	assign dmem_write = mem_write;
	assign imem_data = instr;
	assign dmem_write_data = reg_read_data2;

	//Control logic module
	//TODO

	//Sign extension unit module
	sign_extension_unit sign_ext(	.instr(instr), .jump(jump),
			.instr_sign_ext(instr_sign_ext));

	//Arithmetic logic unit module
	//TODO

endmodule

module program_counter
(
	input	clk,
	input	areset,
	
	input	[7:0] pc_addr,
	input	[7:0] instr_sign_ext,
	input	jump,

	output	[7:0] addr
);
	reg [7:0] curr_addr;
	wire [7:0] new_addr;

	always @(posedge clk)
	begin
		if(areset)
			curr_addr <= 8'h00;
		else
			curr_addr <= new_addr;
	end

	assign new_addr = (jump ? pc_addr + instr_sign_ext : pc_addr + 8'h01);
	assign addr = curr_addr;

endmodule

module register_file
(
	input	clk,
	input	areset,

	input	write_enable,

	input	[7:0] instr,
	input	mem_write,
	input	reg_dst,

	input	[7:0] dmem_read_data,
	input	[7:0] dmem_addr,
	input	mem_to_reg,

	output	[7:0] read_data1, read_data2
);
	reg [1:0] regs[3:0];
	wire [1:0] read_reg1, read_reg2, write_reg;

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
			if(mem_to_reg)
				regs[write_reg] <= dmem_read_data;
			else
				regs[write_reg] <= dmem_addr;
		end
	end

	assign read_reg1 = instr[3:2];
	assign read_reg2 = (mem_write ? instr[5:4] : instr[1:0]);
	assign write_reg = (reg_dst ? instr[3:2] : instr[5:4]);

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
	input	[7:0] instr,
	input	jump,

	output	[7:0] instr_sign_ext
);

	assign instr_sign_ext = (jump ? {{2{instr[5]}}, instr[5:0]} : {{6{instr[1]}}, instr[1:0]});

endmodule

module arithmetic_logic_unit
(

);

endmodule