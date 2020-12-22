module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input signed    [31:0]      data1_i;
input           [31:0]      data2_i;
input           [2:0]       ALUCtrl_i;
output          [31:0]      data_o;
output                      Zero_o;

reg signed [31:0]   result;
reg                 Zero_reg;

assign data_o = result;
assign Zero_o = Zero_reg;

always@(*) begin
    case (ALUCtrl_i)
        3'b111:
            result = $signed(data1_i) >>> data2_i[4:0];
        3'b010:
            result = data1_i << data2_i[4:0];
        3'b101:
            result = data1_i * data2_i;
        3'b100:
            result = data1_i - data2_i;
        3'b110:
            result = data1_i + data2_i;
        3'b000:
            result = data1_i & data2_i;
        3'b001:
            result = data1_i ^ data2_i;
        3'b011:
            result = data1_i + data2_i;
        default:
            result = data1_i + data2_i;
    endcase
    Zero_reg = (result == 0) ? 1 : 0;
end

endmodule
