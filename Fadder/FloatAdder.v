module FloatAdder(
    input [15:0]a,
    input [15:0]b,
    output reg [15:0]sum
);
reg sign;
reg [4:0]exponent_a;
reg [4:0]exponent_b;
reg [10:0]fraction_a;
reg [10:0]fraction_b;
reg [4:0]exponent_sum;
reg [11:0]fraction_sum;
reg [7:0]exponent_shift;

always@(a or b)begin
        exponent_a=a[14:10];
        exponent_b=b[14:10];
        fraction_a={1'b1,a[9:0]};
        fraction_b={1'b1,b[9:0]};
        if(a[15]==b[15])begin//+
                sign=a[15];
                //相等直接加
                if(exponent_a==exponent_b)begin
                        fraction_sum = fraction_a + fraction_b;
                        exponent_sum = exponent_a + 1'b1;
                        fraction_sum = fraction_sum >> 1'b1;
                end
                
                //不相等先对阶
                else if(exponent_a<exponent_b)begin
                        exponent_shift = exponent_b - exponent_a;
                        exponent_sum = exponent_b;
                        fraction_a = fraction_a >> (exponent_shift);
                        fraction_sum = fraction_a + fraction_b;
                        case(fraction_sum[11:10])
                                2'b11:begin
                                        exponent_sum=exponent_sum + 1'b1;
                                        fraction_sum = fraction_sum >> 1'b1;
                                        end
                                2'b10:begin
                                        exponent_sum=exponent_sum + 1'b1;
                                        fraction_sum = fraction_sum >> 1'b1;
                                        end
                                default:begin
                                        exponent_sum = exponent_b;
                                        fraction_sum = fraction_a + fraction_b;
                                end
                        endcase
                end
                
                else begin
                        exponent_shift = exponent_a - exponent_b;
                        exponent_sum = exponent_a;
                        fraction_b = fraction_b >> (exponent_shift);
                        fraction_sum = fraction_a + fraction_b;
                        case(fraction_sum[11:10])
                                2'b11:begin
                                        exponent_sum=exponent_sum + 1'b1;
                                        fraction_sum = fraction_sum >> 1'b1;
                                        end
                                2'b10:begin
                                        exponent_sum=exponent_sum + 1'b1;
                                        fraction_sum = fraction_sum >> 1'b1;
                                        end
                                2'b01,2'b00:begin
                                        exponent_sum = exponent_a;
                                        fraction_sum = fraction_a + fraction_b;
                                end
                        endcase
                end
                
        end
        
        else begin//-
                //阶数不同大小直接判
                if(exponent_a>exponent_b)begin
                        sign=a[15];
                        exponent_shift = exponent_a - exponent_b;
                        exponent_sum = exponent_a;
                        fraction_b = fraction_b >> (exponent_shift);
                        fraction_sum = fraction_a - fraction_b;
                        if(fraction_sum[10]==0)begin
                                if(fraction_sum[9]==1)begin
                                        fraction_sum = fraction_sum << 1;
					                    exponent_sum = exponent_sum - 1;
                                end
                                else if(fraction_sum[8]==1)begin
                                        fraction_sum = fraction_sum << 2;
					                    exponent_sum = exponent_sum - 2;
                                end
                                else if(fraction_sum[7]==1)begin
                                        fraction_sum = fraction_sum << 3;
					                    exponent_sum = exponent_sum - 3;
                                end
                                else if(fraction_sum[6]==1)begin
                                        fraction_sum = fraction_sum << 4;
					                    exponent_sum = exponent_sum - 4;
                                end
                                else if(fraction_sum[5]==1)begin
                                        fraction_sum = fraction_sum << 5;
					                    exponent_sum = exponent_sum - 5;
                                end
                                else if(fraction_sum[4]==1)begin
                                        fraction_sum = fraction_sum << 6;
					                    exponent_sum = exponent_sum - 6;
                                end
                                else if(fraction_sum[3]==1)begin
                                        fraction_sum = fraction_sum << 7;
					                    exponent_sum = exponent_sum - 7;
                                end
                                else if(fraction_sum[2]==1)begin
                                        fraction_sum = fraction_sum << 8;
					                    exponent_sum = exponent_sum - 8;
                                end
                                else if(fraction_sum[1]==1)begin
                                        fraction_sum = fraction_sum << 9;
					                    exponent_sum = exponent_sum - 9;
                                end
                                else if(fraction_sum[0]==1)begin
                                        fraction_sum = fraction_sum << 10;
					                    exponent_sum = exponent_sum - 10;
                                end
                        end
                end
                else if(exponent_a<exponent_b)begin
                        sign=b[15];
                        exponent_shift = exponent_b - exponent_a;
                        exponent_sum = exponent_b;
                        fraction_a = fraction_a >> (exponent_shift);//对阶
                        fraction_sum = fraction_b - fraction_a;//尾数计算
                        if(fraction_sum[10]==0)begin
                                if(fraction_sum[9]==1)begin
                                        fraction_sum = fraction_sum << 1;
					                    exponent_sum = exponent_sum - 1;
                                end
                                else if(fraction_sum[8]==1)begin
                                        fraction_sum = fraction_sum << 2;
					                    exponent_sum = exponent_sum - 2;
                                end
                                else if(fraction_sum[7]==1)begin
                                        fraction_sum = fraction_sum << 3;
					                    exponent_sum = exponent_sum - 3;
                                end
                                else if(fraction_sum[6]==1)begin
                                        fraction_sum = fraction_sum << 4;
					                    exponent_sum = exponent_sum - 4;
                                end
                                else if(fraction_sum[5]==1)begin
                                        fraction_sum = fraction_sum << 5;
					                    exponent_sum = exponent_sum - 5;
                                end
                                else if(fraction_sum[4]==1)begin
                                        fraction_sum = fraction_sum << 6;
					                    exponent_sum = exponent_sum - 6;
                                end
                                else if(fraction_sum[3]==1)begin
                                        fraction_sum = fraction_sum << 7;
					                    exponent_sum = exponent_sum - 7;
                                end
                                else if(fraction_sum[2]==1)begin
                                        fraction_sum = fraction_sum << 8;
					                    exponent_sum = exponent_sum - 8;
                                end
                                else if(fraction_sum[1]==1)begin
                                        fraction_sum = fraction_sum << 9;
					                    exponent_sum = exponent_sum - 9;
                                end
                                else if(fraction_sum[0]==1)begin
                                        fraction_sum = fraction_sum << 10;
					                    exponent_sum = exponent_sum - 10;
                                end
                        end
                end
                //阶数相同看尾数
                else begin
                        //尾数比大小
                        if(fraction_a>fraction_b)begin
                                sign=a[15];
                                exponent_shift = exponent_a - exponent_b;
                                exponent_sum = exponent_a;
                                fraction_b = fraction_b >> (exponent_shift);//对阶
                                fraction_sum = fraction_a - fraction_b;//尾数计算
                                if(fraction_sum[10]==0)begin
                                if(fraction_sum[9]==1)begin
                                        fraction_sum = fraction_sum << 1;
					                    exponent_sum = exponent_sum - 1;
                                end
                                else if(fraction_sum[8]==1)begin
                                        fraction_sum = fraction_sum << 2;
					                    exponent_sum = exponent_sum - 2;
                                end
                                else if(fraction_sum[7]==1)begin
                                        fraction_sum = fraction_sum << 3;
					                    exponent_sum = exponent_sum - 3;
                                end
                                else if(fraction_sum[6]==1)begin
                                        fraction_sum = fraction_sum << 4;
					                    exponent_sum = exponent_sum - 4;
                                end
                                else if(fraction_sum[5]==1)begin
                                        fraction_sum = fraction_sum << 5;
					                    exponent_sum = exponent_sum - 5;
                                end
                                else if(fraction_sum[4]==1)begin
                                        fraction_sum = fraction_sum << 6;
					                    exponent_sum = exponent_sum - 6;
                                end
                                else if(fraction_sum[3]==1)begin
                                        fraction_sum = fraction_sum << 7;
					                    exponent_sum = exponent_sum - 7;
                                end
                                else if(fraction_sum[2]==1)begin
                                        fraction_sum = fraction_sum << 8;
					                    exponent_sum = exponent_sum - 8;
                                end
                                else if(fraction_sum[1]==1)begin
                                        fraction_sum = fraction_sum << 9;
					                    exponent_sum = exponent_sum - 9;
                                end
                                else if(fraction_sum[0]==1)begin
                                        fraction_sum = fraction_sum << 10;
					                    exponent_sum = exponent_sum - 10;
                                end
                        end
                        end
                        else if(fraction_a < fraction_b)begin
                                sign=b[15];
                                exponent_shift = exponent_b - exponent_a;
                                exponent_sum = exponent_b;
                                fraction_a = fraction_a >> (exponent_shift);//对阶
                                fraction_sum = fraction_b - fraction_a;//尾数计算
                                if(fraction_sum[10]==0)begin
                                if(fraction_sum[9]==1)begin
                                        fraction_sum = fraction_sum << 1;
					                    exponent_sum = exponent_sum - 1;
                                end
                                else if(fraction_sum[8]==1)begin
                                        fraction_sum = fraction_sum << 2;
					                    exponent_sum = exponent_sum - 2;
                                end
                                else if(fraction_sum[7]==1)begin
                                        fraction_sum = fraction_sum << 3;
					                    exponent_sum = exponent_sum - 3;
                                end
                                else if(fraction_sum[6]==1)begin
                                        fraction_sum = fraction_sum << 4;
					                    exponent_sum = exponent_sum - 4;
                                end
                                else if(fraction_sum[5]==1)begin
                                        fraction_sum = fraction_sum << 5;
					                    exponent_sum = exponent_sum - 5;
                                end
                                else if(fraction_sum[4]==1)begin
                                        fraction_sum = fraction_sum << 6;
					                    exponent_sum = exponent_sum - 6;
                                end
                                else if(fraction_sum[3]==1)begin
                                        fraction_sum = fraction_sum << 7;
					                    exponent_sum = exponent_sum - 7;
                                end
                                else if(fraction_sum[2]==1)begin
                                        fraction_sum = fraction_sum << 8;
					                    exponent_sum = exponent_sum - 8;
                                end
                                else if(fraction_sum[1]==1)begin
                                        fraction_sum = fraction_sum << 9;
					                    exponent_sum = exponent_sum - 9;
                                end
                                else if(fraction_sum[0]==1)begin
                                        fraction_sum = fraction_sum << 10;
					                    exponent_sum = exponent_sum - 10;
                                end
                        end
                        end
                        //尾数也相等直接为0
                        else begin
                                sign=a[15];
                                exponent_sum = exponent_a;
                                fraction_sum = {10{1'b0}};
                        end
                end
        end
        sum = {sign,exponent_sum,fraction_sum[9:0]};
end
 
endmodule