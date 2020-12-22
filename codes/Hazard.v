module Hazard(
	IDEX_MemRead_i,
	IDEX_RDaddr_i,

	IFID_RSaddr1_i,
	IFID_RSaddr2_i,

	PCwrite_o,
	Stall_o,
	NoOp_o
);

input IDEX_MemRead_i;
input [4:0] IDEX_RDaddr_i, IFID_RSaddr1_i, IFID_RSaddr2_i;

output reg PCwrite_o, Stall_o, NoOp_o;

always @(IDEX_MemRead_i or IDEX_RDaddr_i or IFID_RSaddr1_i or IFID_RSaddr2_i) begin
	if (!IDEX_MemRead_i) begin
		PCwrite_o <= 1;
		Stall_o <= 0;
		NoOp_o <= 0;
	end
	else begin
		if((IDEX_RDaddr_i == IFID_RSaddr1_i || IDEX_RDaddr_i == IFID_RSaddr2_i)) begin
			PCwrite_o <= 0;
			Stall_o <= 1;
			NoOp_o <= 1; 
		end
		else begin
			PCwrite_o <= 1;
			Stall_o <= 0;
			NoOp_o <= 0;
		end
	end
end

endmodule
