module rx_sync (
    input  logic clk,
    input  logic rst,
    input  logic rx_line,
    output logic rx_sync2
);

logic rx_sync1;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_sync1 <= 1;
        rx_sync2 <= 1;
    end else begin
        rx_sync1 <= rx_line;
        rx_sync2 <= rx_sync1;
    end
end

endmodule