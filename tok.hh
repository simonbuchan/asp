#ifndef INCLUDE_tok_hh
#define INCLUDE_tok_hh

enum class Tok {

end = -1,
none,
keyword,
id,
op,
number,
comment,
string,
xml,

};

const char* tok_name(Tok tok);

#endif // INCLUDE_tok_hh
