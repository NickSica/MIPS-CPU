module CPU(input logic clk, w_en,
           input logic[31:0] machineCode);
    
    logic en_pc = 1'b1, en_IF = 1'b1;
    logic flush = 1'b0;
    logic pcSrc, aluSrc, regDst;
    logic[31:0] pc, instr, branchPC, rsData, rtData, imm, aluResult, w_regData, w_ramData, r_ramData;
    logic[4:0] rd;
    logic[1:0] aluOp;
    
    InstructionFetch instrFetch(.clk, .pcSrc, .en_pc, .en_IF, .flush, .w_en, .branchPC, .machineCode,
                                .pc, .instr);
    IFtoID if_id(.clk, .tmpPC(pc), .tmpInstr(instr));
                                
    InstructionDecode instrDec(.if_id, .w_reg(mem_wb.w_reg), .clk, .prevRt(id_ex.rt), .w_regData,
                               .id_ex, .regDst, .aluSrc, .pcSrc, .branchPC, .flush, .en_pc, .en_IF, .aluOp, .imm, .rsData, .rtData);
    IDtoEX id_ex(.clk, .tmpInstr(if_id.instr), .tmpRsData(rsData), .tmpRtData(rtData));
     
    Execute exe(.ex(id_ex.ex), .fwdMEM(ex_mem.fwd), .fwdWB(mem_wb.fwd), .aluSrc, .regDst, .aluOp, .imm, .w_ramData, .aluResult);                   
    EXtoMEM ex_mem(.ex(id_ex.ex), .clk, .tmpRd(rd), .tmpResult(aluResult));
  
    Memory mem(.clk, .memWrite(ex_mem.memWrite), .addr(ex_mem.aluResult), .w_data(w_ramData), .r_data(r_ramData));
    MEMtoWB mem_wb(.clk, .mem(ex_mem.mem)); 
    
    Writeback wb(.memToReg(mem_wb.memToReg), .r_ramData, .aluResult(mem_wb.aluResult),
                 .w_regData);
endmodule: CPU