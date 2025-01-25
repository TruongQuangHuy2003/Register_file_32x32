`timescale 1ns/1ps
module test_bench;
	reg clk;
    	reg rst_n;
	reg ce;
	reg rd_en1;
	reg rd_en2;
	reg [4:0] rd_addr1;
	reg [4:0] rd_addr2;
	reg wr_en;
	reg [4:0] wr_addr;
	reg [31:0] wr_data;
	wire [31:0] rd_data1;
	wire [31:0] rd_data2;
	
	register_file dut(.*);	

	parameter CLK_PERIOD = 5;
	integer i;
	integer rad_data;
	
	task write_data;
		input [4:0] exp_wr_addr;
		input [31:0] exp_wr_data;
		begin
			wr_en = 1;
			wr_addr = exp_wr_addr;
			wr_data = exp_wr_data;
			@(posedge clk);
			wr_en = 0;
		end
	endtask

	task read_data;
		input exp_rd_en1;
		input exp_rd_en2;
		input [4:0] exp_rd_addr1;
		input [4:0] exp_rd_addr2;
		begin
			rd_en1 = exp_rd_en1;
			rd_en2 = exp_rd_en2;
			rd_addr1 = exp_rd_addr1;
			rd_addr2 = exp_rd_addr2;
			@(posedge clk);
		end
	endtask

	task verify;
		input [31:0] exp_rd_data1;
		input [31:0] exp_rd_data2;
		begin
			$display("At time: %t, ce = 1'b%b, rd_en1 = 1'b%b, rd_en2 = 1'b%b, rd_addr1 = 5'b%b, rd_addr2 = 5'b%b, wr_en = 1'b%b, wr_data = 32'h%h",$time, ce, rd_en1, rd_en2, rd_addr1, rd_addr2, wr_en, wr_addr, wr_data);
			if (rd_data1 == exp_rd_data1 && rd_data2 == exp_rd_data2) begin
				$display("--------------------------------------------------------------------------------------------------------------------------------");
				$display("PASSED: Expected data1: 32'h%h, Got data1: 32'h%h, Expected_data2: 32'h%h, Got data2:32'h%h", exp_rd_data1, rd_data1, exp_rd_data2, rd_data2);
				$display("--------------------------------------------------------------------------------------------------------------------------------");
			end else begin
				$display("--------------------------------------------------------------------------------------------------------------------------------");
				$display("FAILED: Expected data1: 32'h%h, Got data1: 32'h%h, Expected_data2: 32'h%h, Got data2:32'h%h", exp_rd_data1, rd_data1, exp_rd_data2, rd_data2);
				$display("--------------------------------------------------------------------------------------------------------------------------------");
			end
		end
	endtask

	initial begin
		clk = 0;
		forever #CLK_PERIOD clk = ~clk;
	end

	initial begin
		$dumpfile("test_bench.vcd");
		$dumpvars(0, test_bench);

		$display("--------------------------------------------------------------------------------------------------------------------------------------------------");
		$display("-------------------------------------------------TESTBENCH FOR REGISTER FILE 32X32----------------------------------------------------------------");
		$display("--------------------------------------------------------------------------------------------------------------------------------------------------");
		
		rst_n = 0;
		@(posedge clk);
		verify(32'h00000000, 32'h00000000);
		
		rst_n = 1;
		ce = 0;
		@(posedge clk);
		write_data(5'b00000, 32'hffffffff);
		read_data(1,1,5'b00000, 5'b00001);
		verify(32'h00000000, 32'h00000000);
		
		ce = 1;
		@(posedge clk);
		write_data(5'b00000, 32'hffffffff);
		read_data(1,0,5'b00000, 5'b00001);
		verify(32'hffffffff, 32'h00000000);

		for (i = 0; i < 32; i = i + 1) begin
			rad_data = $urandom % (1 << 31);
			write_data(i, rad_data);
			read_data(1,0,i, 5'b00000);
			verify(rad_data, 32'h00000000);
		end
		for (i = 0; i < 32; i = i + 1) begin
			rad_data = $urandom % (1 << 31);
			write_data(i, rad_data);
			read_data(0,1,5'b00000,i);
			verify(32'h00000000,rad_data);
		end
		#100;
		$finish;
	end
endmodule

