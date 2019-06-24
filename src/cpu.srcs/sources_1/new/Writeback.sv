`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 09:53:29 PM
// Design Name: 
// Module Name: Writeback
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


module Writeback(input logic memToReg,
                 input logic[31:0] r_ramData, aluResult,
                 output logic[31:0] w_regData);
                 
    always_comb begin
        case(memToReg)
            1'b0: w_regData = r_ramData;
            1'b1: w_regData = aluResult;
        endcase 
    end 
endmodule
