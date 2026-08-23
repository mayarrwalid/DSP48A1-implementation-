module MUX41 #(
    parameter N = 1
)(
    input [1:0] opmode,
    input [N-1:0] x,y,z,
    output [N-1:0] out
);

    assign out = (opmode == 2'b00)? {N{1'b0}} :
                 (opmode == 2'b01)? x :
                 (opmode == 2'b10)? y : z ;
endmodule
