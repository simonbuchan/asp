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
using std::string;

auto make_token(Tok tok) {
    return Token { yylineno, tok, Op::none, yytext };
}

auto make_token(Op op) {
    return Token { yylineno, Tok::op, op, yytext };
}

auto make_token(Tok tok, string text) {
    return Token { yylineno, tok, Op::none, move(text) };
}

void error(const char* msg, ...) {
    fprintf(stderr, "ERROR:%d: ", yylineno);
    va_list vl;
    va_start(vl, msg);
    vfprintf(stderr, msg, vl);
    va_end(vl);
    fprintf(stderr, "\n");
}
    
#define RETURN return make_token

#undef YY_DECL
#define YY_DECL Token as3lex()

#define yyterminate() RETURN(Tok::error)

#pragma clang diagnostic ignored "-Wdeprecated-register"

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
with                            RETURN(Tok::keyword);

    /* operators */

"("                             RETURN(Op::lparen);
")"                             RETURN(Op::rparen);
"{"                             RETURN(Op::lcurly);
"}"                             RETURN(Op::rcurly);
"["                             RETURN(Op::lsquare);
"]"                             RETURN(Op::rsquare);
";"                             RETURN(Op::semicolon);
","                             RETURN(Op::comma);
"..."                           RETURN(Op::ellipsis);
"."                             RETURN(Op::dot);
"="                             RETURN(Op::equal);
">"                             RETURN(Op::rangle);
"<"                             RETURN(Op::langle);
"!"                             RETURN(Op::boolnot);
"~"                             RETURN(Op::bitnot);
"?"                             RETURN(Op::question);
":"                             RETURN(Op::colon);
"=="                            RETURN(Op::equalequal);
"<="                            RETURN(Op::langleequal);
">="                            RETURN(Op::rangleequal);
"!="                            RETURN(Op::boolnotequal);
"&&"                            RETURN(Op::booland);
"||"                            RETURN(Op::boolor);
"++"                            RETURN(Op::plusplus);
"--"                            RETURN(Op::minusminus);
"+"                             RETURN(Op::plus);
"-"                             RETURN(Op::minus);
"*"                             RETURN(Op::mul);
"/"                             RETURN(Op::div);
"&"                             RETURN(Op::bitand_);
"|"                             RETURN(Op::bitor_);
"^"                             RETURN(Op::bitxor);
"%"                             RETURN(Op::mod);
"<<"                            |
">>"                            |
">>>"                           |
"+="                            |
"-="                            |
"*="                            |
"/="                            |
"&="                            |
"|="                            |
"^="                            |
"%="                            |
"<<="                           |
">>="                           |
">>>="                          |
"as"                            |
"delete"                        |
"instanceof"                    |
"is"                            |
"::"                            |
"new"                           |
"typeof"                        |
"void"                          |
"@"                             RETURN(Op::none);

    /* string literal */
\"                              {
                                    BEGIN(STRING);
                                    token_text = yytext;
                                }

    /* character literal */
\'                              {
                                    BEGIN(CHARLITERAL);
                                    token_text = yytext;
                                }

    /* numeric literals */
{DEC}                           |
{HEX}                           |
{OCT}                           |
{DoubleLiteral}                 |
{DoubleLiteral}[dD]             RETURN(Tok::number);

    /* JavaDoc comments need a state so that we can highlight the @ controls */

    /* comments */
{Comment}                       RETURN(Tok::comment);

    /* whitespace */
{WhiteSpace}                    ;
{XMLBeginTag}                   {
                                    BEGIN(XMLSTARTTAG);
                                    token_text = yytext;
                                    xml_depth++;
                                    //xmlTagName = yytext + 1;
                                }
    /* identifiers */
{Identifier}                    RETURN(Tok::identifier);

}

<XMLSTARTTAG>{

{XMLAttribute}                  token_text += yytext;
{WhiteSpace}                    token_text += yytext;
">"                             {
                                    token_text += yytext;
                                    BEGIN(XML);
                                }

}

<XML>{

{XMLBeginTag}                   {
                                    ++xml_depth;
                                    token_text += yytext;
                                    BEGIN(XMLSTARTTAG);
                                }
{XMLEndTag}                     {
                                    token_text += yytext;
                                    if (!--xml_depth) {
                                        BEGIN(INITIAL);
                                        RETURN(Tok::xml, move(token_text));
                                    }
                                }
.                               token_text += yytext;

}

<STRING>{

\"                              {
                                    BEGIN(INITIAL);
                                    // length also includes the trailing quote
                                    RETURN(Tok::string, move(token_text));
                                }

{StringCharacter}+              |

\\[0-3]?{OctDigit}?{OctDigit}   |

    /* escape sequences */
\\.                             token_text += yytext;

{LineTerminator}                BEGIN(INITIAL);

}

<CHARLITERAL>{

\'                              {
                                    BEGIN(INITIAL);
                                    // length also includes the trailing quote
                                    RETURN(Tok::string, move(token_text));
                                }

{SingleCharacter}+              |

    /* escape sequences */

\\.                             token_text += yytext;
{LineTerminator}                BEGIN(INITIAL);

}

    /* error fallback */
<*>.|\n                         error("invalid char: %x", *yytext);
<<EOF>>                         RETURN(Tok::end);
