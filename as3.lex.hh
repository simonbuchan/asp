#ifndef INCLUDE_as3_lex
#define INCLUDE_as3_lex

#include "tok.hh"
#include "op.hh"

#include <string>

extern int as3lineno;
extern char* as3text;

struct Token {
    int line = as3lineno;
    Tok tok = Tok::none;
    Op op = Op::none;
    std::string text = as3text;

    Token(Tok tok) : tok(tok) {}
    Token(Op op) : tok(Tok::op), op(op) {}
    Token(Tok tok, std::string text);

    explicit operator bool() { return tok > Tok::none; }
};

Token as3lex();

#endif

