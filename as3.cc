#include "as3.lex.hh"

#include <stdio.h>

const char* tok_name(Tok tok) {
    switch (tok) {
        default:
            return "[unknown tok]";
        case Tok::end:
            return "end";
        case Tok::none:
            return "none";
        case Tok::keyword:
            return "keyword";
        case Tok::identifier:
            return "identifier";
        case Tok::op:
            return "op";
        case Tok::number:
            return "number";
        case Tok::comment:
            return "comment";
        case Tok::string:
            return "string";
        case Tok::xml:
            return "xml";
    }
}

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
    }
}

int main() {
    while (token t = as3lex()) {
        printf("%d: %s", t.line, tok_name(t.tok));
        if (t.op != Op::none) {
            printf(" %s", op_name(t.op));
        }
        printf(" '%s'\n", t.text.c_str());
    }
}

