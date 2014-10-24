#include "parse.hh"

// A Pratt parser implementation.

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

Node parse_prefix_expression() {
    if (cur().tok == Tok::op) {
        auto op = eat();
        if (op.op == Op::lparen) {
            auto result = Node { op, { parse_expression() } };
            if (cur().op == Op::rparen) { // else fail!?
                eat();
            }
            return result;
        }
        return Node { op, { parse_prefix_expression() } };
    }
    // postfix...
    return Node { eat() };
}

Node parse_expression(int right_binding_power) {
    auto left = parse_prefix_expression();

    // Infix operators.
    while (cur().tok == Tok::op &&
            binding_power(cur().op, Side::right) > right_binding_power) {
        auto op = eat();
        left = Node {
            op, {
                left,
                parse_expression(binding_power(op.op, Side::left))
            }
        };
    }

    return left;
}

Node parse_expression() {
    return parse_expression(0);
}
