#ifndef INCLUDE_parse
#define INCLUDE_parse

#include "as3.lex.hh"

#include <vector>

const Token& cur();
const Token& next();
Token eat();

struct Node {
    Token head;
    std::vector<Node> children;
};

using Parse = Node (*)();

// package; statement*
Node parse_file();
// 'package' id? '{' statement* '}'
Node parse_package();
// 'if', 'while', ...
Node parse_statement();
// left '+' right ...
Node parse_expression();

#endif // INCLUDE_parse
