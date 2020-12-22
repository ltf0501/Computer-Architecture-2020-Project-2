module Control
(
	Op_i,
	NoOp_i,
	ALUOp_o,
	ALUSrc_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemtoReg_o
);

input  [6 : 0] Op_i;
input          NoOp_i;
output reg [1 : 0] ALUOp_o;
output reg         ALUSrc_o;
output reg         Branch_o;
output reg         MemRead_o;
output reg         MemWrite_o;
output reg         RegWrite_o;
output reg         MemtoReg_o;


always@(*) begin
	if (NoOp_i) begin
		ALUOp_o = 2'b00;
		ALUSrc_o = 0;
		Branch_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		RegWrite_o = 0;
		MemtoReg_o = 0; 
	end
	else begin
    case (Op_i)
        7'b0010011: begin // addi srai
					ALUOp_o = 2'b01;
					ALUSrc_o = 1;
					Branch_o = 0;
					MemRead_o = 0;
					MemWrite_o = 0;
					RegWrite_o = 1;
					MemtoReg_o = 0;
        end

        7'b0110011: begin // and xor sll add sub mul
					ALUOp_o = 2'b00;
					ALUSrc_o = 0;
					Branch_o = 0;
					MemRead_o = 0;
					MemWrite_o = 0;
					RegWrite_o = 1;
					MemtoReg_o = 0;
        end

				7'b0000011: begin // lw
					ALUOp_o = 2'b00;
					ALUSrc_o = 1;
					Branch_o = 0;
					MemRead_o = 1;
					MemWrite_o = 0;
					RegWrite_o = 1;
					MemtoReg_o = 1; 
				end

				7'b0100011: begin // sw
					ALUOp_o = 2'b00;
					ALUSrc_o = 1;
					Branch_o = 0;
					MemRead_o = 0;
					MemWrite_o = 1;
					RegWrite_o = 0;
					MemtoReg_o = 0; 
				end

				7'b1100011: begin // beq
					ALUOp_o = 2'b00;
					ALUSrc_o = 0;
					Branch_o = 1;
					MemRead_o = 0;
					MemWrite_o = 0;
					RegWrite_o = 0;
					MemtoReg_o = 0; 
				end

        default: begin
					ALUOp_o = 2'b00;
					ALUSrc_o = 0;
					Branch_o = 0;
					MemRead_o = 0;
					MemWrite_o = 0;
					RegWrite_o = 0;
					MemtoReg_o = 0; 
        end
    endcase
	end
end

endmodule
