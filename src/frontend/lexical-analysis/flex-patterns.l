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
alpha           [a-zA-Z]
alphanumeric    [a-zA-Z0-9]
character       [a-zA-Z0-9]|@|-|\+|\*|\/|\'
whitespace		[ \f\n\r\t\v]

%s STRING
%s MATH

%%

<STRING>"${"                                {BEGIN(MATH); return StartMathAction(yytext);}
<MATH>"}"                                   {BEGIN(STRING); return EndMathAction(yytext);}

"$"                                         { return DOLLAR; }
":"                                         { return TPOINTS; }
"@"                                         { return AT_SIGN; }

<MATH>"+"									{ return ADD; }
<MATH>"-"									{ return SUB; }
<MATH>"*"									{ return MUL; }
<MATH>"/"									{ return DIV; }
<MATH>{alpha}{alphanumeric}*                { return VarMathPatternAction(yytext); }

<STRING>","                                 { return StringPatternAction(yytext); }
","                                         { return COM; }

"("											{ return OPEN_PARENTHESIS; }
")"											{ return CLOSE_PARENTHESIS; }
"{"											{ return OPEN_CURL; }
"}"											{ return CLOSE_CURL; }
"["                                         { return OPEN_BRA; }
"]"                                         { return CLOSE_BRA; }

<INITIAL>"\""                               { BEGIN(STRING); return StartStringAction(yytext);  }
<STRING>"\""                                { BEGIN(INITIAL); return EndStringAction(yytext);  }


<MATH>{digit}+								{ return IntegerPatternAction(yytext); }

<STRING>({character}|{whitespace})+         { return StringPatternAction(yytext); }

<MATH,INITIAL>{whitespace}					{ IgnoredPatternAction(yytext); }

.											{ return UnknownPatternAction(yytext); }

%%
