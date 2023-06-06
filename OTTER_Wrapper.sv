`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: J. Calllenes
//           P. Hummel
// 
// Create Date: 01/20/2019 10:36:50 AM
// Design Name: 
// Module Name: OTTER_Wrapper 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.10 - (Keefe Johnson, 1/14/2020) Removed keyboard and VGA for
//                 simplicity. Removed UART to free up serial lines for the
//                 programmer. Added debouncer to reset button. Added serial
//                 programmer and performance counter (MCU clock cycles). Minor
//                 style changes.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module OTTER_Wrapper_Programmable(
    input CLK,
    input BTNL,
    input BTNC,
    input [15:0] SWITCHES,
    input RX,
    output TX,
    output [15:0] LEDS,
    output [7:0] CATHODES,
    output [3:0] ANODES,
    output [7:0] VGA_RGB,
    output VGA_HS,
    output VGA_VS
    );
       
    // INPUT PORT IDS ////////////////////////////////////////////////////////////
    localparam SWITCHES_AD = 32'h11000000;
    localparam CLKCNTLO_AD = 32'h11400000;
    localparam CLKCNTHI_AD = 32'h11400004;
    localparam VGA_READ_AD  = 32'h11040000;
           
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////////
    localparam LEDS_AD     = 32'h11080000;
    localparam SSEG_AD     = 32'h110C0000;
    localparam VGA_ADDR_AD  = 32'h11100000;
    localparam VGA_COLOR_AD = 32'h11140000;
    
    // Signals for connecting VGA Framebuffer Driver /////////////////////////////
    logic r_vga_we;             // write enable
    logic [12:0] r_vga_wa;      // address of framebuffer to read and write
    logic [7:0] r_vga_wd;       // pixel color data to write to framebuffer
    logic [7:0] r_vga_rd;       // pixel color data read from framebuffer
    
    // Signals for connecting OTTER_MCU to OTTER_wrapper /////////////////////////
    logic s_interrupt, s_reset;
    logic sclk = '0;

    // Registers for IOBUS ///////////////////////////////////////////////////////   
    logic [15:0] r_SSEG = '0;
    logic [15:0] r_LEDS = '0;
    logic [63:0] r_CLKCNT = '0;

    // Signals for IOBUS /////////////////////////////////////////////////////////
    logic [31:0] IOBUS_out, IOBUS_in, IOBUS_addr;
    logic IOBUS_wr;
   
    // Declare OTTER_CPU /////////////////////////////////////////////////////////
    OTTER_MCU MCU(.EXT_RESET(s_reset), .INTR(s_interrupt), .CLK(sclk), 
                  .IOBUS_OUT(IOBUS_out), .IOBUS_IN(IOBUS_in),
                  .IOBUS_ADDR(IOBUS_addr), .IOBUS_WR(IOBUS_wr),
                  .PROG_RX(RX), .PROG_TX(TX));

    // Declare Seven Segment Display /////////////////////////////////////////////
    SevSegDisp SSG_DISP(.DATA_IN(r_SSEG), .CLK(CLK), .MODE(1'b0),
                        .CATHODES(CATHODES), .ANODES(ANODES));

    // Connect LEDS register to port /////////////////////////////////////////////
    assign LEDS = r_LEDS;
   
    // Debounce/one-shot the reset and interrupt buttons /////////////////////////
    debounce_one_shot DB_I(.CLK(sclk), .BTN(BTNL), .DB_BTN(s_interrupt));
    debounce_one_shot DB_R(.CLK(sclk), .BTN(BTNC), .DB_BTN(s_reset));
   
    vga_fb_driver_80x60 VGA(.CLK_50MHz(sclk), .WA(r_vga_wa), .WD(r_vga_wd),
                            .WE(r_vga_we), .RD(r_vga_rd), .ROUT(VGA_RGB[7:5]),
                            .GOUT(VGA_RGB[4:2]), .BOUT(VGA_RGB[1:0]),
                            .HS(VGA_HS), .VS(VGA_VS));
   
    // Clock divider to create 50 MHz clock for MCU //////////////////////////////
    always_ff @(posedge CLK) begin
        sclk <= ~sclk;
    end
   
    // Performance counter (MCU clock cycles) ////////////////////////////////////
    always_ff @(posedge sclk) begin
        r_CLKCNT = r_CLKCNT + 1;
    end
   
    // Connect board peripherals (Memory Mapped IO devices) to IOBUS /////////////
    // Inputs
    always_comb begin
        IOBUS_in = 32'b0;
        case (IOBUS_addr)
            SWITCHES_AD: IOBUS_in[15:0] = SWITCHES;
            CLKCNTLO_AD: IOBUS_in = r_CLKCNT[31:0];
            CLKCNTHI_AD: IOBUS_in = r_CLKCNT[63:32];
            VGA_READ_AD: IOBUS_in[7:0] = r_vga_rd;
            default: IOBUS_in=32'b0;
        endcase
    end
    // Outputs
    always_ff @(posedge sclk) begin
        if (IOBUS_wr) begin
            case (IOBUS_addr)
                LEDS_AD: begin
                    r_LEDS <= IOBUS_out[15:0];
                end    
                SSEG_AD: begin
                    r_SSEG <= IOBUS_out[15:0];
                end
                VGA_ADDR_AD: begin
                    r_vga_wa <= IOBUS_out[12:0];
                end
                VGA_COLOR_AD: begin
                    r_vga_wd <= IOBUS_out[7:0];
                    r_vga_we <= 1;  
                end
            endcase
        end
    end
 
endmodule
