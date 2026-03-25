module rx_sync (
    input  logic clk,
    input  logic rx_line,
    output logic rx_sync2
);

logic rx_sync1;

always_ff @(posedge clk or posedge rst) begin
    rx_sync1 <= rx_line;
    rx_sync2 <= rx_sync1;
end


endmodule