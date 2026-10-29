module uart_rx(
    input clk,rst,tick, rx,
    output reg [7:0] data_out,
    output reg data_valid);

    reg rx_sync1;
    reg rx_sync2;

    localparam IDLE= 2'd0,START = 2'd1, DATA = 2'd2,STOP= 2'd3;
    reg [1:0] state;

    reg [3:0] tick_count;
    reg [2:0] bit_count;

    reg [7:0] shift_reg;


    always @(posedge clk or posedge rst)
    begin
        if (rst) {rx_sync1,rx_sync2}<=2'b11;
        else {rx_sync1,rx_sync2}<={rx,rx_sync1};
    end


    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= IDLE;
            tick_count<= 0;
            bit_count <= 0;
            shift_reg <= 0;
            data_out <= 0;
            data_valid <= 0;
        end

        else
        begin

            data_valid <= 0;
            case (state)
            IDLE:
            begin
                tick_count <= 0;
                bit_count <= 0;
                if (rx_sync2 == 0) state <= START;
            end

            START:
            begin
                if (tick)
                begin
                    if (tick_count == 4'd7)
                    begin
                        tick_count <= 0;
                        if (rx_sync2 == 0)state <= DATA;
                        else state <= IDLE;
                    end

                    else tick_count <= tick_count + 1;
                    end
            end

            DATA:
            begin

                if (tick)
                begin
                    if (tick_count == 4'd15)
                    begin
                        tick_count <= 0;
                        shift_reg[bit_count] <= rx_sync2;

                        if (bit_count == 3'd7)
                        begin
                            bit_count <= 0;
                            state <= STOP;
                        end
                        else bit_count <= bit_count + 1;
                    end
                    else tick_count <= tick_count + 1;
                end
            end

            STOP:
            begin
                if (tick)
                begin
                    if (tick_count == 4'd15)
                    begin
                        tick_count <= 0;
                        if (rx_sync2 == 1){data_out,data_valid}<={shift_reg,1};
                        state <= IDLE;
                        end

                    else tick_count <= tick_count + 1;
                end
            end

            default: state <= IDLE;

            endcase
        end
    end

endmodule