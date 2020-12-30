module CPU
(
	clk_i, 
	rst_i,
	start_i,

	mem_data_i, 
	mem_ack_i,
	mem_data_o,
	mem_addr_o,
	mem_enable_o,
	mem_write_o
);

input clk_i, start_i, rst_i;

input [255 : 0] mem_data_i;
input mem_ack_i;
output [255 : 0] mem_data_o;
output [31 : 0] mem_addr_o;
output mem_enable_o;
output mem_write_o;

wire mem_stall;

wire [31 : 0] IF_pc_in;
wire [31 : 0] IF_pc_out;
wire [31 : 0] IF_pc_add_out;
wire [31 : 0] IF_instruction;

wire pc_write;
wire Flush;
wire Stall;
wire [1 : 0] Forward_A;
wire [1 : 0] Forward_B;

wire ID_branch1;
wire ID_branch2;
wire [31 : 0] ID_instruction;
wire ID_reg_write;
wire ID_memto_reg;
wire ID_mem_read;
wire ID_mem_write;
wire [1 : 0] ID_ALU_op;
wire ID_ALU_src;
wire ID_no_op;
wire [31 : 0] ID_read_data1;
wire [31 : 0] ID_read_data2;
wire [31 : 0] ID_imm_gen_out;
wire [31 : 0] ID_add_in1;
wire [31 : 0] ID_add_in2;
wire [31 : 0] ID_add_out;

wire [2 : 0] EX_ALU_ctrl_out;
wire [9 : 0] EX_ALU_ctrl_in;
wire [1 : 0] EX_ALU_op;
wire [31 : 0] EX_ALU_input1;
wire [31 : 0] EX_ALU_input2;
wire [31 : 0] EX_ALU_result;
wire EX_mem_read;
wire [4 : 0] EX_rd;
wire EX_ALU_src;
wire [31 : 0] EX_write_data;
wire [31 : 0] EX_instruction;
wire EX_mem_write;
wire EX_memto_reg;
wire EX_reg_write;
wire [31 : 0] EX_read_data1;
wire [31 : 0] EX_read_data2;
wire [4 : 0] EX_rs1;
wire [4 : 0] EX_rs2;

wire [31 : 0] MEM_ALU_result;
wire [31 : 0] MEM_write_data;
wire MEM_mem_write;
wire MEM_mem_read;
wire [31 : 0] MEM_read_data;
wire MEM_reg_write;
wire MEM_memto_reg;
wire [4 : 0] MEM_rd;

wire WB_memto_reg;
wire [31 : 0] WB_write_data;
wire [31 : 0] WB_mux1;
wire [31 : 0] WB_mux2;
wire WB_reg_write;
wire [4 : 0] WB_rd;

PC PC(
	.clk_i (clk_i),
	.rst_i (rst_i),
	.start_i (start_i),
	.stall_i (mem_stall),
	.PCWrite_i (pc_write),
	.pc_i (IF_pc_in),
	.pc_o (IF_pc_out)
);

Instruction_Memory Instruction_Memory(
	.addr_i (IF_pc_out),
	.instr_o (IF_instruction)
);

And And(
	.data1_i (ID_branch1),
	.data2_i ((ID_read_data1 == ID_read_data2) ? 1'b1 : 1'b0),
	.data_o (Flush)
);

Sign_Extend Sign_Extend(
	.instr_i (ID_instruction),
	.data_o (ID_imm_gen_out)
);

Control Control(
	.Op_i (ID_instruction[6 : 0]),
	.NoOp_i (ID_no_op),
	.ALUOp_o (ID_ALU_op),
	.ALUSrc_o (ID_ALU_src),
	.Branch_o (ID_branch1),
	.MemRead_o (ID_mem_read),
	.MemWrite_o (ID_mem_write),
	.RegWrite_o (ID_reg_write),
	.MemtoReg_o (ID_memto_reg)
);

ALU_Control ALU_Control(
	.funct_i (EX_ALU_ctrl_in),
	.ALUOp_i (EX_ALU_op),
	.ALUCtrl_o (EX_ALU_ctrl_out)
);

ALU ALU(
	.data1_i (EX_ALU_input1),
	.data2_i (EX_ALU_input2),
	.ALUCtrl_i (EX_ALU_ctrl_out),
	.data_o (EX_ALU_result),
	.Zero_o ()
);

Hazard Hazard(
	.IDEX_MemRead_i (EX_mem_read),
	.IDEX_RDaddr_i (EX_rd),

	.IFID_RSaddr1_i (ID_instruction[19 : 15]),
	.IFID_RSaddr2_i (ID_instruction[24 : 20]),

	.PCwrite_o (pc_write),
	.Stall_o (Stall),
	.NoOp_o (ID_no_op)
);

Adder Adder_PC(
	.data1_in (IF_pc_out),
	.data2_in (4),
	.data_o (IF_pc_add_out)
);

Adder Adder_Branch(
	.data1_in (ID_imm_gen_out << 1),
	.data2_in (ID_add_in2),
	.data_o (ID_add_out)
);

MUX32 MUX_PC(
	.data1_i (IF_pc_add_out),
	.data2_i (ID_add_out),
	.select_i (Flush),
	.data_o (IF_pc_in)
);

MUX32 MUX_ALU(
	.data1_i (EX_write_data),
	.data2_i (EX_instruction),
	.select_i (EX_ALU_src),
	.data_o (EX_ALU_input2)
);

MUX32 MUX_WB(
	.data1_i (WB_mux1),
	.data2_i (WB_mux2),
	.select_i (WB_memto_reg),
	.data_o (WB_write_data)
);

MUX3 MUX3A(
	.data1_i (EX_read_data1),
	.data2_i (WB_write_data),
	.data3_i (MEM_ALU_result),
	.select_i (Forward_A),
	.data_o (EX_ALU_input1)
);

MUX3 MUX3B(
	.data1_i (EX_read_data2),
	.data2_i (WB_write_data),
	.data3_i (MEM_ALU_result),
	.select_i (Forward_B),
	.data_o (EX_write_data)
);


IF_ID IF_ID(
	.clk_i (clk_i),
	.start_i (start_i),
	.Stall_i (Stall | mem_stall),
	.Flush_i (Flush),
	.PC_i (IF_pc_out),
	.PC_o (ID_add_in2),
	.instr_i (IF_instruction),
	.instr_o (ID_instruction) 
);

ID_EX ID_EX(
	.clk_i (clk_i),
	.start_i (start_i),

	.stall_i (mem_stall),

	.instr_i ({ID_instruction[31 : 25], ID_instruction[14 : 12]}),
	.instr_o (EX_ALU_ctrl_in),

	.RegWrite_i (ID_reg_write),
	.RegWrite_o (EX_reg_write),
	.MemtoReg_i (ID_memto_reg),
	.MemtoReg_o (EX_memto_reg),
	.MemRead_i (ID_mem_read),
	.MemRead_o (EX_mem_read),
	.MemWrite_i (ID_mem_write),
	.MemWrite_o (EX_mem_write),
	.ALUOp_i (ID_ALU_op),
	.ALUOp_o (EX_ALU_op),
	.ALUSrc_i (ID_ALU_src),
	.ALUSrc_o (EX_ALU_src),

	.imm_i (ID_imm_gen_out),
	.imm_o (EX_instruction),

	.RDdata1_i (ID_read_data1),
	.RDdata1_o (EX_read_data1),
	.RDdata2_i (ID_read_data2),
	.RDdata2_o (EX_read_data2),

	.RSaddr1_i (ID_instruction[19 : 15]),
	.RSaddr1_o (EX_rs1),
	.RSaddr2_i (ID_instruction[24 : 20]),
	.RSaddr2_o (EX_rs2),
	.RDaddr_i (ID_instruction[11 : 7]),
	.RDaddr_o (EX_rd)
);

EX_MEM EX_MEM(
	.clk_i (clk_i),
	.start_i (start_i),

	.stall_i (mem_stall),

	.RegWrite_i (EX_reg_write),
	.RegWrite_o (MEM_reg_write),
	.MemtoReg_i (EX_memto_reg),
	.MemtoReg_o (MEM_memto_reg),
	.MemRead_i (EX_mem_read),
	.MemRead_o (MEM_mem_read),
	.MemWrite_i (EX_mem_write),
	.MemWrite_o (MEM_mem_write),

	.ALU_i (EX_ALU_result),
	.ALU_o (MEM_ALU_result),

	.MemWriteData_i (EX_write_data),
	.MemWriteData_o (MEM_write_data),

	.RDaddr_i (EX_rd),
	.RDaddr_o (MEM_rd)
);

Forward Forward(
	.EX_RSaddr1_i (EX_rs1),
	.EX_RSaddr2_i (EX_rs2),

	.Mem_RegWrite_i (MEM_reg_write),
	.Mem_RDaddr_i (MEM_rd),

	.WB_RegWrite_i (WB_reg_write),
	.WB_RDaddr_i (WB_rd),

	.selectA_o (Forward_A),
	.selectB_o (Forward_B)
);

Registers Registers(
    .clk_i (clk_i),

    .RS1addr_i (ID_instruction[19 : 15]),
    .RS2addr_i (ID_instruction[24 : 20]),

    .RDaddr_i (WB_rd), 
    .RDdata_i (WB_write_data),
    .RegWrite_i (WB_reg_write), 

    .RS1data_o (ID_read_data1), 
    .RS2data_o (ID_read_data2)
);

MEM_WB MEM_WB(
	.clk_i (clk_i),
	.start_i (start_i),

	.stall_i (mem_stall),

	.RegWrite_i (MEM_reg_write),
	.RegWrite_o (WB_reg_write),
	.MemtoReg_i (MEM_memto_reg),
	.MemtoReg_o (WB_memto_reg),

	.ALU_i (MEM_ALU_result),
	.ALU_o (WB_mux1),
	.MemReadData_i (MEM_read_data),
	.MemReadData_o (WB_mux2),

	.RDaddr_i (MEM_rd),
	.RDaddr_o (WB_rd)
);

dcache_controller dcache (
	// System clock, reset and stall
	.clk_i (clk_i), 
	.rst_i (rst_i),

	// to Data Memory interface        
	.mem_data_i (mem_data_i), 
	.mem_ack_i (mem_ack_i),     
	.mem_data_o (mem_data_o), 
	.mem_addr_o (mem_addr_o),     
	.mem_enable_o (mem_enable_o), 
	.mem_write_o (mem_write_o), 

	// to CPU interface    
	.cpu_data_i (MEM_write_data), 
	.cpu_addr_i (MEM_ALU_result),     
	.cpu_MemRead_i (MEM_mem_read), 
	.cpu_MemWrite_i (MEM_mem_write), 
	.cpu_data_o (MEM_read_data), 
	.cpu_stall_o (mem_stall)
);

//Data_Memory Data_Memory(
//	.clk_i (clk_i), 
//	.addr_i (MEM_ALU_result), 
//	.MemRead_i (MEM_mem_read),
//	.MemWrite_i (MEM_mem_write),
//	.data_i (MEM_write_data),
//	.data_o (MEM_read_data)
//);
endmodule 
