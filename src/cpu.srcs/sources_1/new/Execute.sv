`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 09:53:04 PM
// Design Name: 
// Module Name: Execute
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Execute(IDtoEX.ex ex,  
               EXtoMEM.fwd fwdMEM,
               MEMtoWB.fwd fwdWB,
               input logic aluSrc, regDst,
               input logic[1:0] aluOp,
               input logic[31:0] imm,
               output logic[31:0] w_ramData, aluResult);

    logic[31:0] rtData, rsData;
    logic[3:0] ctrlSignal = 4'b0010;
    logic[1:0] forwardRs = 1'b0, forwardRt = 1'b0;
    
    ForwardingUnit fwdUnit(.fwdMEM, .fwdWB, .rs(ex.rs), .rt(ex.rt),
                           .forwardRs, .forwardRt);
                           
    ALUControl aluControl(.aluOp, .funct(imm[5:0]), .ctrlSignal);
    ALU alu(.ctrlSignal, .op1(rsData), .op2(rtData), .result(aluResult));
                         
    always_comb begin
        case(regDst)
            1'b0: ex.rd <= ex.rt;
            1'b1: ex.rd <= ex.rd;
        endcase
        
        case(forwardRs)
            2'b00: rsData <= ex.rsData;
            2'b01: rsData <= fwdWB.aluResult;
            2'b10: rsData <= fwdMEM.aluResult;
        endcase 
       
        case({forwardRt, aluSrc})
            3'bXX1: rtData <= imm;
            3'b000: rtData <= ex.rtData;
            3'b010: rtData <= fwdWB.aluResult;
            3'b100: rtData <= fwdMEM.aluResult;
        endcase
        
        case(forwardRt)
            2'b00: w_ramData <= ex.rtData;
            2'b01: w_ramData <= fwdWB.aluResult;
            2'b10: w_ramData <= fwdMEM.aluResult;
        endcase 
    end 
endmodule
