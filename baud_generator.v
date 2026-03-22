module baud_gen #(parameter b_rate=9600, parameter clockspeed=50000000 )(input clk,
output reg tx_en,
output reg rx_en
);
localparam a= $clog2(clockspeed/b_rate) ;
localparam b= $clog2(clockspeed/(16*b_rate)) ;
localparam c= (clockspeed/b_rate)-1 ;
localparam d= (clockspeed/(16*b_rate))-1 ;
reg [a-1:0]q1;
reg [b-1:0]q2;

always @(posedge clk or posedge reset)begin
    if (reset) begin
    q1<=0;
    tx_en<=0;
    end

    else if (q1==c) begin
    q1<=0;
    tx_en<=1;
    end

    else begin
    q1<=q1+1;
    tx_en<=0;
    end

end

always @(posedge clk)begin
    
    if (reset) begin
    q2<=0;
    rx_en<=0;
    end

    else if (q2==d) begin
    q2<=0;
    rx_en<=1;
    end

    else begin
    q2<=q2+1;
    rx_en<=0;
    end

end

endmodule
