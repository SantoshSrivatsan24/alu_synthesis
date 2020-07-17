/* Author: Santosh Srivatsan */
/* ID: 2017A8PS1924G */

/* Processing unit module */
module processing_unit
	#(	
	parameter LENGTH = 16
	)
	(
	output reg signed [LENGTH - 1: 0] out,
	output reg overflow_flag,
	input signed [LENGTH - 1 : 0] in_a, in_b, 
	input [7:0] opcode,
	input clk
	);
	
	reg signed [LENGTH - 1 : 0] reg_a;

	localparam MSB = LENGTH - 1;
	
	/* reg_a should have the value of in_a ONLY if in_a changes
	 * Otherwise, reg_a should retain its value so that the output
         * of the previous operation can be used as an input to the next.
	 */
	always @ (in_a) reg_a = in_a;

	always @ (reg_a or in_b or opcode)
	begin
		case (opcode)
			8'h08:  /* In case of overflow - output = maximum possible number that can be represented [ 2^(n-1) - 1 ]
 				 * In case of underflow - output = minimum possible number that can be represented [ 2^(n-1) ]
				 */
				begin
					{overflow_flag, out} = {reg_a[MSB], reg_a} + {in_b[MSB], in_b};
					case({overflow_flag, out[MSB]})
						2'b01:   begin
								out = (1 << MSB) - 1;		/* Overflow */
								overflow_flag = 1'b1;
							 end
						2'b10:   begin
								out = 1 << MSB;			/* Underflow */
								overflow_flag = 1'b1;
							 end
						default: begin
								out = reg_a + in_b;
								overflow_flag = 1'b0;
							 end
					endcase
				end
			8'h09:  /* In case of overflow - output = maximum possible number that can be represented [ 2^(n-1) - 1 ]
 				 * In case of underflow - output = minimum possible number that can be represented [ 2^(n-1) ]
				 */
				begin
					{overflow_flag, out} = {reg_a[MSB], reg_a} - {in_b[MSB], in_b};
					case({overflow_flag, out[MSB]})
						2'b01:   begin
								out = (1 << MSB) - 1;		/* Overflow */
								overflow_flag = 1'b1;	
							 end
						2'b10:   begin
								out = 1 << MSB;			/* Underflow */
								overflow_flag = 1'b1;
							 end
						default: begin
								out = reg_a - in_b;	
								overflow_flag = 1'b0;
							 end	
					endcase
				end
			8'h0a:  out = in_b;
			8'h0b:  out = reg_a & in_b;
			8'h0c:  out = reg_a | in_b;
			8'h0d:  out = reg_a >>> in_b ;
			8'h0e:  out = reg_a <<< in_b; 
			8'h0f:  out = reg_a ^ in_b;
			default:/* In case of overflow - output = maximum possible number that can be represented [ 2^(n-1) - 1 ]
 				 * In case of underflow - output = minimum possible number that can be represented [ 2^(n-1) ]
				 */
				begin
					{overflow_flag, out} = {reg_a[MSB], reg_a} + {in_b[MSB], in_b};
					case({overflow_flag, out[MSB]})
						2'b01:   begin
								out = (1 << MSB) - 1;		/* Overflow */
								overflow_flag = 1'b1;
							 end
						2'b10:   begin
								out = 1 << MSB;			/* Underflow */
								overflow_flag = 1'b1;
							 end
						default: begin
								out = reg_a + in_b;	
								overflow_flag = 1'b0;
							 end 
					endcase
				end
		endcase
		reg_a = out;
	end
endmodule 

		
	
	
