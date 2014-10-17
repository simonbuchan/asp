#include "parse.hh"

namespace {
    
Token cur_;

const Token& next() {
    return cur_ = as3lex();
}

const Token& cur() {
    if (cur_.tok == Tok::none) next();
    return cur_;
}

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
    return Node { };
}

int binding_power(Op op) {
    switch (op) {
    default: return 0;
    case Op::plus: case Op::minus:
        return 1;
    case Op::mul: case Op::div:
        return 2;
    }
}

// Pratt parser
Node parse_expression(int right_binding_power) {
    auto left = Node { next() };
    auto op = next();
    while (op.tok == Tok::op && binding_power(op.op) > right_binding_power) {
        auto right = parse_expression(binding_power(op.op));
        left = Node { op, { left, right } };
        op = cur();
    }
    return left;
}

// left '+' right ...
Node parse_expression() {
    return parse_expression(0);
}
