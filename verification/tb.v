`timescale 1ns/1ps

module uart_tb;

    reg clk,rst,tx_start;
    reg [7:0] tx_data;

    wire tx,tx_busy,rx_valid;
    wire [7:0] rx_data;

    wire rx;
    assign rx = tx;


    uart_top #(
        .CLOCK_FREQ(50_000_000),
        .BAUD_RATE(9600)
    )
    uut (
        .clk(clk),.rst(rst),
        .tx_start(tx_start),.tx_data(tx_data),
        .tx(tx),.tx_busy(tx_busy),



        .rx(rx),.rx_data(rx_data),
        .rx_valid(rx_valid)
    );


    always #10 clk = ~clk;


    initial
    begin
        clk = 0;
        rst = 1;

        tx_start = 0;
        tx_data = 0;

        #100;

        rst = 0;


        // send A = 0x41
        #100;

        tx_data = 8'h41;
        tx_start = 1;

        #20;

        tx_start = 0;
        wait(tx_busy == 0);

        #2000000;

        // Send B = 0x42
        tx_data = 8'h42;
        tx_start = 1;

        #20;
        tx_start = 0;


        wait(tx_busy == 0);
        #2000000;
        $finish;
    end


    initial
    begin
        $dumpfile("dump1.vcd");
        $dumpvars(0, uart_tb);
    end


    always @(posedge rx_valid) $display("RX DATA = %h (%c) at time %0t",rx_data,rx_data,$time);

endmodule