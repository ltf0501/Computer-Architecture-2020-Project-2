module ID_EX(
	clk_i,
	start_i,

	instr_i,
	instr_o,

	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,
	MemRead_i,
	MemRead_o,
	MemWrite_i,
	MemWrite_o,
	ALUOp_i,
	ALUOp_o,
	ALUSrc_i,
	ALUSrc_o,

	imm_i,
	imm_o,

	RDdata1_i,
	RDdata1_o,
	RDdata2_i,
	RDdata2_o,

	RSaddr1_i,
	RSaddr1_o,
	RSaddr2_i,
	RSaddr2_o,
	RDaddr_i,
	RDaddr_o
);

input clk_i, start_i;

input [9:0] instr_i;
output reg [9:0] instr_o;

input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
input [1:0] ALUOp_i;
output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;
output reg [1:0] ALUOp_o;

input [31:0] imm_i;
output reg [31:0] imm_o;

input [31:0] RDdata1_i, RDdata2_i;
output reg [31:0] RDdata1_o, RDdata2_o;

input [4:0] RSaddr1_i, RSaddr2_i, RDaddr_i;
output reg [4:0] RSaddr1_o, RSaddr2_o, RDaddr_o;

always @(posedge clk_i or negedge start_i) begin
	if (!start_i) begin
		instr_o <= 0;
		RegWrite_o <= 0;
		MemtoReg_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		ALUOp_o <= 0;
		ALUSrc_o <= 0;
		imm_o <= 0;
		RDdata1_o <= 0;
		RDdata2_o <= 0;
		RSaddr1_o <= 0;
		RSaddr2_o <= 0;
		RDaddr_o <= 0;
	end
	else begin
		instr_o <= instr_i;
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		ALUOp_o <= ALUOp_i;
		ALUSrc_o <= ALUSrc_i;
		imm_o <= imm_i;
		RDdata1_o <= RDdata1_i;
		RDdata2_o <= RDdata2_i;
		RSaddr1_o <= RSaddr1_i;
		RSaddr2_o <= RSaddr2_i;
		RDaddr_o <= RDaddr_i;
	end
end 

endmodule
