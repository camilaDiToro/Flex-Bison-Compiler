#include "../../backend/support/logger.h"
#include "flex-actions.h"
#include <stdlib.h>

/**
 * Implementación de "flex-rules.h".
 */

TokenID IntegerPatternAction(const char * lexeme) {
	LogDebug("IntegerPatternAction: '%s'.", lexeme);
	yylval = atoi(lexeme);
	return INTEGER;
}

void IgnoredPatternAction(const char * lexeme) {
	LogDebug("IgnoredPatternAction: '%s'.", lexeme);
}

TokenID UnknownPatternAction(const char * lexeme) {
	LogDebug("UnknownPatternAction: '%s'.", lexeme);
	return YYUNDEF;
}

TokenID StringPatternAction(const char * lexeme) {
	LogDebug("StringPatternAction: '%s'.", lexeme);
	return CHARS;
}

TokenID QuotePatternAction(const char * lexeme) {
	LogDebug("QuotePatternAction: '%s'.", lexeme);
	return QUOTE;
}

TokenID StartStringAction(const char * lexeme){
	LogDebug("StartStringAction: '%s'.", lexeme);
	return QUOTE;
}

TokenID EndStringAction(const char * lexeme){
	LogDebug("EndStringAction: '%s'.", lexeme);
	return QUOTE;
}

TokenID StartMathAction(const char * lexeme){
	LogDebug("StartMathAction: '%s'.", lexeme);
	return START_MATH;
}

TokenID EndMathAction(const char * lexeme){
	LogDebug("EndMathAction: '%s'.", lexeme);
	return END_MATH;
}

TokenID VarMathPatternAction(const char * lexeme){
	LogDebug("VarMathPatternAction: '%s'.", lexeme);
	return VAR;
}