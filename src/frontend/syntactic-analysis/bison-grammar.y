%{

#include "bison-actions.h"

%}

// IDs de los tokens generados desde Flex:
%token ADD
%token SUB
%token MUL
%token DIV
%token VAR

%token QUOTE
%token DOLLAR
%token COM
%token TPOINTS
%token AT_SIGN

%token OPEN_PARENTHESIS
%token CLOSE_PARENTHESIS
%token OPEN_CURL
%token CLOSE_CURL
%token OPEN_BRA
%token CLOSE_BRA

%token INTEGER
%token CHARS

%token START_MATH

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


array_body: json                                          		{ printf("body array json\n"); }
	| array_body COM json                                       { printf("body array concat json\n"); }
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

expression_result:	START_MATH expression CLOSE_CURL      		{ ExpressionResultGrammarAction(); }


expression: expression ADD expression							{ $$ = AdditionExpressionGrammarAction($1, $3); }
	| expression SUB expression									{ $$ = SubtractionExpressionGrammarAction($1, $3); }
	| expression MUL expression									{ $$ = MultiplicationExpressionGrammarAction($1, $3); }
	| expression DIV expression									{ $$ = DivisionExpressionGrammarAction($1, $3); }
	| factor													{ $$ = FactorExpressionGrammarAction($1); }
	;

factor: OPEN_PARENTHESIS expression CLOSE_PARENTHESIS			{ $$ = ExpressionFactorGrammarAction($2); }
	| constant													{ $$ = ConstantFactorGrammarAction($1); }
	| variable													{ $$ = VariableFactorGrammarAction(); }
	;

variable: VAR													{ $$ = VariableGrammarAction(); }
	| variable OPEN_BRA INTEGER CLOSE_BRA						{ $$ = VariableSubscriptGrammarAction(); }
	;

constant: INTEGER												{ $$ = IntegerConstantGrammarAction($1); }
	;
%%
