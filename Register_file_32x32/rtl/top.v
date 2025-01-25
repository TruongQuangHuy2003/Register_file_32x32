module register_file (
	input wire clk,
	input wire rst_n,
	input wire ce,
	input wire rd_en1,
	input wire rd_en2,
	input wire [4:0] rd_addr1,
	input wire [4:0] rd_addr2,
	input wire wr_en,
	input wire [4:0] wr_addr,
	input wire [31:0] wr_data,
	output reg [31:0] rd_data1,
	output reg [31:0] rd_data2
);

// Mang thanh ghi: 32 thanh ghi, moi thanh ghi rong 32 bit
reg [31:0] reg_file[31:0];
integer i;

// Cong doc co dieu kien (kich hoat boi chip enable va read enable)
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rd_data1 <= 32'h00000000;
		rd_data2 <= 32'h00000000;
	end else begin
		rd_data1 <= (ce && rd_en1) ? reg_file[rd_addr1] : 32'h00000000;
		rd_data2 <= (ce && rd_en2) ? reg_file[rd_addr2] : 32'h00000000;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		for (i = 0; i < 32; i = i + 1) begin
			reg_file[i] <= 32'h00000000;
		end
	end else begin
		reg_file[wr_addr] <= (ce && wr_en) ? wr_data : reg_file[wr_addr];
	end
end

endmodule

