/* ACM Class System (I) Fall Assignment 1 
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */
module CLA_4(
    input[3:0]     a,
    input[3:0]     b,
    input          cin,
    output[3:0]    sum,
    output         carry
);
	wire[3:0] CI,p,g;
    assign p=a^b;
    assign g=a&b;
    assign CI[0]=cin;
    assign CI[1] = g[0] | (p[0] & cin);
    assign CI[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign CI[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign carry = g[3] | ( p[3] & g[2] ) | ( p[3] & p[2] & g[1] ) | ( p[3] & p[2] & p[1] & g[0] ) | ( p[3] & p[2] & p[1] & p[0] & cin );
    assign sum=p^CI;
endmodule

module CLA_16(
	input[15:0]     a,
    input[15:0]     b,
    input          cin,
    output[15:0]    sum,
    output         carry
);
	wire mid1,mid2,mid3;
	CLA_4 cla1 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .carry(mid1));
	CLA_4 cla2 (.a(a[7:4]), .b(b[7:4]), .cin(mid1), .sum(sum[7:4]), .carry(mid2));
	CLA_4 cla3 (.a(a[11:8]), .b(b[11:8]), .cin(mid2), .sum(sum[11:8]), .carry(mid3));
	CLA_4 cla4 (.a(a[15:12]), .b(b[15:12]), .cin(mid3), .sum(sum[15:12]), .carry(carry));
endmodule

module CLA_32(
	input[31:0]     a,
	input[31:0]     b,
	input          cin,
	output[31:0]    sum,
	output         carry
);
	wire mid1,mid2;
	CLA_16 cl16_1(
		.a(a[15:0]),
		.b(b[15:0]),
		.cin(cin),
		.sum(sum[15:0]),
		.carry(mid1)
	);
	CLA_16 cl16_2(
		.a(a[31:16]),
		.b(b[31:16]),
		.cin(mid1),
		.sum(sum[31:16]),
		.carry(mid2)
	);
	assign carry = mid2;
endmodule



module Add(
	// TODO: Write the ports of this module here
	//
	// Hint: 
	//   The module needs 4 ports, 
	//     the first 2 ports are 16-bit unsigned numbers as the inputs of the adder
	//     the third port is a 16-bit unsigned number as the output
	//	   the forth port is a one bit port as the carry flag
	// 
	input[31:0]     a,
	input[31:0]     b,
	output[31:0]    sum,
	output         carry
	// input[15:0]     a,
	// input[15:0]     b,
	// output[15:0]    answer,
	// output         carry
);
	// TODO: Implement this module here
	CLA_32 cl32(
		.a(a),
		.b(b),
		.cin(1'b0),
		.sum(sum),
		.carry(carry)
	);
	// CLA_16 cl16(
	// 	.a(a),
	// 	.b(b),
	// 	.cin(1'b0),
	// 	.sum(answer),
	// 	.carry(carry)
	// );
endmodule
