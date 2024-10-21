`include "../adder/adder.v"

module CLA_24(
    input [23:0] a,
    input [23:0] b,
    input cin,
    output [23:0] sum,
    output carry
);
    wire mid1;
    CLA_16 cl16_1(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(cin),
        .sum(sum[15:0]),
        .carry(mid1)
    );
    CLA_8 cl8_1(
        .a(a[23:16]),
        .b(b[23:16]),
        .cin(mid1),
        .sum(sum[23:16]),
        .carry(carry)
    );
endmodule

module RightShifter(
    input [23:0] in,       // 输入信号
    input [7:0] shift,     // 右移位数
    output [23:0] out      // 输出信号
);
    reg [23:0] temp;

    always @(*) begin
        temp = in;
        if (shift[0]) temp = {1'b0, temp[23:1]};
        if (shift[1]) temp = {2'b0, temp[23:2]};
        if (shift[2]) temp = {4'b0, temp[23:4]};
        if (shift[3]) temp = {8'b0, temp[23:8]};
        if (shift[4]) temp = {16'b0, temp[23:16]};
    end

    assign out = temp;
endmodule

module FloatAdder(
    input [31:0] a, // 浮点数 a
    input [31:0] b, // 浮点数 b
    output [31:0] result // 浮点数结果
);
    // 分解浮点数 a
    wire sign_a = a[31];
    wire [7:0] exp_a = a[30:23];
    wire [23:0] mant_a = {1'b1, a[22:0]}; // 隐含的1

    // 分解浮点数 b
    wire sign_b = b[31];
    wire [7:0] exp_b = b[30:23];
    wire [23:0] mant_b = {1'b1, b[22:0]}; // 隐含的1

    wire [7:0] exp_diff;
    CLA_8 exp_adder(
        .a(exp_a),
        .b(-exp_b),
        .sum(exp_diff)
    );

    // 选择较大的指数作为结果的指数
    wire [7:0] exp_result = (exp_a > exp_b) ? exp_a : exp_b;

    wire [23:0] mant_sum_a, mant_sum_b;
    wire [23:0] mant_b_shifted;
    RightShifter mant_b_shifter(
        .in(mant_b),
        .shift(exp_diff),
        .out(mant_b_shifted)
    );
    CLA_24 mant_a_adder(
        .a(mant_a),
        .b(mant_b_shifted),
        .cin(1'b0),
        .sum(mant_sum_a),
        .carry()
    );
    CLA_24 mant_b_adder(
        .a(mant_a),
        .b(-mant_b_shifted),
        .cin(1'b0),
        .sum(mant_sum_b),
        .carry()
    );
    // 尾数相加
    wire [24:0] mant_sum = (sign_a == sign_b) ? mant_sum_a : mant_sum_b;

    // 规格化结果
    wire [7:0] exp_result_norm;
    wire [23:0] mant_result_norm;
    assign exp_result_norm = (mant_sum[24]) ? exp_result + 1 : exp_result;
    assign mant_result_norm = (mant_sum[24]) ? mant_sum[24:1] : mant_sum[23:0];

    wire sign_result = sign_a;
    assign result = {sign_result, exp_result_norm, mant_result_norm[22:0]};

endmodule