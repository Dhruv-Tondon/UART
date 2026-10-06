module uart_top #(
    parameter CLOCK_FREQ = 50_000_000,
    parameter BAUD_RATE  = 9600
)(
    input clk,rst,tx_start,rx,
    input [7:0] tx_data,

    output tx,tx_busy,rx_valid,
    output [7:0] rx_data
);

    wire tick;


    baud_generator #(
        .CLOCK_FREQ(CLOCK_FREQ),.BAUD_RATE(BAUD_RATE)) baud_gen (.clk(clk),.rst(rst),.tick(tick));


    uart_tx tx_module (
        .clk(clk),.rst(rst),.tick(tick),
        .start(tx_start),.data_in(tx_data),
        .tx(tx),.busy(tx_busy)
    );


    uart_rx rx_module (
        .clk(clk),.rst(rst),.tick(tick),
        .rx(rx),.data_out(rx_data),.data_valid(rx_valid));

endmodule