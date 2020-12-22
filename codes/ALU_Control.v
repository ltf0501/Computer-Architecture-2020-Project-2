module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [2:0]   ALUCtrl_o;

wire [2:0]  funct3;
wire [6:0]  funct7;

reg [2:0] ALUCtrl_reg;

assign funct3       = funct_i[2:0];
assign funct7       = funct_i[9:3];
assign ALUCtrl_o    = ALUCtrl_reg;

always@(*) begin
    case (ALUOp_i)
        2'b01: begin // addi srai
            case (funct3)
                3'b000: ALUCtrl_reg = 3'b110; // addi
                3'b101: ALUCtrl_reg = 3'b111; // srai
            endcase
        end
        2'b00: begin // and xor sll add sub mul
            case (funct3)
                3'b100: ALUCtrl_reg = 3'b001; // xor
                3'b111: ALUCtrl_reg = 3'b000; // and
                3'b001: ALUCtrl_reg = 3'b010; // sll
                3'b000: begin
                    case (funct7)
                        7'b0100000: ALUCtrl_reg = 3'b100; // sub
                        7'b0000000: ALUCtrl_reg = 3'b011; // add
                        7'b0000001: ALUCtrl_reg = 3'b101; // mul
                    endcase
                end
								3'b010: ALUCtrl_reg = 3'b011; // sw, lw
            endcase
        end
        default: ALUCtrl_reg = 3'b000;
    endcase
end
endmodule
