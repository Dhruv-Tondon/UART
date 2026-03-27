module start_detector (
    input  rst, clk, rx_sync2,
    output logic start
);

logic prev;
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        prev  <= 1;
        start <= 0;
    end
    else begin
        start <=(prev == 1 && rx_sync2 == 0);
        prev<= rx_sync2;
    end
end

endmodule


