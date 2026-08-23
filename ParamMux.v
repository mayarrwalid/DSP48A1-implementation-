module ParamMux #(
    parameter REGISTER = 1,
    parameter N = 1
)(
    input [N-1:0] x,y,
    output reg [N-1:0] out
);

   always @(*) begin
      if (REGISTER == 1) begin
        out = x;
      end
      else begin
        out = y;
      end
   end
endmodule