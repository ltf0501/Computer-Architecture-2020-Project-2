module MEM_WB(
	clk_i,
	start_i,

	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,

	ALU_i,
	ALU_o,
	MemReadData_i,
	MemReadData_o,

	RDaddr_i,
	RDaddr_o
);

input clk_i, start_i;

input RegWrite_i, MemtoReg_i;
output reg RegWrite_o, MemtoReg_o;

input [31:0] ALU_i, MemReadData_i;
output reg [31:0] ALU_o, MemReadData_o;

input [4:0] RDaddr_i;
output reg [4:0] RDaddr_o;

always @(posedge clk_i or negedge start_i) begin
	if (!start_i) begin
		RegWrite_o <= 0;
		MemtoReg_o <= 0;
		ALU_o <= 0;
		MemReadData_o <= 0;
		RDaddr_o <= 0;
	end
	else begin
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		ALU_o <= ALU_i;
		MemReadData_o <= MemReadData_i;
		RDaddr_o <= RDaddr_i;
	end
end

endmodule
