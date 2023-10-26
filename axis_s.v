`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2023 19:03:15
// Design Name: 
// Module Name: axis_s
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


module axis_s(input areset_n,
              input aclk,
              output reg [31:0] data,   // data that axis slave will receive
              input ready,      // user app is reafy to accept data, no slave can receive a data
              
              output reg tready,
              input tvalid,
              input tlast,
              input [31:0] tdata,
              
              output reg finish     // transaction is completed   
    );
    
    // handshake happens between master and slave
    wire handshake;
    assign handshake = tvalid & tready;

    // tready 
    always @(posedge aclk)
    begin
        if(~areset_n)
            tready <= 1'b0;
        else if(ready && ~tready) // first time ready comes
            tready <= 1'b1;
        else if(handshake)  // handshake happen, read goes low
            tready <= 1'b0;
        else if( tready && ~ready && ~tvalid)   // keep tready high, when user disables ready
            tready <= 1'b1;
        else
            tready <= tready;   // keep the value of tready                          
    end
    
    // data
    always @(posedge aclk)
    begin
        if(~areset_n)
            data <= 1'b0;
        else if(handshake)
            data <= tdata;
        else
            data <= data;        
    end
    
    // finish
    always @(posedge aclk)
    begin
        if(~areset_n)
            finish <= 1'b0;
        else if(handshake)
            finish <= 1'b1;
        else if(finish == 1 && ready)
            finish <= 0;
        else
            finish <= finish;                
    end 
endmodule
