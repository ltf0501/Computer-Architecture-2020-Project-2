module EX_MEM(
	clk_i,
	start_i,

	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,
	MemRead_i,
	MemRead_o,
	MemWrite_i,
	MemWrite_o,

	ALU_i,
	ALU_o,

	MemWriteData_i,
	MemWriteData_o,

	RDaddr_i,
	RDaddr_o,
);

input clk_i, start_i;

input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;

input [31:0] ALU_i;
output reg [31:0] ALU_o;

input [31:0] MemWriteData_i;
output reg [31:0] MemWriteData_o;

input [4:0] RDaddr_i;
output reg [4:0] RDaddr_o;

always @(posedge clk_i or negedge start_i) begin
	if (!start_i) begin
		RegWrite_o <= 0;
		MemtoReg_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		ALU_o <= 0;
		MemWriteData_o <= 0;
		RDaddr_o <= 0;
	end
	else begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		ALU_o <= ALU_i;
		MemWriteData_o <= MemWriteData_i;
		RDaddr_o <= RDaddr_i;
	end
end

endmodule
