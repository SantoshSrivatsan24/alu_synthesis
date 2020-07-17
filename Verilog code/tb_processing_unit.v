/* Test bench for processing unit module */
module tb_processing_unit;
	wire signed [15:0] tb_out;
	wire tb_overflow_flag;
	reg signed [15:0] tb_in_a, tb_in_b;
	reg [7:0] tb_opcode;

	parameter STOP_TIME = 200;
	
	/* Instantiating the circuit to be tested */
	processing_unit #(16) pu(tb_out, tb_overflow_flag, tb_in_a, tb_in_b, tb_opcode); 

	initial #STOP_TIME $finish;
	initial begin
		    tb_in_a = 16'sd5;  tb_in_b = 16'sd40; tb_opcode = 8'h08;
		#10 		       tb_in_b = 16'sd20; tb_opcode = 8'h09;
		#10 		       tb_in_b = 16'sd20; tb_opcode = 8'h0a;
		#10 		       tb_in_b = 16'sd20; tb_opcode = 8'h0b;
		#10  		       tb_in_b = 16'sd20; tb_opcode = 8'h0c;
		#10 		       tb_in_b = 16'sd20; tb_opcode = 8'h0d;
		#10 tb_in_a = 16'sd3;  tb_in_b = 16'sd5; tb_opcode = 8'h0e;
		#10 		       tb_in_b = 16'sd20; tb_opcode = 8'h0f;
		
	end
endmodule

