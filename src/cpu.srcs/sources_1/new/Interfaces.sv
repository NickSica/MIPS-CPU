interface IFtoID(input logic clk,
                 input logic[31:0] tmpPC, tmpInstr);
    logic[31:0] pc, instr;
    
    always_ff @(posedge clk) begin
        instr <= tmpInstr;
        pc <= tmpPC;
    end 
endinterface: IFtoID

interface IDtoEX(input logic clk,
                 input logic[31:0] tmpInstr, tmpRsData, tmpRtData, tmpImm);
    logic memWrite, memRead, memToReg, regWrite;
    logic[4:0] rs, rt, rd;
    logic[31:0] instr, imm, rsData, rtData;   
    
    always_ff @(posedge clk) begin
        instr <= tmpInstr;
        rs <= tmpInstr[25:21];
        rt <= tmpInstr[20:16];
        rd <= tmpInstr[15:11];
        rsData <= tmpRsData;
        rtData <= tmpRtData;
        imm <= tmpImm; 
    end
    
    modport ex(input memWrite, regWrite, memToReg, rs, rt, rd, rsData, rtData);
endinterface: IDtoEX

interface EXtoMEM(IDtoEX.ex ex,
                  input logic clk,
                  input logic[4:0] tmpRd,
                  input logic[31:0] tmpResult);
    logic memWrite, regWrite, memToReg;
    logic[4:0] rd;
    logic[31:0] aluResult;
    
    always_ff @(posedge clk) begin
        memWrite  <= ex.memWrite;
        regWrite  <= ex.regWrite;
        memToReg  <= ex.memToReg;
        rd        <= ex.rd;
        aluResult <= tmpResult;
    end
    
    modport mem(input regWrite, memToReg, rd, aluResult);
    modport fwd(input regWrite, aluResult, rd);
endinterface: EXtoMEM

interface MEMtoWB(EXtoMEM.mem mem,
                  input logic clk);
    logic regWrite, memToReg;
    logic[4:0] rd;
    logic[31:0] aluResult;
    
    always_ff @(posedge clk) begin
        rd        <= mem.rd;
        aluResult <= mem.aluResult;
        regWrite  <= mem.regWrite;
        memToReg  <= mem.memToReg;
    end
    
    modport mux(input memToReg, aluResult);
    modport fwd(input rd, regWrite, aluResult);
    modport w_reg(input regWrite, rd);
endinterface: MEMtoWB