#ifndef INCLUDE_lex_as3
#define INCLUDE_lex_as3

#include <string>

enum class Tok {

end = -1,
none,
keyword,
identifier,
op,
number,
comment,
string,
xml,

};

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

extern int as3lineno;
extern char* as3text;

struct token {
    int line = as3lineno;
    Tok tok = Tok::none;
    Op op = Op::none;
    std::string text = as3text;

    token(Tok tok) : tok(tok) {}
    token(Op op) : tok(Tok::op), op(op) {}
    token(Tok tok, std::string text);

    explicit operator bool() { return tok > Tok::none; }
};

token as3lex();

#endif

