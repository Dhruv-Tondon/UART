module start_det_tb();

reg rst ,clk,rx_sync2 ;
wire start;
start_detector uut(rst ,clk,rx_sync2,start);

always #1 clk=~clk;

initial begin
    rx_sync2=1;
    clk=0;
    rst =1;
    #5 rst=0;
    #5 rx_sync2=0;
    #200 rx_sync2=1;
    #1000 rx_sync2=0;
    #200 rx_sync2=1;
    #300 rx_sync2=1;
    rst=1;
    #1000 rx_sync2=0;
end


initial begin
    $dumpfile("dump2.vcd");
    $dumpvars(0, start_det_tb);

    $display("Starting simulation...");

    #10000; 

    $display("Simulation finished");
    $finish;
end
endmodule