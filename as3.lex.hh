#ifndef INCLUDE_as3_lex
#define INCLUDE_as3_lex

#include "tok.hh"
#include "op.hh"

#include <string>

struct Token {
    int line = 0;
    Tok tok = Tok::none;
    Op op = Op::none;
    std::string text;

    explicit operator bool() { return tok > Tok::none; }
};

Token as3lex();

#endif
