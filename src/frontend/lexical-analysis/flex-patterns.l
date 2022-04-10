%{

#include "flex-actions.h"

%}

/* Obliga a crear una regla explícita para manejar lexemas desconocidos. */
%option nodefault

/* Escanea un único archivo y se detiene. */
%option noyywrap

/* Dispone una variable global "yylineno" con el número de línea actual. */
%option yylineno

/* Patrones reutilizables. */
crlf			\r\n
digit			[0-9]
endline			\n
character       [a-z]
whitespace		[ \f\n\r\t\v]


%%

"+"											{ return ADD; }
"-"											{ return SUB; }
"*"											{ return MUL; }
"/"											{ return DIV; }

"("											{ return OPEN_PARENTHESIS; }
")"											{ return CLOSE_PARENTHESIS; }

"\""                                        { return QuotePatternAction(yytext);  }
"\'"                                        { return QuotePatternAction(yytext);  }

{digit}+									{ return IntegerPatternAction(yytext); }

{character}+                                { return StringPatternAction(yytext); }

{whitespace}								{ IgnoredPatternAction(yytext); }

.											{ return UnknownPatternAction(yytext); }

%%
