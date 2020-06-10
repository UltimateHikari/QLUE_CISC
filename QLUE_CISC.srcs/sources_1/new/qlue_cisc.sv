`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2020 01:01:41 PM
// Design Name: 
// Module Name: qlue_cisc
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

// 9-bit
module qlue_cisc(
    input clk,
    input reset
    );

logic [5:0] ip;
logic [8:0] acc, d_out;   
logic [2:0] inst_c;
logic [5:0] inst_a;

//-- MCU
enum logic [3:0] {halt      = 4'b0000,  
                  inst_addr = 4'b0001,
                  inst_read = 4'b0010,
                  decode    = 4'b0011,
                  load_read = 4'b0100,
                  load      = 4'b0101,
                  store     = 4'b0110,
                  add_read  = 4'b0111,
                  add       = 4'b1000,
                  mult_read = 4'b1001,
                  mult      = 4'b1010,
                  decrement = 4'b1011,
                  branch    = 4'b1100} state;

parameter ht = 3'b000;                  
parameter ld = 3'b001;
parameter st = 3'b010;
parameter ad = 3'b011;
parameter mp = 3'b100;
parameter dc = 3'b101;
parameter br = 3'b111;

always @(posedge clk or posedge reset)
    if (reset) begin
         state <= inst_addr;
    end
    else
        case (state)
            inst_addr: state <= inst_read;
            inst_read: state <= decode;
            decode:    case (inst_c)
                            ld: state <= load_read;
                            st: state <= store;
                            ad: state <= add_read;
                            mp: state <= mult;
                            dc: state <= decrement;
                            br: state <= branch;
                            ht: state <= halt;
                       endcase
            load_read: state <= load;
            add_read:  state <= add;
            mult_read: state <= mult;
            load:      state <= inst_addr;
            store:     state <= inst_addr;
            add:       state <= inst_addr;
            mult:      state <= inst_addr;
            decrement: state <= inst_addr;
            branch:    state <= inst_addr;
            halt:      state <= halt;
        endcase

//---- IP
always @(posedge clk or posedge reset)
    if (reset) begin
        ip <= 6'b000000;
    end
    else if ((state == load) | (state == store) | (state == add) | (state == decrement) | (ip == mp))
        ip = ip + 1;
    else if ((state == branch))
        if(acc == 0)
            ip <= inst_a;
        else
            ip <= ip + 1;
                     
//---- Acc + Alu
always @(posedge clk or posedge reset) begin
    if (reset) 
        acc <= 6'b000000;
    else if (state == load)
        acc <= d_out;
    else if (state == add)
        acc <= acc + d_out;
    else if (state == mult)
        acc <= acc * d_out;
    else if (state == decrement)
        acc <= acc - 1;
end
    
//---- IR
always @(posedge clk or posedge reset)
    if (reset) begin
        inst_c = 3'b000;
        inst_a = 6'b000000;
    end
    else if (state == inst_read) begin
        inst_a = d_out[5:0];
        inst_c = d_out[8:6];
    end
//---- Mem    
logic [8:0] ram [63:0];

initial $readmemb("memory.mem", ram, 0, 63);

always @(posedge clk)
    if(state == store)
        ram[inst_a] <= acc;

always @(posedge clk)
    d_out <= ram[((state == inst_addr) ? ip : inst_a)];
    
endmodule
