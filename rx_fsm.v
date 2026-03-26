module rx_ctrl (
    input  logic clk, rst,rx_sync2,start,start_sampled,
    input  logic data_sample,stop,stop_sampled,
    input  logic rx_en,

    output logic error,successful_frame,busy,
    output logic [7:0] data_received
);

typedef enum logic [2:0] {IDLE, START, DATA, STOP, DONE} state_t;
state_t state, next;

logic [2:0] bit_count;
logic [7:0] shift_reg;

always_ff @(posedge clk or posedge rst)
    if (rst) state <= IDLE;
    else state <= next;

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        bit_count <= 0;
    else if (state != DATA)
        bit_count <= 0;
    else if (data_sample)
        bit_count <= bit_count + 1;
end

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        shift_reg <= 0;
    else if (state == DATA && data_sample)
        shift_reg <= {rx_sync2, shift_reg[7:1]};  /
end


always_comb begin
    next = state;
    case(state)
        IDLE:  if (start) next = START;

        START: begin
            if (start_sampled) next = DATA;
            else    next = IDLE;
        end

        DATA: begin
            if (data_sample && bit_count == 7)
                next = STOP;
        end

        STOP: begin
            if (stop_sampled) next = DONE;
            else  next = IDLE;
        end

        DONE: next = IDLE;
    endcase
end

always_comb begin
    error = 0;
    successful_frame = 0;
    busy = 1;
    data_received = shift_reg;

    case(state)
        IDLE: begin
            busy = 0;
        end

        START: 
            if (!start_sampled)error = 1;

        DATA: 

        STOP: 
            if (!stop_sampled)error = 1;

        DONE: begin
            successful_frame = 1;
            busy = 0;
        end
    endcase
end

endmodule