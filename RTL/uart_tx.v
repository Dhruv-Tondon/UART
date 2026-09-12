module uart_tx(
    input clk,rst,tick,start,
    input [7:0] data_in,

    output reg tx,busy
);

    reg [9:0] shift_reg;
    reg [3:0] tick_count,bit_count;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            shift_reg <= 10'b1111111111;
            tick_count <= 0;
            bit_count <= 0;
            tx <= 1;
            busy <= 0;
        end

        else
        begin

            if (start && !busy)
            begin
                shift_reg <= {1'b1, data_in, 1'b0};
                tx <= 0;
                busy <= 1;
                tick_count <= 0;
                bit_count <= 0;
            end

            else if (busy && tick)
            begin
                if (tick_count == 4'd15)
                begin
                    tick_count <= 0;

                    if (bit_count == 4'd9)
                    begin
                        // Transmission over
                        tx <= 1;
                        busy <= 0;
                    end
                    else
                    begin
                        shift_reg <= shift_reg >> 1;
                        tx <= shift_reg[1];
                        bit_count <= bit_count + 1;
                    end
                end

                else tick_count <= tick_count + 1;

            end
        end
    end

endmodule