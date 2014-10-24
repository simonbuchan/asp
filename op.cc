#include "op.hh"

const char* op_name(Op op) {
    switch (op) {
        default:
            return "[unknown op]";
        case Op::none:
            return "none";
        case Op::lparen:
            return "lparen";
        case Op::rparen:
            return "rparen";
        case Op::lcurly:
            return "lcurly";
        case Op::rcurly:
            return "rcurly";
        case Op::lsquare:
            return "lsquare";
        case Op::rsquare:
            return "rsquare";
        case Op::colon:
            return "colon";
        case Op::semicolon:
            return "semicolon";
        case Op::equal:
            return "equal";
        case Op::plus:
            return "plus";
        case Op::minus:
            return "minus";
        case Op::mul:
            return "mul";
        case Op::div:
            return "div";
        case Op::plusplus:
            return "plusplus";
        case Op::minusminus:
            return "minusminus";
    }
}
