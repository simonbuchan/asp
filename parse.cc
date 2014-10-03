#include "parse.hh"

// package; statement*
Node parse_file() {
    return Node { Tok::end };
}

// 'package' id? '{' statement* '}'
Node parse_package() {
    return Node { Tok::end };
}

// 'if', 'while', ...
Node parse_statement() {
    return Node { Tok::end };
}

// left '+' right ...
Node parse_expression() {
    return Node { Tok::end };
}

