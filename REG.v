module REG (d,clk,rst,en,q);
    parameter N = 1;
    parameter RSTTYPE_REG = "SYNC";
    input [N-1:0] d;
    input clk,rst,en;
    output reg [N-1:0] q;

    generate
        if (RSTTYPE_REG == "ASYNC") begin
            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    q <= 0;
                end
                else if (en) begin
                    q <= d;
                end
            end
        end
        else if (RSTTYPE_REG == "SYNC") begin
            always @(posedge clk) begin
                if (rst) begin
                    q <= 0;
                end
                else begin
                    q <= d;
                end
            end
        end
    endgenerate
endmodule