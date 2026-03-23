`timescale 1ns/1ps

module baud_tb;

reg clk;
reg reset;
wire tx_en;
wire rx_en;

baud_gen uut (
    .clk(clk),
    .reset(reset),
    .tx_en(tx_en),
    .rx_en(rx_en)
);

// Clock 20 ns period(50 Mhz)
initial begin
    clk = 0;
end

always begin
    #10 clk = ~clk;
end

initial begin
    reset = 1;
    #100;
    reset = 0;
end


initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, baud_tb);

    $display("Starting simulation...");

    #20000000; 

    $display("Simulation finished");
    $finish;
end

endmodule