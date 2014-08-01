#include "as3.lex.hh"

#include <stdio.h>

int main() {
    while (token t = as3lex()) {
        printf("%d: %d %d: %s\n", t.line, t.tok, t.op, t.text.c_str());
    }
}

