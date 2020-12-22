module MUX3(
	data1_i,
	data2_i,
	data3_i,

	select_i,
	data_o, 
);

input [31:0] data1_i, data2_i, data3_i;
input [1:0] select_i;
output [31:0] data_o;

reg [31:0] data_o;

always @(data1_i or data2_i or data3_i or select_i) begin
	case (select_i)
		2'b00: data_o = data1_i;
		2'b01: data_o = data2_i;
		2'b10: data_o = data3_i;
	endcase
end

endmodule
