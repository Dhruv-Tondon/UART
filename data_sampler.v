module data_sampler(input rx_en,clk,rst,rx_sync_2,
output logic start_sampled,data_sample,stop_sampled);

reg [3:0]rx_count;

always_ff@(posedge clk or rst)begin
if(rst or rx_count==4'b1111;begin
     rx_count <= 0;
     start_sampled
     data_sample
     stop_sampled
end
end 
else if (start) begin
    for(int i=0; i<8 ;i++)begin
        (count<8)




endmodule