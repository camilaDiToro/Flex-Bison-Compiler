%{

#include "bison-actions.h"

%}

// IDs de los tokens generados desde Flex:
%token ADD
%token SUB
%token MUL
%token DIV
%token VAR

%token EQ
%token NEQ
%token LT
%token LEQ
%token GT
%token GEQ

%token AND
%token OR
%token NOT

%token TAG_TYPE
%token TAG_CONTENT
%token TAG_IF
%token TAG_CONDITION
%token TAG_THEN
%token TAG_ELSE
%token TAG_FOR
%token TAG_VAR
%token TAG_IN
%token TAG_READ
%token TAG_INRANGE

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
%token END_MATH

// Reglas de asociatividad y precedencia (de menor a mayor):
%left ADD SUB
%left MUL DIV

%%

program: json													{ $$ = ProgramGrammarAction($1); }
	; 						

json: string													{ printf("JSON TYPE: Simple string \n"); }
	| array														{ printf("JSON TYPE: Array\n"); }
	| json_generic										        { printf("JSON TYPE: Generic\n"); }
	| json_if													{ printf("JSON TYPE: If\n"); }
	| json_for													{ printf("JSON TYPE: For\n"); }
	| json_read													{ printf("JSON TYPE: Read\n"); }
	;

json_generic: 	OPEN_CURL row_type json_body 
				row_content CLOSE_CURL 							{ printf("JSON TYPE: Generic\n"); }
	; 

json_body: COM
	| 	row_generic COM											{ printf("JSON ROW COLLECTION STARTED\n"); } 
	|	json_body row_generic COM								{ printf("JSON ROW ENUMERATION\n"); }
	;

json_if: OPEN_CURL json_if_body	CLOSE_CURL						{ printf("JSON IF THEN \n"); }
	|	 OPEN_CURL json_if_body COM row_else CLOSE_CURL			{ printf("JSON IF ELSE \n"); }
	;

json_if_body: row_type_if COM row_condition COM row_then        { printf("JSON IF BODY\n"); }
	;

json_for: OPEN_CURL json_for_body CLOSE_CURL        			{ printf("JSON TYPE: For\n"); }
	;

json_for_body: row_type_for COM row_var COM row_in COM row_content	{ printf("JSON FOR VAR IN BODY\n"); }
	|   row_type_for COM row_var COM row_inrange COM row_content	{ printf("JSON FOR VAR INRANGE BODY\n"); }
	|	row_type_for COM row_inrange COM row_content				{ printf("JSON FOR INRANGE BODY\n"); }
	;

json_read: OPEN_CURL json_read_body CLOSE_CURL					{ printf("JSON TYPE: Read\n"); }
	;

json_read_body: row_type_read COM row_var COM row_content		{ printf("JSON READ BODY\n"); }
	;

/*************************************************************************************
**                       TIPOS DE FILAS (ROWs) "":
**************************************************************************************/

row_type_if: TAG_TYPE TPOINTS TAG_IF							{ printf("JSON TYPE IF ROW DETECTED\n"); }
	;

row_type_for: TAG_TYPE TPOINTS TAG_FOR							{ printf("JSON TYPE ROW FOR DETECTED\n"); }
	;

row_type_read: TAG_TYPE TPOINTS TAG_READ						{ printf("JSON TYPE ROW FOR DETECTED\n"); }
	;

row_type: TAG_TYPE TPOINTS string								{ printf("JSON TYPE ROW DETECTED\n"); }				
	;

row_condition: TAG_CONDITION TPOINTS string						{ printf("JSON CONDITION ROW DETECTED\n"); }
	;

row_then: TAG_THEN TPOINTS json									{ printf("JSON THEN ROW DETECTED\n"); }
	;

row_else: TAG_ELSE TPOINTS json									{ printf("JSON ELSE ROW DETECTED\n"); }
	;

row_var: TAG_VAR TPOINTS string									{ printf("JSON VAR ROW DETECTED\n"); }
	;

row_in: TAG_IN TPOINTS array									{ printf("JSON IN ROW DETECTED\n"); }
	;

row_inrange: 	TAG_INRANGE TPOINTS OPEN_BRA string 
				COM string CLOSE_BRA 							{ printf("JSON INRANGE ROW DETECTED\n"); }
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

expression_result:	START_MATH expression END_MATH      		{ ExpressionResultGrammarAction(); }
	;
	
expression: expression ADD expression							{ $$ = AdditionExpressionGrammarAction($1, $3); }
	| expression SUB expression									{ $$ = SubtractionExpressionGrammarAction($1, $3); }
	| expression MUL expression									{ $$ = MultiplicationExpressionGrammarAction($1, $3); }
	| expression DIV expression									{ $$ = DivisionExpressionGrammarAction($1, $3); }
	| expression EQ expression									{ $$ = EqualityExpressionGrammarAction($1, $3); }
	| expression NEQ expression									{ $$ = NequalityExpressionGrammarAction($1, $3); }
	| expression LT expression									{ $$ = LessThanExpressionGrammarAction($1, $3); }
	| expression LEQ expression									{ $$ = LessOrEqualToExpressionGrammarAction($1, $3); }
	| expression GT expression									{ $$ = GreaterThanExpressionGrammarAction($1, $3); }
	| expression GEQ expression									{ $$ = GreaterOrEqualToExpressionGrammarAction($1, $3); }
	| expression AND expression									{ $$ = AndExpressionGrammarAction($1, $3); }
	| expression OR expression									{ $$ = OrExpressionGrammarAction($1, $3); }
	| NOT expression											{ $$ = NotExpressionGrammarAction($2); }
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
