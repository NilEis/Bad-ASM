# Basm (Bad assembler)
This is a bad example of how to use Bison to implemement a asm-like language, thats why I called it Bad-assembler
## Notes:
- Memory
  - mem 4096b
  - flag-register
- instructions
  - mov dest, src
  - movf dest, src
  - cmp a,b   // (-1: a < b, 0: a = b, 1: a > b)
  - jmp label
- macros
  - print(template, v)
- operators
  - a + b     // add
  - a - b     // sub
  - a * b     // mul
  - a ** b    // pow
  - a / b     // div
  - a | b     // or
  - a & b     // and
  - a ^ b     // xor
  - ~a        // not
  - a << b    // shift left
  - a >> b    // shift right
