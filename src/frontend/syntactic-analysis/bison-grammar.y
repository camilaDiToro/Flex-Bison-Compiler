%{

#include "bison-actions.h"

%}

// IDs de los tokens generados desde Flex:
%token ADD
%token SUB
%token MUL
%token DIV
%token VAR

%token TAG_TYPE
%token TAG_CONTENT
%token TAG_IF
%token TAG_CONDITION
%token TAG_THEN
%token TAG_ELSE

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

json: string													{ printf("JSON TYPE: Simple string \n"); }
	| array														{ printf("JSON TYPE: Array\n"); }
	| json_generic										        { printf("JSON TYPE: Full Json\n"); }
	| json_if
	;

json_generic: OPEN_CURL row_type json_body row_content CLOSE_CURL { printf("JSON TYPE: Full Json\n"); }
	; 

json_body: COM
	| 	row_generic COM											{ printf("JSON ROW COLLECTION STARTED\n"); } 
	|	json_body row_generic COM								{ printf("JSON ROW ENUMERATION\n"); }
	;

json_if: json_if_body											{ printf("JSON IF THEN \n"); }
	|	 json_if_body COM row_else								{ printf("JSON IF ELSE \n"); }
	;

json_if_body: row_type COM row_condition COM row_then        { printf("JSON IF BODY\n"); }
	;

/*************************************************************************************
**                       TIPOS DE FILAS (ROWs) "":
**************************************************************************************/

row_type: TAG_TYPE TPOINTS TAG_IF								{ printf("JSON TYPE IF ROW DETECTED\n"); }	
	| TAG_TYPE TPOINTS string									{ printf("JSON TYPE ROW DETECTED\n"); }				
	;

row_condition: TAG_CONDITION TPOINTS string						{ printf("JSON TYPE IF ROW DETECTED\n"); }
	;

row_then: TAG_THEN TPOINTS json									{ printf("JSON TYPE IF ROW DETECTED\n"); }
	;

row_else: TAG_ELSE TPOINTS json									{ printf("JSON TYPE IF ROW DETECTED\n"); }
	;

row_content: TAG_CONTENT TPOINTS json							{ printf("JSON CONTENT ROW DETECTED\n"); }
	;

row_generic: string TPOINTS json								{ printf("JSON ROW DETECTED\n"); }
	;

/*************************************************************************************
**                       TIPOS BASICOS - STRING Y ARRAY
**************************************************************************************/

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


/*************************************************************************************
**                       EXPRESIONES MATEMATICAS
**************************************************************************************/

expression_result:	START_MATH expression CLOSE_CURL      		{ ExpressionResultGrammarAction(); }
	;
	
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
