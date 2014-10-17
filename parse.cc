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

enum class Side { left, right };

int left_assoc(int power, Side side) {
    return power * 2;
}

int right_assoc(int power, Side side) {
    return side == Side::right ? power * 2 : power * 2 - 1;
}

int binding_power(Op op, Side side) {
    switch (op) {
    default: return 0;
    case Op::equal:
        return right_assoc(1, side);
    case Op::plus: case Op::minus:
        return left_assoc(2, side);
    case Op::mul: case Op::div:
        return left_assoc(3, side);
    }
}

// Pratt parser
Node parse_expression(int right_binding_power) {
    auto left = Node { next() };
    auto op = next();
    while (op.tok == Tok::op &&
            binding_power(op.op, Side::right) > right_binding_power) {
        left = Node {
            op, {
                left,
                parse_expression(binding_power(op.op, Side::left))
            }
        };
        op = cur();
    }
    return left;
}

// left '+' right ...
Node parse_expression() {
    return parse_expression(0);
}
