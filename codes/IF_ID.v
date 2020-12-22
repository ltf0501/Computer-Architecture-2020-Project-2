module IF_ID(
	clk_i,
	start_i, 

	Stall_i,
	Flush_i,

	PC_i,
	PC_o,

	instr_i, 
	instr_o
);

input clk_i, start_i;
input Stall_i, Flush_i;

input [31:0] PC_i;
output reg [31:0] PC_o;

input [31:0] instr_i;
output reg [31:0] instr_o;


always @(posedge clk_i or negedge start_i) begin
	if (!start_i || Flush_i) begin
		PC_o <= 32'b0;
		instr_o <= 32'b0;
	end
	else begin
		if(Stall_i) begin // stall
			PC_o <= PC_o;
			instr_o <= instr_o;
		end
		else begin
			PC_o <= PC_i;
			instr_o <= instr_i;
		end
	end
end

endmodule
