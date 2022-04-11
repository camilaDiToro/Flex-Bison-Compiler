%{

#include "bison-actions.h"

%}

// IDs de los tokens generados desde Flex:
%token ADD
%token SUB
%token MUL
%token DIV

%token QUOTE
%token DOLLAR
%token COM
%token TPOINTS

%token OPEN_PARENTHESIS
%token CLOSE_PARENTHESIS
%token OPEN_CURL
%token CLOSE_CURL
%token OPEN_BRA
%token CLOSE_BRA

%token INTEGER
%token CHARS

// Reglas de asociatividad y precedencia (de menor a mayor):
%left ADD SUB
%left MUL DIV

%%

program: json													{ $$ = ProgramGrammarAction($1); }
	; 						

json: string													{ printf("JSON TYPE: Simple string: %s\n", $1); }
	| array														{ printf("JSON TYPE: Array\n"); }
	| OPEN_CURL json_body CLOSE_CURL 							{ printf("JSON TYPE: Full Json\n"); }												
	;

json_body: json_row												{ printf("JSON ROW COLLECTION STARTED\n"); }
	|	json_body COM json_row									{ printf("JSON ROW ENUMERATION\n"); }
	;


json_row: string TPOINTS json									{ printf("JSON ROW DETECTED\n"); }
	;

array: OPEN_BRA CLOSE_BRA										{ printf("PARSED EMPTY ARRAY\n"); }
	|  OPEN_BRA array_body CLOSE_BRA							{ printf("PARSED NON EMPTY ARRAY\n");}
	;


array_body: string                                          	{ printf("body array string\n"); }
	| array														{ printf("body array array\n"); } 
	| array_body COM string										{ printf("body array concat string\n"); }
	| array_body COM array                                      { printf("body array concat array\n"); }
	;

string: QUOTE string_body QUOTE 								{ StringGrammarAction(); }
	| QUOTE QUOTE												{ EmptyStringGrammarAction(); }
	;

string_body: CHARS												{ CharsBodyStringGrammarAction(); }
	| INTEGER 													{ ExpressionResultBodyStringGrammarAction(); }
	| expression_result											{ IntegerBodyStringGrammarAction(); }
	| string_body CHARS											{ ConcatCharsBodyStringGrammarAction(); }
	| string_body INTEGER										{ ConcatIntegerBodyStringGrammarAction(); }
	| string_body expression_result								{ ConcatExpressionResultBodyStringGrammarAction(); }
	;

expression_result:	DOLLAR OPEN_CURL expression CLOSE_CURL      { ExpressionResultGrammarAction(); }


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
	;
%%
