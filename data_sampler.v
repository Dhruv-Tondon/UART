module data_sampler (
    input  clk, rst,
    input  rx_sync2,enable,align,        

    output logic sample_tick
);

logic [3:0] rx_count;

always_ff @(posedge clk or posedge rst) begin
    if (rst || align) begin
        rx_count <= 0;
        sample_tick <= 0;
    end 
    else if (rx_sync_2 && enable) begin
        if (rx_count == 4'd15)
            rx_count <= 0;
        else
            rx_count <= rx_count + 1;

        sample_tick <= (rx_count == 4'd7);
    end 
    else begin
        sample_tick <= 0;
    end
end

endmodule