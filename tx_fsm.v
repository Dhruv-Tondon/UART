module tx_ctrl (
    input  logic clk, rst, tx_start, tx_en,
    input logic serial_data,
    output logic shift_en, load,
    output logic tx_line,
    output logic data_phase,
    output logic busy
);

typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
state_t state, next;

logic [2:0] bit_count;

always_ff @(posedge clk or posedge rst)
    if (rst) state <= IDLE;
    else     state <= next;

always_ff @(posedge clk or posedge rst) begin
    if (rst) bit_count <= 0;
    else if (state != DATA) bit_count <= 0;
    else if (tx_en) bit_count <= bit_count + 1;

end

always_comb begin
    next = state;

    case(state)
        IDLE:  if (tx_start) next = START;
        START: if (tx_en) next = DATA;
        DATA:  if (tx_en && bit_count == 7) next = STOP;
        STOP:  if (tx_en) next = IDLE;
    endcase
end

always_comb begin
    shift_en = 0;
    load = 0;
    tx_line = 1;
    data_phase = 0;
    busy = 1;

    case(state)
        IDLE: begin
            busy = 0;
            if (tx_start) load = 1;
        end

        START: tx_line = 0;

        DATA: begin
            shift_en = tx_en;
            data_phase = 1;
            tx_line = serial_data;
        end

        STOP: tx_line = 1;
    endcase
end

endmodule