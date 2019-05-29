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

	//mux1
	wire [7:0] off_sign_ext, selected_off;
	wire jump;

	multiplexer_8bit mux1(	.i0(8'h01), .i1(off_sign_ext), .s(jump),
			.y(selected_off));
	
	//mux2
	wire [7:0] added_pc_addr, new_pc_addr;

	multiplexer_8bit mux2(	.i0(added_pc_addr), .i1(8'h00), .s(areset),
			.y(new_pc_addr));
	
	//mux3
	wire [7:0] instr;
	wire mem_write;
	wire [1:0] reg_read_addr2;

	multiplexer_2bit mux3(	.i0(instr[1:0]), .i1(instr[5:4]), .s(mem_write),
			.y(reg_read_addr2));

	assign instr = imem_data;

	//mux4
	wire reg_dst;
	wire [1:0] reg_write_addr;

	multiplexer_2bit mux4(	.i0(instr[5:4]), .i1(instr[3:2]), .s(reg_dst),
			.y(reg_write_addr));

	//mux5
	wire [7:0] reg_read_data2, alu_b;
	wire alu_src;

	multiplexer_8bit mux5(	.i0(off_sign_ext), .i1(reg_read_data2), .s(alu_src),
			.y(alu_b));
	
	assign reg_read_data2 = dmem_write_data;
	
	//mux6
	wire mem_to_reg;
	wire [7:0] reg_write_data;

	multiplexer_8bit mux6(	.i0(dmem_addr), .i1(dmem_read_data), .s(mem_to_reg),
			.y(reg_write_data));
	
	//add
	wire [7:0] pc_addr;

	adder add(	.a(pc_addr), .b(selected_off),
			.s(added_pc_addr));

	assign pc_addr = imem_addr;

	//pc
	program_counter pc(	.clk(clk), .new_addr(new_pc_addr),
			.addr(pc_addr));
	
	//reg
	wire reg_write;
	wire [1:0] reg_read_addr1;
	wire [7:0] reg_read_data1;

	register_file reg(	.clk(clk), .areset(areset),
			.write_enable(reg_write),
			.read_reg1(reg_read_addr1), .read_reg2(reg_read_addr2),
			.write_reg(reg_write_addr), .write_data(reg_write_data),
			.read_data1(reg_read_data1), .read_data2(reg_read_data2));

	assign reg_read_addr1 = instr[3:2];

	//ctrl
	wire [1:0] ctrl_mode, ctrl_opcode;
	wire alu_op;

	control_logic ctrl(	.mode(ctrl_mode), .opcode(ctrl_opcode),
			.jump(jump),
			.alu_src(alu_src), .alu_op(alu_op),
			.mem_write(mem_write), .reg_dst(reg_dst), .mem_to_reg(mem_to_reg),
			.reg_write(reg_write));

	assign ctrl_mode = instr[7:6];
	assign ctrl_opcode = instr[5:4];
	assign mem_write = dmem_write;

	//sign_ext
	wire [5:0] off;

	sign_extension_unit sign_ext(	.in(off), .jump(jump),
			.out(off_sign_ext));

	assign off = instr[5:0];

	//alu
	wire [7:0] alu_a, alu_out;

	arithmetic_logic_unit alu(	.a(alu_a), .b(alu_b), .op(alu_op),
			.out(alu_out));

	assign alu_a = reg_read_data1;
	assign alu_out = dmem_addr;

endmodule

module multiplexer_8bit
(
	input	[7:0] i0,
	input	[7:0] i1,
	input	s,

	output	[7:0] y
);

	assign y = s ? i1 : i0;

endmodule

module multiplexer_2bit
(
	input	[1:0] i0,
	input	[1:0] i1,
	input	s,

	output	[1:0] y
);

	assign y = s ? i1 : i0;

endmodule

module adder
(
	input	[7:0] a,
	input	[7:0] b,

	output	[7:0] s
);

	assign s = a + b;

endmodule

module program_counter
(
	input	clk,
	input	[7:0] new_addr,

	output	[7:0] addr
);
	reg [7:0] curr_addr;

	always @(posedge clk)
	begin
		curr_addr <= new_addr;
	end

	assign addr = curr_addr;

endmodule

module register_file
(
	input	clk,
	input	areset,

	input	write_enable,
	input	[1:0] read_reg1,
	input	[1:0] read_reg2,
	input	[1:0] write_reg,
	input	[7:0] write_data,

	output	[7:0] read_data1,
	output	[7:0] read_data2
);
	reg [7:0] regs[3:0];

	always @(posedge clk)
	begin
		if(areset)
		begin
			regs[0] <= 0;
			regs[1] <= 0;
			regs[2] <= 0;
			regs[3] <= 0;
		end
		else if(write_enable)
			regs[write_reg] <= write_data;
	end

	assign read_data1 = regs[read_reg1];
	assign read_data2 = regs[read_reg2];

endmodule

module control_logic
(
	input	[1:0] mode,
	input	[1:0] opcode,

	output	jump,
	output	alu_src,
	output	alu_op,
	output	mem_write,
	output	reg_dst,
	output	mem_to_reg,
	output	reg_write
);

	reg _jump, _alu_src, _alu_op, _mem_write, _reg_dst, _mem_to_reg, _reg_write;

	always @(mode, opcode)
	begin
		if(mode == 2'b11 && opcode == 2'b01) //Add
		begin
			_jump <= 0;
			_alu_src <= 1;
			_alu_op <= 1;
			_mem_write <= 0;
			_reg_dst <= 1;
			_mem_to_reg <= 0;
			_reg_write <= 1;
		end
		else if(mode == 2'b11 && opcode == 2'b10) //Sub
		begin
			_jump <= 0;
			_alu_src <= 1;
			_alu_op <= 0;
			_mem_write <= 0;
			_reg_dst <= 1;
			_mem_to_reg <= 0;
			_reg_write <= 1;
		end
		else if(mode == 2'b01) //Load
		begin
			_jump <= 0;
			_alu_src <= 0;
			_alu_op <= 1;
			_mem_write <= 0;
			_reg_dst <= 0;
			_mem_to_reg <= 1;
			_reg_write <= 1;
		end
		else if(mode == 2'b10) //Store
		begin
			_jump <= 0;
			_alu_src <= 0;
			_alu_op <= 1;
			_mem_write <= 1;
			_reg_write <= 0;
		end
		else if(mode == 2'b00) //Jump
		begin
			_jump <= 1;
			_mem_write <= 0;
			_reg_write <= 0;
		end
	end

	assign jump = _jump;
	assign alu_src = _alu_src;
	assign alu_op = _alu_op;
	assign mem_write = _mem_write;
	assign reg_dst = _reg_dst;
	assign mem_to_reg = _mem_to_reg;
	assign reg_write = _reg_write;

endmodule

module sign_extension_unit
(
	input	[5:0] in,
	input	jump,

	output	[7:0] out
);

	assign out = jump ? {{2{in[5]}}, in} : {{6{in[1]}}, in[1:0]};

endmodule

module arithmetic_logic_unit
(
	input	[7:0] a,
	input	[7:0] b,
	input	op,

	output	[7:0] out
);
	reg [7:0] _out;

	always @(a, b, op)
	begin
		case(op)
		0: _out <= a + b;
		1: _out <= a - b;
		endcase
	end

	assign out = _out;

endmodule