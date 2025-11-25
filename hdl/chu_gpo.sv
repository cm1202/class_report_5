module chu_gpo
   #(parameter W = 8)  // width of output port
   (
    input  logic clk,
    input  logic reset,
    // slot interface
    input  logic cs,
    input  logic read,
    input  logic write,
    input  logic [4:0] addr,
    input  logic [31:0] wr_data,
    output logic [31:0] rd_data,
    // external port    
    output logic [W-1:0] dout
   );

   // declaration
   logic [15:0] led_speed_0, led_speed_1, led_speed_2,led_speed_3;
   logic wr_en;


   // body
   // output buffer register
   always_ff @(posedge clk, posedge reset)
      if (reset)begin 
         led_speed_0 <= 16'b0;
         led_speed_1 <= 16'b0;
         led_speed_2 <= 16'b0;
         led_speed_3 <= 16'b0;
      end 

      else   
         if (wr_en)begin 
         case (addr)
            0: led_speed_0 <= wr_data[W-1:0];
            1: led_speed_1 <= wr_data[W-1:0];
            2: led_speed_2 <= wr_data[W-1:0];
            3: led_speed_3 <= wr_data[W-1:0];
      
            endcase 
        end 
    blink_controller led0(
    .clk(clk),
    .rst(reset),
    .speed(led_speed_0),
    .led(dout[0])
    );
    
    blink_controller led1(
    .clk(clk),
    .rst(reset),
    .speed(led_speed_1),
    .led(dout[1])
    );    
    
    blink_controller led2(
    .clk(clk),
    .rst(reset),
    .speed(led_speed_2),
    .led(dout[2])
    );
    
    blink_controller led3(
    .clk(clk),
    .rst(reset),
    .speed(led_speed_3),
    .led(dout[3])
    );
        
   // decoding logic 
   assign wr_en = cs && write;
   // slot read interface
   assign rd_data =  0;
   // external output  
   assign dout[W-1:4] = 0;

endmodule
       



