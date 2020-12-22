module Sign_Extend
(
    instr_i,
    data_o
);

input   [31:0]  instr_i;
output  [31:0]  data_o;
reg [11:0] tmp;
reg [31:0] data_o;

always @(*) begin
	if (instr_i[6:0] == 7'b0100011) begin // sw
		tmp = {instr_i[31:25], instr_i[11:7]};
	end
	else if (instr_i[6:0] == 7'b1100011) begin // beq
		tmp = {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};
	end
	else begin
		tmp = instr_i[31:20];
	end 
	data_o = { { 20{tmp[11]} } , tmp[11:0]};
end

endmodule
