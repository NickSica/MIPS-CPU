`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 09:38:54 PM
// Design Name: 
// Module Name: InstructionDecode
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

module InstructionDecode(IFtoID if_id,
                         MEMtoWB.w_reg w_reg,
                         input logic clk,
                         input logic[4:0] prevRt,
                         input logic[31:0] w_regData,
                         IDtoEX id_ex,
                         output logic regDst, aluSrc,  pcSrc, branchPC, flush, en_pc, en_IF,
                         output logic[1:0] aluOp,
                         output logic[31:0] imm, rsData, rtData);
    logic inhibitControl = 1'b0, beq, bne, memRead;
    logic[4:0] rtNext;
    
    HazardDetection hazDet(.memRead, .branchTaken(pcSrc), .prevRt, .rt(if_id.instr[20:16]), .rs(if_id.instr[25:21]), 
                           .inhibitControl, .flush, .en_pc, .en_IF);
                           
    RegisterFile regFile(.clk, .rst(1'b0), .w_en(w_reg.regWrite), .rd(w_reg.rd), .rs(if_id.instr[25:21]), .rt(if_id.instr[20:16]), .rdData(w_regData),
                         .rsData, .rtData);
                         
    Control ctrl(.inhibitControl, .instr(if_id.instr), 
                 .id_ex, .aluOp, .regDst, .aluSrc, .beq, .bne);
    
    always_comb begin        
        pcSrc = ((rsData == rtData) & beq) | ((rsData != rtData) & bne);  // Branch logic
        branchPC = 32'(32'(imm << 2) + if_id.pc);  // Branch logic
        memRead = id_ex.memRead;
        imm <= { {16{if_id.instr[15]}}, if_id.instr[15:0] };
    end
endmodule
