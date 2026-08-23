module DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
)(  
    input [17:0] A,B,D,BCIN,
    input [47:0] C,PCIN,
    input [7:0] OPMODE,
    input CARRYIN,CLK,
    input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
    input RSTA,RSTB,RSTC,RSTD,RSTCARRYIN,RSTM,RSTOPMODE,RSTP,
    output [35:0] M,
    output [47:0] P,PCOUT,
    output CARRYOUT,CARRYOUTF,
    output [17:0] BCOUT
);
    wire [17:0] A0_REG,B0_REG,D_REG,PREOUT,B1,A1_REG;
    wire [47:0] C_REG,DAB,X,Z,POSTOUT;
    wire [35:0] M_OUT,M_REG;
    wire [7:0] OPMODE_REG;
    wire CIN,COUT;
    
REG_BLK #(.N(8),.REGISTER(OPMODEREG),.RSTTYPE(RSTTYPE)) OPREG (.in(OPMODE),.clk(CLK),.out(OPMODE_REG),.rst(RSTOPMODE),.en(CEOPMODE));

REG_BLK #(.N(18),.REGISTER(A0REG),.RSTTYPE(RSTTYPE)) A0 (.in(A),.clk(CLK),.out(A0_REG),.rst(RSTA),.en(CEA));

generate
    if (B_INPUT == "DIRECT") begin
        REG_BLK #(.N(18),.REGISTER(B0REG),.RSTTYPE(RSTTYPE)) B0 (.in(B),.clk(CLK),.out(B0_REG),.rst(RSTB),.en(CEB));
    end
    else if (B_INPUT == "CASCADE") begin
        REG_BLK #(.N(18),.REGISTER(B0REG),.RSTTYPE(RSTTYPE)) B0 (.in(BCIN),.clk(CLK),.out(B0_REG),.rst(RSTB),.en(CEB));
    end
    else begin
        REG_BLK #(.N(18),.REGISTER(B0REG),.RSTTYPE(RSTTYPE)) B0 (.in(BCIN),.clk(CLK),.out(1'b0),.rst(RSTB),.en(CEB));        
    end
endgenerate

REG_BLK #(.N(48),.REGISTER(CREG),.RSTTYPE(RSTTYPE)) C0 (.in(C),.clk(CLK),.out(C_REG),.rst(RSTC),.en(CEC));
REG_BLK #(.N(18),.REGISTER(DREG),.RSTTYPE(RSTTYPE)) D0 (.in(D),.clk(CLK),.out(D_REG),.rst(RSTD),.en(CED));

OPERATOR #(.N(18)) PreOperator (.x(D_REG),.y(B0_REG),.opmode(OPMODE_REG[6]),.out(PREOUT),.cin(1'b0),.cout());
MUX21 #(.N(18)) MUX (.x(B0_REG),.y(PREOUT),.out(B1),.opmode(OPMODE_REG[4]));

REG_BLK #(.N(18),.REGISTER(B1REG),.RSTTYPE(RSTTYPE)) B1_REG (.in(B1),.clk(CLK),.out(BCOUT),.rst(RSTB),.en(CEB));
REG_BLK #(.N(18),.REGISTER(A1REG),.RSTTYPE(RSTTYPE)) A1 (.in(A0_REG),.clk(CLK),.out(A1_REG),.rst(RSTA),.en(CEA));
assign M_OUT = BCOUT * A1_REG;

REG_BLK #(.N(36),.REGISTER(MREG),.RSTTYPE(RSTTYPE)) M0 (.in(M_OUT),.clk(CLK),.out(M_REG),.rst(RSTM),.en(CEM));
assign M = M_REG;

generate
    if (CARRYINSEL == "CARRYIN") begin
        REG_BLK #(.N(1),.REGISTER(CARRYINREG),.RSTTYPE(RSTTYPE)) CYI (.in(CARRYIN),.clk(CLK),.out(CIN),.rst(RSTCARRYIN),.en(CECARRYIN));
    end
    else if (CARRYINSEL == "OPMODE5") begin
        REG_BLK #(.N(1),.REGISTER(CARRYINREG),.RSTTYPE(RSTTYPE)) CYI (.in(OPMODE_REG[5]),.clk(CLK),.out(CIN),.rst(RSTCARRYIN),.en(CECARRYIN));
    end
    else begin
        REG_BLK #(.N(1),.REGISTER(CARRYINREG),.RSTTYPE(RSTTYPE)) CYI (.in(OPMODE_REG[5]),.clk(CLK),.out(1'b0),.rst(RSTCARRYIN),.en(CECARRYIN));
    end
endgenerate

assign DAB = {D_REG[11:0],A1_REG,BCOUT};

MUX41 #(.N(48)) MUX_X (.x({12'b0,M_REG}),.y(P),.z(DAB),.opmode(OPMODE_REG[1:0]),.out(X));
MUX41 #(.N(48)) MUX_Z (.x(PCIN),.y(P),.z(C_REG),.opmode(OPMODE_REG[3:2]),.out(Z));

OPERATOR #(.N(48)) PostOperator (.x(Z),.y(X),.opmode(OPMODE_REG[7]),.out(POSTOUT),.cin(CIN),.cout(COUT));

REG_BLK #(.N(1),.REGISTER(CARRYOUTREG),.RSTTYPE(RSTTYPE)) CYO (.in(COUT),.clk(CLK),.out(CARRYOUT),.rst(RSTCARRYIN),.en(CECARRYIN));
assign CARRYOUTF = CARRYOUT;

REG_BLK #(.N(48),.REGISTER(PREG),.RSTTYPE(RSTTYPE)) P_REG (.in(POSTOUT),.clk(CLK),.out(P),.rst(RSTP),.en(CEP));
assign PCOUT = P;

endmodule