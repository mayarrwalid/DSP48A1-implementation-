module OPERATOR #(
    parameter N = 1
)(
    input [N-1:0] x,y,
    input opmode,cin,
    output reg cout,
    output reg [N-1:0] out
);
    reg [N:0] temp; 
    always @(*) begin
        if (opmode == 0) begin
            temp = x + y + cin;
        end
        else begin
            temp = x - ( y + cin ) ;
        end

        out = temp[N-1:0];
        cout = temp[N];
    end
endmodule