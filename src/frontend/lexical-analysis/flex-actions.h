#ifndef FLEX_ACTIONS_HEADER
#define FLEX_ACTIONS_HEADER

#include "../../backend/support/shared.h"

/**
 * Se definen los diferentes IDs de cada token disponible para el scanner Flex.
 */
typedef enum TokenID {

	// Por defecto, el valor "0" hace fallar el analizador sintáctico.
	UNKNOWN = 0,

	// Código de error de Bison, que permite abortar el escaneo de lexemas cuando
	// se presente un patrón desconocido. El número "257" coincide con el valor
	// que Bison le otorga por defecto, pero además permite que el resto de
	// tokens continúen desde el valor "258" lo que permite proteger los IDs
	// internos que Bison reserva para crear "tokens literales":
	YYUNDEF = 257,

	// Operadores aritméticos.
	ADD,
	SUB,
	MUL,
	DIV,
	VAR,

	EQ,
	NEQ,
	LT,
	LEQ,
	GT,
	GEQ,

	AND,
	OR,
	NOT,


	// Tags
	TAG_TYPE,
	TAG_CONTENT, 
	TAG_IF,
	TAG_CONDITION,
	TAG_THEN,
	TAG_ELSE,
	TAG_FOR,
	TAG_VAR,
	TAG_IN,
	TAG_READ,

	// Tokens de JSON
	QUOTE,
	DOLLAR,
	COM, 
	TPOINTS, 
	AT_SIGN,

	// Paréntesis.
	OPEN_PARENTHESIS,
	CLOSE_PARENTHESIS,
	OPEN_CURL,
	CLOSE_CURL,
	OPEN_BRA,
	CLOSE_BRA,

	// Tipos de dato.
	INTEGER,
	CHARS,

	// Comienzo o finalizacion de contextos
	START_MATH

} TokenID;

/**
 * Se definen las acciones a ejecutar sobre cada patrón hallado mediante el
 * analizador léxico Flex. Este analizador solo puede identificar
 * construcciones regulares, ya que utiliza un autómata finito determinístico
 * (a.k.a. DFA), como mecanismo de escaneo y reconocimiento.
 */

TokenID IntegerPatternAction(const char * lexeme);

void IgnoredPatternAction(const char * lexeme);

TokenID UnknownPatternAction(const char * lexeme);

TokenID StringPatternAction(const char * lexeme);

TokenID QuotePatternAction(const char * lexeme);

TokenID StartStringAction(const char * lexeme);

TokenID EndStringAction(const char * lexeme);

TokenID StartMathAction(const char * lexeme);

TokenID EndMathAction(const char * lexeme);

TokenID VarMathPatternAction(const char * lexeme);


#endif
