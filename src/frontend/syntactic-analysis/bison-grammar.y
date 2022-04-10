%{

#include "bison-actions.h"

%}

// IDs de los tokens generados desde Flex:
%token ADD
%token SUB
%token MUL
%token DIV

%token QUOTE

%token OPEN_PARENTHESIS
%token CLOSE_PARENTHESIS

%token INTEGER
%token CHARS

// Reglas de asociatividad y precedencia (de menor a mayor):
%left ADD SUB
%left MUL DIV

%%

/*program: expression												{ $$ = ProgramGrammarAction($1); }
	;

expression: expression ADD expression							{ $$ = AdditionExpressionGrammarAction($1, $3); }
	| expression SUB expression									{ $$ = SubtractionExpressionGrammarAction($1, $3); }
	| expression MUL expression									{ $$ = MultiplicationExpressionGrammarAction($1, $3); }
	| expression DIV expression									{ $$ = DivisionExpressionGrammarAction($1, $3); }
	| factor													{ $$ = FactorExpressionGrammarAction($1); }
	;

factor: OPEN_PARENTHESIS expression CLOSE_PARENTHESIS			{ $$ = ExpressionFactorGrammarAction($2); }
	| constant													{ $$ = ConstantFactorGrammarAction($1); }
	;

constant: INTEGER												{ $$ = IntegerConstantGrammarAction($1); }
	;*/

program: string													{ $$ = ProgramGrammarAction($1); }
	;

string: QUOTE body_string QUOTE 								{StringGrammarAction(); }
	| QUOTE QUOTE												{EmptyStringGrammarAction(); }
	;

body_string: CHARS												{ CharsBodyStringGrammarAction(); }
	| INTEGER 													{ IntegerBodyStringGrammarAction(); }
	| body_string CHARS											{ ConcatCharsBodyStringGrammarAction(); }
	| body_string INTEGER										{ ConcatIntegerBodyStringGrammarAction(); }
	;
%%
