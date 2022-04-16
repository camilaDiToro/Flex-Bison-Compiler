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
character       [^\f\n\r\t\v\"$]|\\\\$|\\\"
whitespace		[ \f\n\r\t\v]

%s STRING
%s MATH

%%

<STRING>"${"                                {BEGIN(MATH); return StartMathAction(yytext);}
<MATH>"}"                                   {BEGIN(STRING); return EndMathAction(yytext);}

":"                                         { return TPOINTS; }
"\"@type\""                                 { return TAG_TYPE; }
"\"@content\""                              { return TAG_CONTENT; }
"\"@if\""                                   { return TAG_IF; }
"\"@condition\""                            { return TAG_CONDITION; }
"\"@then\""                                 { return TAG_THEN; }
"\"@else\""                                 { return TAG_ELSE; }
"\"@for\""                                  { return TAG_FOR; }
"\"@var\""                                  { return TAG_VAR; }
"\"@in\""                                   { return TAG_IN; }
"\"@read\""                                 { return TAG_READ; }
"\"@inrange\""                              { return TAG_INRANGE; }

<MATH>"+"									{ return ADD; }
<MATH>"-"									{ return SUB; }
<MATH>"*"									{ return MUL; }
<MATH>"/"									{ return DIV; }
<MATH>{alpha}{alphanumeric}*                { return VarMathPatternAction(yytext); }

<MATH>"=="									{ return EQ; }
<MATH>"!="									{ return NEQ; }
<MATH>"<"									{ return LT; }
<MATH>"<="									{ return LEQ; }
<MATH>">"									{ return GT; }
<MATH>">="									{ return GEQ; }

<MATH>"&&"									{ return AND; }
<MATH>"||"									{ return OR; }
<MATH>"!"									{ return NOT; }

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
