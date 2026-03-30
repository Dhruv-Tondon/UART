module rx_shift_reg (
    input logic clk,rst,shift_en, ser_in,
    input logic load_out,
    output logic [7:0] data_out
);

logic [7:0] data;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        data <= 0;
        data_out <= 0;
    end
    else begin
        if (shift_en)
            data <= {data[6:0], ser_in};

        if (load_out)
            data_out <= data;
    end
end

endmodule