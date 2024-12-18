module sandbox #(
  parameter int DATA_WIDTH = 4
) (
  input logic i_clk,
  input logic i_reset_n_sync,
  input logic i_en,
  input logic i_reset_n_async,

  input  logic [DATA_WIDTH-1:0] i_d,
  output logic [DATA_WIDTH-1:0] o_q_0,
  output logic [DATA_WIDTH-1:0] o_q_1,
  output logic [DATA_WIDTH-1:0] o_q_2,

  input  logic i_a,
  input  logic i_b,
  input  logic i_sel,
  output logic o_y,

  input  logic                  i_up,
  input  logic                  i_load,
  input  logic [DATA_WIDTH-1:0] i_load_val,
  output logic [DATA_WIDTH-1:0] o_count
);

  always_ff @(posedge i_clk) begin
    o_q_0 <= i_d;
  end

  always_ff @(posedge i_clk) begin
    if (!i_reset_n_sync) begin
      o_q_1 <= '0;
    end else if (i_en) begin
      o_q_1 <= i_d;
    end
  end

  always_ff @(posedge i_clk or negedge i_reset_n_async) begin
    if (!i_reset_n_async) begin
      o_q_2 <= '0;
    end else if (i_en) begin
      o_q_2 <= i_d;
    end
  end

  assign o_y = i_sel ? i_b : i_a;



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
    end else begin
      count_next = count_q - (DATA_WIDTH)'(1'b1);

      if (i_up) begin
        count_next = count_q + (DATA_WIDTH)'(1'b1);
      end
    end
  end

  assign o_count = count_q;

endmodule
