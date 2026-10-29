module baud_generator #(
    parameter CLOCK_FREQ = 50_000_000,
    parameter BAUD_RATE  = 9600,
    parameter OVERSAMPLE = 16
)(
    input clk,rst,
    output reg tick
);
    localparam DIVISOR = CLOCK_FREQ / (BAUD_RATE * OVERSAMPLE);

    integer count;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
        count <= 0;
        tick <= 0;
        end
        else
        begin
            if (count == DIVISOR-1)
            begin
            count <= 0;
            tick <= 1;
            end
            else
            begin
            count <= count + 1;
            tick <= 0;
            end
        end
    end

endmodule