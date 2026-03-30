module tx_shift_reg (
    input logic clk, rst,
    input logic load, shift_en,
    input logic [7:0] data_in,
    output logic ser_out
);

logic [7:0] data;

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        data <= 0;
    else if (load)
        data <= data_in;
    else if (shift_en)
        data <= {1'b0, data[7:1]}; 
end

assign ser_out = data[0];

endmodule

