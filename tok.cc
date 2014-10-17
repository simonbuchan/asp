#include "tok.hh"

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
        case Tok::id:
            return "id";
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
