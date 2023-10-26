`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2023 18:23:18
// Design Name: 
// Module Name: axis_m
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


module axis_m(input aclk,
              input areset_n,
              input [31:0] data,
              input send,
              
              // axi sampling
              input tready,
              output reg tvalid,
              output tlast,
              output reg [31:0] tdata,
              
              output reg finish
    );
    
    reg [31:0] data_buf;    // buffer to keep the data from change
    always @(posedge send, negedge areset_n)
    begin
        if(~areset_n)
            data_buf <= 0;
        else
            data_buf <= data;    
    end
    
    reg send_pulse_1d, send_pulse_2d; // just delay the send signal
    always@(posedge aclk)
    begin
        if(~areset_n)
            {send_pulse_1d, send_pulse_2d} <= 2'b00;
        else
            {send_pulse_1d, send_pulse_2d} <= {send, send_pulse_1d};                
    end
    
    // handshake happen b/w master and slave
    wire handshake;
    assign handshake = tvalid & tready; // when both tready and tvalid signal will be high then only handshake will happen
    
    // tdata
    always@(posedge aclk)
    begin
        if(~areset_n)
            tdata <= 1'b0;
        else if(handshake)
            tdata <= 0;
        else if(send_pulse_1d)
            tdata <= data_buf;
        else
            tdata <= tdata;                
    end
    
    // tvalid
    // as soon as the fifo becomes no empty tvalid goes high
    always@(posedge aclk)
    begin
        if(~areset_n)
            tvalid <= 1'b0;
        else if(handshake)
            tvalid <= 1'b0;
        else if(send_pulse_1d)
            tvalid <= 1'b1;
        else
            tvalid <= tvalid;                           
    end 
    
    // tlast
    // same behaviour as tvalid
    assign tlast = tvalid;
    
    // finish
    always@(posedge aclk)
    begin
        if(~areset_n)
            finish <= 1'b0;
        else if(send_pulse_1d)
            finish <= 1'b0;
        else if(handshake)
            finish <= 1'b1;
        else
            finish <= 1'b0;            
    end
endmodule
