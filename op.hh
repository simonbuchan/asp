#ifndef INCLUDE_op
#define INCLUDE_op

enum class Op {

none,

colon,
semicolon,
comma,
dot,
ellipsis,
equal,
question,

plus,
minus,
mul,
div,
mod,
plusplus,
minusminus,

boolnot,
booland,
boolor,
bitnot,
bitand_,
bitor_,
bitxor,

equalequal,
langleequal,
rangleequal,

plusequal,
minusequal,
mulequal,
divequal,
modequal,

boolnotequal,
boolandequal,
boolorequal,
bitnotequal,
bitandequal,
bitorequal,
bitxorequal,

lparen,
lcurly,
lsquare,
langle,

rparen,
rcurly,
rsquare,
rangle,

};

const char* op_name(Op op);

#endif // INCLUDE_op
