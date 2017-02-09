module bbc_project(clk, reset_n, leds);
   
   input clk         //synthesis altera_chip_pin_lc="@AF14"
         ; // clock_50 : 
   input reset_n     //synthesis altera_chip_pin_lc="@Y16"
         ; // key 3: 
   output [7:0] leds //synthesis altera_chip_pin_lc="@W20,@Y19,@W19,@W17,@V18,@V17,@W16,@V16"
                ; // LEDS: 
   
   wire         host_sram_request__valid;
   wire         host_sram_request__read_enable;
   wire         host_sram_request__write_enable;
   wire[7:0]    host_sram_request__select;
   wire[23:0]   host_sram_request__address;
   wire[63:0]   host_sram_request__write_data;
   wire         csr_request__valid;
   wire         csr_request__read_not_write;
   wire[15:0]   csr_request__select;
   wire[15:0]   csr_request__address;
   wire[31:0]   csr_request__data;

   wire         display_sram_write__enable;
   wire[47:0]   display_sram_write__data;
   wire[15:0]   display_sram_write__address;
   wire         host_sram_response__ack;
   wire         host_sram_response__read_data_valid;
   wire[63:0]   host_sram_response__read_data;
   wire         csr_response__ack;
   wire         csr_response__read_data_valid;
   wire[31:0]   csr_response__read_data;

   wire   video_bus__vsync;
   wire   video_bus__hsync;
   wire   video_bus__display_enable;
   wire [7:0] video_bus__red;
   wire [7:0] video_bus__green;
   wire [7:0] video_bus__blue;


    assign host_sram_request__valid=0;
    assign host_sram_request__read_enable=0;
    assign host_sram_request__write_enable=0;
    assign host_sram_request__select=0;
    assign host_sram_request__address=0;
    assign host_sram_request__write_data=0;

    assign csr_request__valid=0;
    assign csr_request__read_not_write=0;
    assign csr_request__select=0;
    assign csr_request__address=0;
    assign csr_request__data=0;

    assign leds = display_sram_write__data[7:0];
   // e.g. output [7:0] sum /* synthesis altera_chip_pin_lc="@17, @166, @191, @152, @15, @148, @147, @149" */;
   // pin assignments
   // GPIO1
   // 35: AC22 JP2.40  LCD R
   // 34: AA20 JP2.39  LCD R
   // 33: AD21 JP2.38  LCD R
   // 32: AE22 JP2.37  LCD R
   // 31: AF23 JP2.36  LCD R
   // 30: AF24 JP2.35  LCD R
   // 29: AG22 JP2.34  LCD G
   // 28: AH22 JP2.33  LCD G
   // 27: AJ22 JP2.32  LCD G
   // 26: AK22 JP2.31  LCD G
   // 25: AH23 JP2.28  LCD G
   // 24: AK23 JP2.27  LCD G
   // 23: AG23 JP2.26  LCD G
   // 22: AK24 JP2.25  LCD B
   // 21: AJ24 JP2.24  LCD B
   // 20: AJ25 JP2.23  LCD B
   // 19: AH25 JP2.22  LCD B
   // 18: AK26 JP2.21  LCD B
   // 17: AJ26 JP2.20  LCD B
   // 16: AK27 JP2.19  LCD CLK = (5,9,12)MHz
   // 15: AK28 JP2.18  LCD DISP (display on/off)
   // 14: AK29 JP2.17  LCD HSYNCn - 1 clock, active low; 55 to 65ns period (520,525,800) ticks; (36,40,255) back porch, (4,5,65) front porch
   // 13: AJ27 JP2.16  LCD VSYNCn - 1 HSYNCn period, going low with HSYNCd, high with HSYNCn; 277,288,400 (min, typ, max) H periods for a VSYNCn period; (3,8,31) back porch; (2,8,97) front porch
   // 12: AH27 JP2.15  LCD DEN - high for 480 clocks per line, data valid; no data during porches; 272 periods per vsync
   // 11: AH24 JP2.14  J3   Touch SDA
   // 10: AG26 JP2.13  J3   Touch SCL
   //  9: AG25 JP2.10  Q1   BSS138 G (AdaFruit/Neopixel LED chain in)
   //  8: AF26 JP2.9   J3   Touch WAKE
   //  7: AF25 JP2.8   IC6  74LS165 CLK
   //  6: AE24 JP2.7 SW8
   //  5: AE23 JP2.6   IC6  74LS165 SH/LDn
   //  4: AD24 JP2.5 SW8
   //  3: AC23 JP2.4   IC6  74LS165 QHn (joystick nsew/in, rotary switch, touchpad interrupt, SW8/9)
   //  2: AB21 JP2.3 SW9
   //  1: AA21 JP2.2   IC1  FAN5333 SHDN (backlight)
   //  0: AB17 JP2.1 SW9
   // LEDs
   //  9: Y21
   //  8: W21
   //  7: W20
   //  6: Y19
   //  5: W19
   //  4: W17
   //  3: V18
   //  2: V17
   //  1: W16
   //  0: V16
   // Keys - pushbuttons
   //  0: AA14
   //  1: AA15
   //  2: W15
   //  3: Y16
   // Slide switches
   //  0: AB12
   //  1: AC12
   //  2: AF9
   //  3: A
   //  4: A
   //  5: AD12
   //  6: A
   //  7: A
   //  8: A
   //  9: A
   // VGA
   //  R7-0: F13,E12,D12,C12,B12,E13,C13,A13
   //  G7-0: E11,F11,G12,G11,G10,H12,G1,G0
   //  B7-0: J14,G15,F15,H14,F14,H13,G13,B13
   //  VGA_BLANK_N: F10
   //  VGA_VSYNC_N: D11
   //  VGA_HSYNC_N: B11
   //  VGA_SYNC_N:  C10
   //  VGA_CLK:     A11
   
   bbc_micro_with_rams bbc( .clk(clk),
                            .clk__enable(1'b1),
                            .video_clk(video_clk),
                            .video_clk__enable(1'b1),
                            .reset_n(reset_n),

                            .host_sram_request__valid(host_sram_request__valid),
                            .host_sram_request__read_enable(host_sram_request__read_enable),
                            .host_sram_request__write_enable(host_sram_request__write_enable),
                            .host_sram_request__select(host_sram_request__select),
                            .host_sram_request__address(host_sram_request__address),
                            .host_sram_request__write_data(host_sram_request__write_data),
                            .csr_request__valid(csr_request__valid),
                            .csr_request__read_not_write(csr_request__read_not_write),
                            .csr_request__select(csr_request__select),
                            .csr_request__address(csr_request__address),
                            .csr_request__data(csr_request__data),

                            .display_sram_write__enable(display_sram_write__enable),
                            .display_sram_write__data(display_sram_write__data),
                            .display_sram_write__address(display_sram_write__address),
                            .host_sram_response__ack(host_sram_response__ack),
                            .host_sram_response__read_data_valid(host_sram_response__read_data_valid),
                            .host_sram_response__read_data(host_sram_response__read_data),
                            .csr_response__ack(csr_response__ack),
                            .csr_response__read_data_valid(csr_response__read_data_valid),
                            .csr_response__read_data(csr_response__read_data),

                            .video_bus__vsync(video_bus__vsync),
                            .video_bus__hsync(video_bus__hsync),
                            .video_bus__display_enable(video_bus__display_enable),
                            .video_bus__red(video_bus__red),
                            .video_bus__green(video_bus__green),
                            .video_bus__blue(video_bus__blue)
      
                         );
   
endmodule
