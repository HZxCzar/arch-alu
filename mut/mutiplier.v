`include "../adder/adder.v"

module Mutiplier(
    input [31:0] x,
    input [31:0] y,
    output [63:0] answer
);
    wire[63:0] unit1[31:0];
    wire[63:0] unit2[15:0];
    wire[63:0] unit3[7:0];
    wire[63:0] unit4[3:0];
    wire[63:0] unit5[1:0];
    generate
        genvar i;
        for(i=0; i<32; i=i+1) begin: unit1_gen
            assign unit1[i] = y[i] ? x << i : 64'b0;
        end
        for(i=0; i<16; i=i+1) begin: unit2_gen
            CLA_64 cl64_1(
                .a(unit1[i*2]),
                .b(unit1[i*2+1]),
                .cin(1'b0),
                .sum(unit2[i]),
                .carry()
            );
        end
        for(i=0; i<8; i=i+1) begin: unit3_gen
            CLA_64 cl64_2(
                .a(unit2[i*2]),
                .b(unit2[i*2+1]),
                .cin(1'b0),
                .sum(unit3[i]),
                .carry()
            );
        end
        for(i=0; i<4; i=i+1) begin: unit4_gen
            CLA_64 cl64_3(
                .a(unit3[i*2]),
                .b(unit3[i*2+1]),
                .cin(1'b0),
                .sum(unit4[i]),
                .carry()
            );
        end
        for(i=0; i<2; i=i+1) begin: unit5_gen
            CLA_64 cl64_4(
                .a(unit4[i*2]),
                .b(unit4[i*2+1]),
                .cin(1'b0),
                .sum(unit5[i]),
                .carry()
            );
        end
    endgenerate
    CLA_64 cl64_5(
        .a(unit5[0]),
        .b(unit5[1]),
        .cin(1'b0),
        .sum(answer),
        .carry()
    );
endmodule