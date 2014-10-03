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

void print_lex() {
    while (auto token = as3lex()) {
        printf("%d: %s", token.line, tok_name(token.tok));
        if (token.op != Op::none) {
            printf(" %s", op_name(token.op));
        }
        printf(" '%s'\n", token.text.c_str());
    }
}

void print_node(const Node& node) {
    printf("(%s", node.head.text.c_str());
    for (auto&& child : node.children) {
        printf(" ");
        print_node(child);
    }
    printf(")");
}

void print_parse(Parse parse) {
    auto node = parse();
    print_node(node);
}

