module Forward(
	EX_RSaddr1_i,
	EX_RSaddr2_i,

	Mem_RegWrite_i,
	Mem_RDaddr_i,

	WB_RegWrite_i,
	WB_RDaddr_i,

	selectA_o,
	selectB_o 
);

input [4:0] EX_RSaddr1_i, EX_RSaddr2_i, Mem_RDaddr_i, WB_RDaddr_i;
input Mem_RegWrite_i, WB_RegWrite_i;

output [1:0] selectA_o, selectB_o;
reg [1:0] selectA_o, selectB_o;

always @(EX_RSaddr1_i or EX_RSaddr2_i or Mem_RegWrite_i or Mem_RDaddr_i or WB_RegWrite_i or WB_RDaddr_i) begin
	if (Mem_RegWrite_i && Mem_RDaddr_i != 0 && Mem_RDaddr_i == EX_RSaddr1_i) // EX hazard
		selectA_o = 2'b10;
	else if(WB_RegWrite_i && WB_RDaddr_i != 0 && WB_RDaddr_i == EX_RSaddr1_i) // Mem hazard
		selectA_o = 2'b01;
	else
		selectA_o = 2'b00;

	if (Mem_RegWrite_i && Mem_RDaddr_i != 0 && Mem_RDaddr_i == EX_RSaddr2_i) // EX hazard
		selectB_o = 2'b10;
	else if(WB_RegWrite_i && WB_RDaddr_i != 0 && WB_RDaddr_i == EX_RSaddr2_i) // Mem hazard
		selectB_o = 2'b01;
	else
		selectB_o = 2'b00;
end 

endmodule
