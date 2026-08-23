module MUX21 #(
    parameter N = 1
)(
    input opmode,
    input [N-1:0] x,y,
    output [N-1:0] out
);

    assign out = (opmode == 1'b0)? x : y ;
endmodule