`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2023 18:48:34
// Design Name: 
// Module Name: tb_axis_m
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


module tb_axis_m();
    bit aclk, areset_n, send;
    logic finish;
    
    logic tready;
    logic tvalid, tlast;
    logic [31:0] tdata;
    logic [31:0] data;
    
    // cloking block
    default clocking 
        cb@(posedge aclk);
    endclocking
    
    axis_m inst_axis_m(.areset_n(areset_n),
                       .aclk(aclk),
                       .data(data),
                       .send(send),
                       .tready(tready),
                       .tvalid(tvalid),
                       .tlast(tlast),
                       .tdata(tdata),
                       .finish(finish));
    initial
        forever #2 aclk++;
                               
    initial
    begin
        areset_n <= 0;
        ##4 areset_n <= 1;    
    end  
    
    initial
    begin
        ##6  send = 1;
        ##1  send = 0;
        ##12 send = 1;
        ##1  send = 0;
    end  
    
    initial
    begin
        tready = 0;
        ##15 tready = 1;
        ##1  tready = 0;
        ##8  tready = 1;
        ##1  tready = 0;
    end
    
    initial
    begin
        data <= 32'haaaa_bbbb;
        ##15 data <= 32'hcccc_dddd;
    end                                        
    
    initial
        ##40 $finish;       
endmodule
