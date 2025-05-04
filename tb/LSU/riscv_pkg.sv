package riscv_pkg;
  parameter int CLK_FREQ = 100;
  typedef enum bit {
    LOAD  = 1'b0,
    STORE = 1'b1
  } we_e;
  typedef enum bit [1:0] {
    WORD  = 2'b00,
    HALF  = 2'b01,
    BYTE1 = 2'b10,
    BYTE2 = 2'b11
  } type_e;
  typedef enum bit [1:0] {
    ZERO_EXT = 2'b00,
    SIGN_EXT = 2'b01
  } extend_e;
endpackage
