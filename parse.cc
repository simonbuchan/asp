#include "parse.hh"

Token cur_;

const Token& next() {
    return cur_ = as3lex();
}

const Token& cur() {
    if (cur_.tok == Tok::none) next();
    return cur_;
}

Token eat() {
    auto result = cur();
    next();
    return result;
}

// package; statement*
Node parse_file() {
    return Node { };
}

// 'package' id? '{' statement* '}'
Node parse_package() {
    return Node { };
}

// 'if', 'while', ...
Node parse_statement() {
    auto expr = parse_expression();
    return Node { eat(), { expr } };
}

