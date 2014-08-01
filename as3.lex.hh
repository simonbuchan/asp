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

lparen,
lcurly,
lbracket,

rparen = -lparen,
rcurly = -lcurly,
rbracket = -lbracket,

};

extern int as3lineno;

struct token {
    int line = as3lineno;
    Tok tok = Tok::none;
    Op op = Op::none;
    std::string text;

    token(Tok tok) : tok(tok) {}
    token(Op op) : tok(Tok::op), op(op) {}
    token(Tok tok, std::string text);

    explicit operator bool() { return tok > Tok::none; }
};

token as3lex();

#endif

