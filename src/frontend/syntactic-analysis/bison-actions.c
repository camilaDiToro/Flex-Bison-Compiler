#include "../../backend/domain-specific/calculator.h"
#include "../../backend/support/logger.h"
#include "bison-actions.h"
#include <stdio.h>
#include <string.h>

/**
 * Implementación de "bison-grammar.h".
 */

void yyerror(const char * string) {
	LogError("Mensaje: '%s' debido a '%s' (linea %d).", string, yytext, yylineno);
	LogError("En ASCII es:");
	LogErrorRaw("\t");
	const int length = strlen(yytext);
	for (int i = 0; i < length; ++i) {
		LogErrorRaw("[%d]", yytext[i]);
	}
	LogErrorRaw("\n\n");
}

int ProgramGrammarAction(const int value) {
	//LogDebug("ProgramGrammarAction(%d)", value);
	LogDebug("ProgramGrammarAction()");
	state.succeed = true;
	state.result = value;
	return value;
}

int AdditionExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("AdditionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return Add(leftValue, rightValue);
}

int SubtractionExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("SubtractionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return Subtract(leftValue, rightValue);
}

int MultiplicationExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("MultiplicationExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return Multiply(leftValue, rightValue);
}

int DivisionExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return Divide(leftValue, rightValue);
}

int EqualityExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return Equals(leftValue, rightValue);
}

int NequalityExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return Nequals(leftValue, rightValue);
}

int LessThanExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return LessThan(leftValue, rightValue);
}

int LessOrEqualToExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return LessOrEqualTo(leftValue, rightValue);
}

int GreaterThanExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return GreaterThan(leftValue, rightValue);
}

int GreaterOrEqualToExpressionGrammarAction(const int leftValue, const int rightValue) {
	LogDebug("DivisionExpressionGrammarAction(%d, %d)", leftValue, rightValue);
	return GreaterOrEqualTo(leftValue, rightValue);
}

int FactorExpressionGrammarAction(const int value) {
	LogDebug("FactorExpressionGrammarAction(%d)", value);
	return value;
}

int ExpressionFactorGrammarAction(const int value) {
	LogDebug("ExpressionFactorGrammarAction(%d)", value);
	return value;
}

void ExpressionResultGrammarAction(){
	LogDebug("ExpressionResultGrammarAction()");
}

int ConstantFactorGrammarAction(const int value) {
	LogDebug("ConstantFactorGrammarAction(%d)", value);
	return value;
}

int VariableFactorGrammarAction(){
	LogDebug("VariableFactorGrammarAction");
	return 1;
}

int VariableGrammarAction(){
	LogDebug("VariableGrammarAction");
	return 1;
}

int VariableSubscriptGrammarAction(){
	LogDebug("VariableSubscriptGrammarAction");
	return 1;
}

int IntegerConstantGrammarAction(const int value) {
	LogDebug("IntegerConstantGrammarAction(%d)", value);
	return value;
}

void StringGrammarAction(){
	LogDebug("StringGrammarAction()");
}
void EmptyStringGrammarAction(){
 	LogDebug("EmptyStringGrammarAction()");
}

void CharsBodyStringGrammarAction() {
	LogDebug("CharsBodyStringGrammarAction()");
} 

void IntegerBodyStringGrammarAction(){
	LogDebug("IntegerBodyStringGrammarAction()");
}

void ExpressionResultBodyStringGrammarAction(){
	LogDebug("ExpressionResultBodyStringGrammarAction()");
}


void ConcatCharsBodyStringGrammarAction(){
	LogDebug("ConcatCharsBodyStringGrammarAction()");
}

void ConcatIntegerBodyStringGrammarAction(){
	LogDebug("ConcatIntegerBodyStringGrammarAction()");
}

void ConcatExpressionResultBodyStringGrammarAction(){
	LogDebug("ConcatExpressionResultBodyStringGrammarAction()");
}
