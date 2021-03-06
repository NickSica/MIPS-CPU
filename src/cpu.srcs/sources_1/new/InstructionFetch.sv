`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 09:28:06 PM
// Design Name: 
// Module Name: InstructionFetch
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


module InstructionFetch(input logic clk, pcSrc, en_pc, en_IF, flush, w_en,
                        input logic[31:0] branchPC, machineCode,
                        output logic[31:0] pc, instr);
    logic[31:0] tempPC = 32'b0, tempInstr;
    
    always_comb begin
        if(en_pc) begin
            case(pcSrc)
                1'b0: tempPC = pc;
                1'b1: tempPC = branchPC;
            endcase
        end 
        
        if(flush) begin
            instr = 32'b0;
        end else if(en_IF) begin
            instr = tempInstr;           
        end
    end
    
    always_ff @(posedge clk) begin
        if(en_pc) begin
            pc <= tempPC + 4;
        end
    end
    
    InstructionCache instrCache(.clk, .w_en, .w_instr(machineCode), .addr(tempPC), .instr(tempInstr));
endmodule
