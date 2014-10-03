%x STRING CHARLITERAL XML XMLSTARTTAG

%option yylineno
%option nodefault
%option noyywrap

%{

#include "as3.lex.hh"

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string>
#include <memory>

using std::move;

void error(const char* msg, ...) {
    fprintf(stderr, "ERROR:%d: ", yylineno);
    va_list vl;
    va_start(vl, msg);
    vfprintf(stderr, msg, vl);
    va_end(vl);
    fprintf(stderr, "\n");
}

token::token(Tok tok, std::string text)
    : tok(tok), text(move(text)) {}

#undef YY_DECL
#define YY_DECL token as3lex()

#define yyterminate() return Tok::error

%}

UTF8BOM \xEF\xBB\xBF

/* main character classes */
LineTerminator \r|\n|\r\n
InputCharacter [^\r\n]

WhiteSpace {LineTerminator}|{UTF8BOM}|[[:space:]]+

/* comments */
TraditionalComment "/*"([^*]|"*"[^/])+"*/"
EndOfLineComment "//"{InputCharacter}*{LineTerminator}?

Comment {TraditionalComment}|{EndOfLineComment}


/* identifiers */
Identifier [a-zA-Z_][a-zA-Z0-9_]*

IdentifierNs {Identifier}:{Identifier}

/* XML */
XMLIdentifier {Identifier}|{IdentifierNs}
XMLAttribute {XMLIdentifier}\ *=\ *\"{InputCharacter}*\"\ *
XMLBeginTag "<"{XMLIdentifier}
XMLEndTag "</"{XMLIdentifier}"\>"

/* integer literals */
DEC 0|[1-9][0-9]*

HEX 0[xX]0*{HexDigit}{1,8}
HexDigit [0-9a-fA-F]

OCT 0+[1-3]?{OctDigit}{1,15}
OctDigit [0-7]

/* floating point literals */
DoubleLiteral ({FLit1}|{FLit2}|{FLit3}){Exponent}?

FLit1    [0-9]+\.[0-9]*
FLit2    \.[0-9]+
FLit3    [0-9]+
Exponent [eE][+-]?[0-9]+

/* string and character literals */
StringCharacter [^\r\n\"\\]
SingleCharacter [^\r\n\'\\]

%%

    std::string token_text;
    int xml_depth = 0;

<INITIAL>{

break |
case |
catch |
class |
const |
continue |
default |
do |
dynamic |
each |
else |
extends |
false |
final |
finally |
for |
function |
get |
if |
implements |
import |
in |
include |
interface |
internal |
label |
namespace |
native |
null |
override |
package |
private |
protected |
public |
return |
set |
static |
super |
switch |
this |
throw |
true |
try |
use |
var |
while |
with                           return Tok::keyword;

    /* operators */

"("                            return Op::lparen;
")"                            return Op::rparen;
"{"                            return Op::lcurly;
"}"                            return Op::rcurly;
"["                            return Op::lsquare;
"]"                            return Op::rsquare;
";"                            return Op::semicolon;
","                            return Op::comma;
"..."                          return Op::ellipsis;
"."                            return Op::dot;
"="                            return Op::equal;
">"                            return Op::rangle;
"<"                            return Op::langle;
"!"                            return Op::boolnot;
"~"                            return Op::bitnot;
"?"                            return Op::question;
":"                            return Op::colon;
"=="                           return Op::equalequal;
"<="                           return Op::langleequal;
">="                           return Op::rangleequal;
"!="                           return Op::boolnotequal;
"&&"                           return Op::booland;
"||"                           return Op::boolor;
"++"                           return Op::plusplus;
"--"                           return Op::minusminus;
"+"                            return Op::plus;
"-"                            return Op::minus;
"*"                            return Op::mul;
"/"                            return Op::div;
"&"                            return Op::bitand_;
"|"                            return Op::bitor_;
"^"                            return Op::bitxor;
"%"                            return Op::mod;
"<<"                           |
">>"                           |
">>>"                          |
"+="                           |
"-="                           |
"*="                           |
"/="                           |
"&="                           |
"|="                           |
"^="                           |
"%="                           |
"<<="                          |
">>="                          |
">>>="                         |
"as"                           |
"delete"                       |
"instanceof"                   |
"is"                           |
"::"                           |
"new"                          |
"typeof"                       |
"void"                         |
"@"                            return Op::none;

    /* string literal */
\"                             {
                                  BEGIN(STRING);
                                  token_text = yytext;
                               }

    /* character literal */
\'                             {
                                  BEGIN(CHARLITERAL);
                                  token_text = yytext;
                               }

    /* numeric literals */
{DEC}                          |
{HEX}                          |
{OCT}                          |
{DoubleLiteral}                |
{DoubleLiteral}[dD]            { return Tok::number; }

    /* JavaDoc comments need a state so that we can highlight the @ controls */

    /* comments */
{Comment}                      { return Tok::comment; }

    /* whitespace */
{WhiteSpace}                   { }
{XMLBeginTag}                  {  BEGIN(XMLSTARTTAG);
                                  token_text = yytext;
                                  xml_depth++;
                                  //xmlTagName = yytext + 1;
                               }
    /* identifiers */
{Identifier}                   { return Tok::identifier; }

}

<XMLSTARTTAG>{

{XMLAttribute}              { token_text += yytext; }
{WhiteSpace}                { token_text += yytext; }
">"                         { token_text += yytext; BEGIN(XML); }

}

<XML>{

{XMLBeginTag}               { ++xml_depth; token_text += yytext; BEGIN(XMLSTARTTAG); }
{XMLEndTag}                 { token_text += yytext;
                             if (!--xml_depth) {
                                 BEGIN(INITIAL);
                                 return token(Tok::xml, move(token_text));
                             }
                            }
.                           { token_text += yytext; }

}

<STRING>{

\"                          {
                                 BEGIN(INITIAL);
                                 // length also includes the trailing quote
                                 return token(Tok::string, move(token_text));
                            }

{StringCharacter}+             |

\\[0-3]?{OctDigit}?{OctDigit}  |

    /* escape sequences */
\\.                            { token_text += yytext; }

{LineTerminator}               { BEGIN(INITIAL); }

}

<CHARLITERAL>{

\'                             {
                                 BEGIN(INITIAL);
                                 // length also includes the trailing quote
                                 return token(Tok::string, move(token_text));
                               }

{SingleCharacter}+             |

    /* escape sequences */

\\.                            { token_text += yytext; }
{LineTerminator}               { BEGIN(INITIAL);  }

}

    /* error fallback */
<*>.|\n                        error("invalid char: %x", *yytext);
<<EOF>>                        { return Tok::end; }

