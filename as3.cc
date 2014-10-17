#include "as3.lex.hh"
#include "parse.hh"

#include <stdio.h>
#include <string>

using namespace std::literals;

void print_lex();
void print_parse(Parse parse);

void usage() {
    exit(1);
}

int main(int argc, const char* argv[]) {
    if (argc < 2) {
        usage();
    } else if (argv[1] == "--lex"s) {
        print_lex();
    } else if (argv[1] == "--expression"s) {
        print_parse(parse_expression);
    } else if (argv[1] == "--statement"s) {
        print_parse(parse_statement);
    } else if (argv[1] == "--package"s) {
        print_parse(parse_package);
    } else if (argv[1] == "--parse"s) {
        print_parse(parse_file);
    } else {
        usage();
    }
}

void print_token(FILE* file, const Token& token) {
    fprintf(file, "%d: %s", token.line, tok_name(token.tok));
    if (token.op != Op::none) {
        fprintf(file, " %s", op_name(token.op));
    }
    fprintf(file, " '%s'\n", token.text.c_str());
}

void print_lex() {
    while (auto token = as3lex()) {
        print_token(stdout, token);
    }
}

void print_node(FILE* file, const Node& node) {
    if (node.head.tok == Tok::number) {
        fprintf(file, "%s", node.head.text.c_str());
        return;
    }
    fprintf(file, "(");
    switch (node.head.tok) {
    default:
        fprintf(file, "%s", node.head.text.c_str());
        break;
    case Tok::op:
        fprintf(file, "%s", op_name(node.head.op));
        break;
    }
    for (auto&& child : node.children) {
        fprintf(file, " ");
        print_node(file, child);
    }
    fprintf(file, ")");
}

void print_parse(Parse parse) {
    auto node = parse();
    print_node(stdout, node);
    fprintf(stdout, "\n");
    auto any_unparsed = false;
    while (auto token = as3lex()) {
        if (!any_unparsed) {
            fprintf(stderr, "UNPARSED:\n");
            any_unparsed = true;
        }
        print_token(stderr, token);
    }
}

