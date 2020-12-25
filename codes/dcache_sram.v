module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

reg [15 : 0] pos; // determine which set to put

wire [1 : 0] hit_tmp;

integer            i, j;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
assign hit_tmp[0] = (tag[addr_i][0][22:0] == tag_i[22:0] && tag[addr_i][0][24]) ? 1 : 0;
assign hit_tmp[1] = (tag[addr_i][1][22:0] == tag_i[22:0] && tag[addr_i][1][24]) ? 1 : 0;

always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
				pos <= 16'b0;
    end
    if (enable_i && write_i) begin
			// TODO: Handle your write of 2-way associative cache + LRU here 
			if (hit_tmp[0] == 1) pos[addr_i] = 1;
			else if (hit_tmp[1] == 1) pos[addr_i] = 0;
			else begin
				tag[addr_i][pos[addr_i]] <= tag_i;
				data[addr_i][pos[addr_i]] <= data_i;
				pos[addr_i] = pos[addr_i] ^ 1;
			end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
assign hit_o = hit_tmp[0] | hit_tmp[1];


assign hit_o = ((tag[addr_i][0][22:0] == tag_i[22:0] && tag[addr_i][0][24]) 
						 || (tag[addr_i][1][22:0] == tag_i[22:0] && tag[addr_i][1][24])) ? 1 : 0;

assign data_o = !enable_i ? 256'b0 : (
								hit_tmp[0] ? data[addr_i][0] : (hit_tmp[1] ? data[addr_i][1] : 256'b0)
								);

assign data_o = !enable_i ? 25'b0 : (
								hit_tmp[0] ? tag[addr_i][0] : (hit_tmp[1] ? tag[addr_i][1] : 25'b0)
								);
								
endmodule
