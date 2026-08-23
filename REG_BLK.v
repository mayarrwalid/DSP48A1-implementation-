module REG_BLK #(
    parameter N = 1,
    parameter REGISTER = 1,
    parameter RSTTYPE = "SYNC"
)(
    input [N-1:0] in,
    input clk,rst,en,
    output [N-1:0] out
);
    wire [N-1:0] z;

    REG #(.N(N),.RSTTYPE_REG(RSTTYPE)) REGBLK (.d(in),.clk(clk),.rst(rst),.en(en),.q(z));
    ParamMux #(.N(N),.REGISTER(REGISTER)) MUXBLK (.x(z),.y(in),.out(out));

endmodule