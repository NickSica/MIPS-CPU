`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 03:15:08 PM
// Design Name: 
// Module Name: Control
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

module Control(input logic inhibitControl,
               input logic[31:0] instr,
               IDtoEX id_ex,
               output logic[1:0] aluOp, 
               output logic regDst, aluSrc, beq, bne);
    
    always_comb begin
        if(inhibitControl == 1'b0) begin
            case(instr[31:26])
                6'b000000: begin        // Opcode 0- ALU stuff
                    aluOp    = 2'b10;
                    regDst   = 1'b1;
                    aluSrc   = 1'b0;
                    beq      = 1'b0;
                    bne      = 1'b0;
                    id_ex.memWrite = 4'b0000;
                    id_ex.memRead  = 1'b0;
                    id_ex.regWrite = 1'b1;
                end   
                    
                6'b000100: begin        // Opcode 4- BEQ
                    aluOp    = 2'b01;
                    aluSrc   = 1'b0;
                    beq      = 1'b1;
                    bne      = 1'b0;
                    id_ex.memWrite = 4'b0000;
                    id_ex.memRead  = 1'b0;
                    id_ex.regWrite = 1'b0;
                end
                    
                6'b000101: begin        // Opcode 5- BNE
                    aluOp    = 2'b01;
                    aluSrc   = 1'b0;
                    beq      = 1'b0;
                    bne      = 1'b1;
                    id_ex.memWrite = 4'b0000;
                    id_ex.memRead  = 1'b0;
                    id_ex.regWrite = 1'b0;
                end
                
                6'b001000: begin        // Opcode 8- ADDI
                    aluOp    = 2'b00;
                    regDst   = 1'b0;
                    aluSrc   = 1'b1;
                    beq      = 1'b0;
                    bne      = 1'b0;
                    id_ex.memWrite = 4'b0000;
                    id_ex.memRead  = 1'b0;
                    id_ex.memToReg = 1'b1;
                    id_ex.regWrite = 1'b1;
                end
                
                6'b001010: begin        // Opcode 10- SLTI
                    aluOp    = 2'b01;
                    regDst   = 1'b0;
                    aluSrc   = 1'b1;
                    beq      = 1'b0;
                    bne      = 1'b0;
                    id_ex.memWrite = 4'b0000;
                    id_ex.memRead  = 1'b0;
                    id_ex.memToReg = 1'b1;
                    id_ex.regWrite = 1'b1;
                end          
                  
                6'b100011: begin        // Opcode 35- LW
                    aluOp    = 2'b00;
                    regDst   = 1'b0;
                    aluSrc   = 1'b1;
                    beq      = 1'b0;
                    bne      = 1'b0;
                    id_ex.memWrite = 4'b0000; 
                    id_ex.memRead  = 1'b1;
                    id_ex.memToReg = 1'b0;
                    id_ex.regWrite = 1'b1;
                end
                                
                6'b101011: begin        // Opcode 43- SW
                    aluOp    = 2'b00;
                    aluSrc   = 1'b1;
                    beq      = 1'b0;
                    bne      = 1'b0;
                    id_ex.memWrite = 4'b1111;
                    id_ex.memRead  = 1'b0;
                    id_ex.regWrite = 1'b0;
                end
            endcase;
        end else begin
            aluOp    = 2'b00;
            regDst   = 1'b0;
            aluSrc   = 1'b0;
            beq      = 1'b0;
            bne      = 1'b0;
            id_ex.memWrite = 4'b0000;
            id_ex.memRead  = 1'b0;
            id_ex.memToReg = 1'b0;
            id_ex.regWrite = 1'b0;
        end
    end 
endmodule: Control
