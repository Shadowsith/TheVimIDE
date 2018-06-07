// Include module declaration in a comment
// module wrong;
// endmodule
`define DEFINE
`define DEF_WITH_EQ = 1'd100
`define DEF_VALUE   1'd100

class test;
    reg a;
    logic b;
    enum {enum_simple1, enum_simple2} enum_simple;
    enum {enum_const1, enum_const2} enum_var1, enum_var2;
    enum bit [1:0] {
      enum_bit1,
      enum_bit2='x,
      enum_bit3=2'b01,
      enum_bit4[0:10]=2'b10,
      enum_bit5 [9:0] = 2'b10 ,
    } enum_complex;
    function mult (a, input b = 0);
        return a * b;
    endfunction : mult

    extern virtual function void extern_func (input bit a, input b);

endclass : test

class supertest extends test;
    logic c;
    extern virtual function bit fwrd_ref;
    function mult (a, input b = 0);
        return a * b * 2;
    endfunction : mult
endclass : test

class paramtest #(type BASE=supertest #(test)) extends BASE;
endclass : paramtest

class paramtest2 #(
  type BASE=supertest #(test)
) extends BASE;
endclass : paramtest2

class paramtest3 #(type BASE=supertest, type BASE2=paramtest);

virtual function myfunc (a, b);
endfunction

extern virtual function test ext_func (c, d);

endclass : paramtest3

function test paramtest3::ext_func (c, d);
endfunction

class test_attributes;
  static logic          static_logic;
  protected logic       protected_logic;
  local logic           local_logic;
  const static logic    const_static_logic;
  const protected logic const_protected_logic;
  const local logic     const_local_logic;
  rand logic            rand_logic;
  randc logic           randc_logic;
  const logic           const_logic;
endclass : test_attributes
