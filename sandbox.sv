module sandbox #(
  parameter int DATA_WIDTH = 8
) (
  input  logic                  i_clk,
  input  logic                  i_reset_n,
  input  logic [DATA_WIDTH-1:0] i_d,
  output logic [DATA_WIDTH-1:0] o_q,

  input  logic i_test_0,
  input  logic i_test_1,
  output logic o_test_0
);

  always_ff @(posedge i_clk) begin
    if (!i_reset_n) begin
      o_q <= '0;
    end else begin
      o_q <= i_d;
    end
  end

  always_comb begin
    o_test_0 = '1;

    if (i_test_0) begin
      o_test_0 = i_test_1;
    end
  end

endmodule
