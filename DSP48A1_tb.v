module DSP48A1_tb ();
    reg[17:0] A_tb,B_tb,D_tb,BCIN_tb;
    reg[47:0] C_tb,PCIN_tb;
    reg[7:0] OPMODE_tb;
    reg CARRYIN_tb,CLK_tb;
    reg CEA_tb,CEB_tb,CEC_tb,CECARRYIN_tb,CED_tb,CEM_tb,CEOPMODE_tb,CEP_tb;
    reg RSTA_tb,RSTB_tb,RSTC_tb,RSTD_tb,RSTCARRYIN_tb,RSTM_tb,RSTOPMODE_tb,RSTP_tb;
    reg [35:0] M_exp;
    wire [35:0] M_tb;
    wire [47:0] P_dut;
    //wire [47:0] P_sec;
    reg [47:0] P_exp;
    wire [47:0] PCOUT_tb;
    wire CARRYOUT_tb,CARRYOUTF_tb;
    reg CARRYOUT_exp;
    wire [17:0] BCOUT_tb;
    //,BCOUT_tb2,PCOUT_tb2,CARRYOUTF_tb2,CARRYOUT_tb2,P_dut2,M_tb2;
    reg [17:0] BCOUT_exp;

    DSP48A1 
        DUT (.A(A_tb),.B(B_tb),.C(C_tb),.D(D_tb),.CLK(CLK_tb),
            .CARRYIN(CARRYIN_tb),.OPMODE(OPMODE_tb),.BCIN(BCIN_tb),.PCIN(PCIN_tb),
            .RSTA(RSTA_tb),.RSTB(RSTB_tb),.RSTC(RSTC_tb),.RSTD(RSTD_tb),.RSTM(RSTM_tb),.RSTP(RSTP_tb),.RSTCARRYIN(RSTCARRYIN_tb),.RSTOPMODE(RSTOPMODE_tb),
            .CEA(CEA_tb),.CEB(CEB_tb),.CEC(CEC_tb),.CED(CED_tb),.CEM(CEM_tb),.CEP(CEP_tb),.CECARRYIN(CECARRYIN_tb),.CEOPMODE(CEOPMODE_tb),
            .BCOUT(BCOUT_tb),.PCOUT(PCOUT_tb),.P(P_dut),.M(M_tb),.CARRYOUT(CARRYOUT_tb),.CARRYOUTF(CARRYOUTF_tb)); 
      

    initial begin
        CLK_tb = 0;
        forever begin
            #1 CLK_tb = ~CLK_tb;
        end
    end        

    initial begin
        RSTA_tb = 1; RSTB_tb = 1; RSTC_tb = 1; RSTD_tb = 1;
        RSTM_tb = 1; RSTP_tb = 1; RSTCARRYIN_tb = 1; RSTOPMODE_tb = 1;
    ////////////////////////////////////////////////////////////////////////////////
        A_tb = 18'd13; B_tb = 18'd25; C_tb = 48'd5; D_tb = 18'd59;
        PCIN_tb = 48'd25; BCIN_tb = 18'd17; CARRYIN_tb = 1;
        OPMODE_tb = 8'b0000_0001;
        @(negedge CLK_tb);

        if (P_dut != 48'd0)begin
            $display("P mismatch: P = %0d", P_dut);
            $stop;
        end    
        if (M_tb != 36'd0)begin
            $display("M mismatch: M = %0d", M_tb);
            $stop;
        end    
        if (BCOUT_tb != 18'd0)begin
            $display("BCOUT mismatch: BCOUT = %0d", BCOUT_tb);
            $stop;
        end    
        if (PCOUT_tb != 48'd0)begin
            $display("PCOUT mismatch: PCOUT = %0d", PCOUT_tb);
            $stop;
        end    
        if (CARRYOUT_tb != 1'b0)begin
            $display("CARRYOUT mismatch: CARRYOUT = %0d", CARRYOUT_tb);
            $stop;
        end    
        if (CARRYOUTF_tb != 1'b0)begin
            $display("CARRYOUTF mismatch: CARRYOUTF = %0d", CARRYOUTF_tb);
            $stop;
        end    
    ///////////////////////////////////////////////////////Path 1
        RSTA_tb = 0; RSTB_tb = 0; RSTC_tb = 0; RSTD_tb = 0;
        RSTM_tb = 0; RSTP_tb = 0; RSTCARRYIN_tb = 0; RSTOPMODE_tb = 0;

        CEA_tb = 1; CEB_tb = 1; CEC_tb = 1; CED_tb = 1;
        CEM_tb = 1; CEP_tb = 1; CECARRYIN_tb = 1; CEOPMODE_tb = 1;
    
        A_tb = 18'd20; B_tb = 18'd10; C_tb = 48'd350; D_tb = 18'd25;
        PCIN_tb = 48'd5; BCIN_tb = 18'd15; CARRYIN_tb = 0; OPMODE_tb = 8'b1101_1101;
        repeat(4)@(negedge CLK_tb);
        P_exp = 48'h32; M_exp = 36'h12c; BCOUT_exp = 18'hf; CARRYOUT_exp = 0;

        if (P_dut != P_exp)begin
            $display("P mismatch: P = %0d", P_dut);
            $stop;
        end
        if (M_tb != M_exp)begin
            $display("M mismatch: M = %0d", M_tb);
            $stop;
        end
        if (BCOUT_tb != BCOUT_exp)begin
            $display("BCOUT mismatch: BCOUT = %0d", BCOUT_tb);
            $stop;
        end
        if (PCOUT_tb != P_exp)begin
            $display("PCOUT mismatch: PCOUT = %0d", PCOUT_tb);
            $stop;
        end
        if (CARRYOUT_tb != CARRYOUT_exp)begin
            $display("CARRYOUT mismatch: CARRYOUT = %0d", CARRYOUT_tb);
            $stop;
        end
        if (CARRYOUTF_tb != CARRYOUT_exp)begin
            $display("CARRYOUTF mismatch: CARRYOUTF = %0d", CARRYOUTF_tb);
            $stop;
        end
        $display("Path 1 passed");
    ///////////////////////////////////////////////////////Path 2
        A_tb = 18'd20; B_tb = 18'd10; C_tb = 48'd350; D_tb = 18'd25;
        PCIN_tb = 48'd5; BCIN_tb = 18'd15; CARRYIN_tb = 0; OPMODE_tb = 8'b0001_0000;
        repeat(3)@(negedge CLK_tb);
        P_exp = 48'h0; M_exp = 36'h2bc; BCOUT_exp = 18'h23; CARRYOUT_exp = 0;

        if (P_dut != P_exp)begin
            $display("P mismatch: P = %0d", P_dut);
            $stop;
        end
        if (M_tb != M_exp)begin
            $display("M mismatch: M = %0d", M_tb);
            $stop;
        end
        if (BCOUT_tb != BCOUT_exp)begin
            $display("BCOUT mismatch: BCOUT = %0d", BCOUT_tb);
            $stop;
        end
        if (PCOUT_tb != P_exp)begin
            $display("PCOUT mismatch: PCOUT = %0d", PCOUT_tb);
            $stop;
        end
        if (CARRYOUT_tb != CARRYOUT_exp)begin
            $display("CARRYOUT mismatch: CARRYOUT = %0d", CARRYOUT_tb);
            $stop;
        end
        if (CARRYOUTF_tb != CARRYOUT_exp)begin
            $display("CARRYOUTF mismatch: CARRYOUTF = %0d", CARRYOUTF_tb);
            $stop;
        end
        $display("Path 2 passed");    
        ///////////////////////////////////////////////////////Path 3
        A_tb = 18'd20; B_tb = 18'd10; C_tb = 48'd350; D_tb = 18'd25;
        PCIN_tb = 48'd5; BCIN_tb = 18'd15; CARRYIN_tb = 0; OPMODE_tb = 8'b0000_1010;
        repeat(3)@(negedge CLK_tb);
        M_exp = 36'hc8; BCOUT_exp = 18'ha;

        if (P_dut != P_exp)begin
            $display("P mismatch: P = %0d", P_dut);
            $stop;
        end
        if (M_tb != M_exp)begin
            $display("M mismatch: M = %0d", M_tb);
            $stop;
        end
        if (BCOUT_tb != BCOUT_exp)begin
            $display("BCOUT mismatch: BCOUT = %0d", BCOUT_tb);
            $stop;
        end
        if (PCOUT_tb != P_exp)begin
            $display("PCOUT mismatch: PCOUT = %0d", PCOUT_tb);
            $stop;
        end
        if (CARRYOUT_tb != CARRYOUT_exp)begin
            $display("CARRYOUT mismatch: CARRYOUT = %0d", CARRYOUT_tb);
            $stop;
        end
        if (CARRYOUTF_tb != CARRYOUT_exp)begin
            $display("CARRYOUTF mismatch: CARRYOUTF = %0d", CARRYOUTF_tb);
            $stop;
        end
        $display("Path 3 passed");    
        ///////////////////////////////////////////////////////Path 4
        A_tb = 18'd5; B_tb = 18'd6; C_tb = 48'd350; D_tb = 18'd25;
        PCIN_tb = 48'd3000; BCIN_tb = 18'd15; CARRYIN_tb = 0; OPMODE_tb = 8'b1010_0111;
        repeat(3)@(negedge CLK_tb);
        P_exp = 48'hfe6fffec0bb1; M_exp = 36'h1e; BCOUT_exp = 18'h6; CARRYOUT_exp = 1;

        if (P_dut != P_exp)begin
            $display("P mismatch: P = %0d", P_dut);
            $stop;
        end
        if (M_tb != M_exp)begin
            $display("M mismatch: M = %0d", M_tb);
            $stop;
        end
        if (BCOUT_tb != BCOUT_exp)begin
            $display("BCOUT mismatch: BCOUT = %0d", BCOUT_tb);
            $stop;
        end
        if (PCOUT_tb != P_exp)begin
            $display("PCOUT mismatch: PCOUT = %0d", PCOUT_tb);
            $stop;
        end
        if (CARRYOUT_tb != CARRYOUT_exp)begin
            $display("CARRYOUT mismatch: CARRYOUT = %0d", CARRYOUT_tb);
            $stop;
        end
        if (CARRYOUTF_tb != CARRYOUT_exp)begin
            $display("CARRYOUTF mismatch: CARRYOUTF = %0d", CARRYOUTF_tb);
            $stop;
        end
        $display("All directed tests PASSED.");    
        $stop;
    end

    initial begin
    $monitor("T=%0t | Expected P=%0d , Actual P=%0d , PCOUT=%0d| M=%0d , Actual M=%0d | BCOUT=%0d , Actual BCOUT=%0d| CARRYOUT=%b , Actual COUT=%0d | CARRYOUTF=%d",
             $time, P_exp, P_dut,PCOUT_tb, M_exp,M_tb, BCOUT_exp,BCOUT_tb, CARRYOUT_exp,CARRYOUT_tb,CARRYOUTF_tb);
end
endmodule
