module sandbox #(
  parameter int DATA_WIDTH = 4
) (
  input logic i_clk,
  input logic i_reset_n_sync,
  input logic i_reset_n_async,

  input  logic                  i_en,
  input  logic [DATA_WIDTH-1:0] i_d,
  output logic [DATA_WIDTH-1:0] o_q_no_reset,
  output logic [DATA_WIDTH-1:0] o_q_sync_reset,
  output logic [DATA_WIDTH-1:0] o_q_async_reset,

  input  logic i_a,
  input  logic i_b,
  input  logic i_sel,
  output logic o_y,

  input  logic                  i_up,
  input  logic                  i_load,
  input  logic [DATA_WIDTH-1:0] i_load_val,
  output logic [DATA_WIDTH-1:0] o_count,

  input  logic                  i_x,
  output logic [DATA_WIDTH-1:0] o_left_shift,
  output logic [DATA_WIDTH-1:0] o_right_shift
);

  // flops
  always_ff @(posedge i_clk) begin
    o_q_no_reset <= i_d;
  end

  always_ff @(posedge i_clk) begin
    if (!i_reset_n_sync) begin
      o_q_sync_reset <= '0;
    end else if (i_en) begin
      o_q_sync_reset <= i_d;
    end
  end

  always_ff @(posedge i_clk or negedge i_reset_n_async) begin
    if (!i_reset_n_async) begin
      o_q_async_reset <= '0;
    end else if (i_en) begin
      o_q_async_reset <= i_d;
    end
  end


  // mux
  assign o_y = i_sel ? i_b : i_a;


  // counter
  logic [DATA_WIDTH-1:0] count_q, count_next;
  logic [DATA_WIDTH-1:0] load_val_q;

  always_ff @(posedge i_clk) begin
    if (!i_reset_n_sync) begin
      count_q <= '0;
    end else begin
      count_q <= count_next;
    end
  end

  always_ff @(posedge i_clk) begin
    if (!i_reset_n_sync) begin
      load_val_q <= '0;
    end else if (i_load) begin
      load_val_q <= i_load_val;
    end
  end

  always_comb begin
    if (i_load) begin
      count_next = i_load_val;
    end else if (((count_q == '1) && i_up) || ((count_q == '0) && !i_up)) begin
      count_next = load_val_q;
    end else if (i_up) begin
      count_next = count_q + (DATA_WIDTH)'(1'b1);
    end else begin
      count_next = count_q - (DATA_WIDTH)'(1'b1);
    end
  end

  assign o_count = count_q;


  // shift register
  logic [DATA_WIDTH-1:0] left_shift_q, left_shift_next;
  logic [DATA_WIDTH-1:0] right_shift_q, right_shift_next;

  always_ff @(posedge i_clk) begin
    if (!i_reset_n_sync) begin
      left_shift_q  <= '0;
      right_shift_q <= '0;
    end else begin
      left_shift_q  <= left_shift_next;
      right_shift_q <= right_shift_next;
    end
  end

  always_comb begin
    left_shift_next  = {left_shift_q[DATA_WIDTH-2:0], i_x};
    right_shift_next = {i_x, right_shift_q[DATA_WIDTH-1:1]};
  end

  assign o_left_shift  = left_shift_q;
  assign o_right_shift = right_shift_q;

endmodule
