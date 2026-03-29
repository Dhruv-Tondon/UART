module rx_ctrl (
    input logic clk, rst,logic rx_sync2,logic start,logic sample_tick,

    output logic shift_en,logic error,successful_frame,logic busy,enable,align
);

typedef enum logic [2:0] {IDLE, START,DATA,STOP,DONE} state_t;
state_t state, next;
enable = (state != IDLE);
align  = (state == IDLE && start);

logic [2:0] bit_count;

always_ff @(posedge clk or posedge rst)
    if (rst) state <= IDLE;
    else state <= next;

always_ff @(posedge clk or posedge rst) begin
    if (rst) bit_count <= 0;
    else if(state != DATA) bit_count <= 0;
    else if (sample_tick) bit_count <= bit_count + 1;
end

always_comb begin
    next = state;
    case(state)
        IDLE: if (start) next = START;
        START:if (sample_tick) begin
            if (rx_sync2 == 0) next = DATA;
            else next = IDLE;
            end
        DATA:if (sample_tick && bit_count == 7)
             next = STOP;
        STOP:  if (sample_tick) begin
            if (rx_sync2 == 1) next = DONE;
            else next = IDLE;
               end
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
        DATA: if(sample_tick) shift_en = 1;
        STOP: if (sample_tick && rx_sync2 == 0) error = 1;
        DONE: begin
            successful_frame = 1;
            busy = 0;
        end
    endcase
end
endmodule