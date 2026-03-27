module rx_ctrl (
    input  logic clk,rst, rx_sync2,start,
    input  logic stop,start_sampled,data_sample,stop_sampled,
    output logic shift_en,error,successful_frame,busy
);

typedef enum logic [2:0] {IDLE, START, DATA, STOP, DONE} state_t;
state_t state, next;

logic [2:0] bit_count;

always_ff @(posedge clk or posedge rst)
    if (rst) state <= IDLE;
    else state <= next;

always_ff @(posedge clk or posedge rst) begin
    if (rst) bit_count <= 0;
    else if (state != DATA) bit_count <= 0;
    else if (data_sample) bit_count <= bit_count + 1;
end

always_comb begin
    next = state;
    case(state)
        IDLE: if (start) next = START;
        START: if (start_sampled) next = DATA;
               else next = IDLE;
        DATA: if (data_sample && bit_count == 7) next = STOP;
        STOP:  if (stop_sampled) next = DONE;
               else next = IDLE;
        DONE: next = IDLE;
    endcase
end

always_comb begin
    shift_en = 0;
    error = 0;
    successful_frame = 0;
    busy = 1;

    case(state)
        IDLE: busy = 0;
        DATA: if (data_sample) shift_en = 1;

        STOP: if (!stop_sampled) error = 1;

        DONE: begin
            successful_frame = 1;
            busy = 0;
        end
    endcase
end

endmodule