module sandbox #(
  parameter int DATA_WIDTH = 8
) (
  input  logic                  i_clk,
  input  logic                  i_reset_n,
  input  logic [DATA_WIDTH-1:0] i_d,
  output logic [DATA_WIDTH-1:0] o_q
);

  always_ff @(posedge i_clk) begin
    if (!i_reset_n) begin
      o_q <= '0;
    end else begin
      o_q <= i_d;
    end
  end

endmodule
