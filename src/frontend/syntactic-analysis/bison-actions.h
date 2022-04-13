#ifndef BISON_ACTIONS_HEADER
#define BISON_ACTIONS_HEADER

#include "../../backend/support/shared.h"

/**
 * Se definen las acciones a ejecutar sobre cada regla de producción de la
 * gramática. El objetivo de cada acción debe ser el de construir el nodo
 * adecuado que almacene la información requerida en el árbol de sintaxis
 * abstracta (i.e., el AST).
 */

// Programa.
int ProgramGrammarAction(const int value);

// Expresion Result.
void ExpressionResultGrammarAction();

// Expresión.
int AdditionExpressionGrammarAction(const int leftValue, const int rightValue);
int SubtractionExpressionGrammarAction(const int leftValue, const int rightValue);
int MultiplicationExpressionGrammarAction(const int leftValue, const int rightValue);
int DivisionExpressionGrammarAction(const int leftValue, const int rightValue);
int FactorExpressionGrammarAction(const int value);

// Factores.
int ExpressionFactorGrammarAction(const int value);
int ConstantFactorGrammarAction(const int value);
int VariableFactorGrammarAction();

// Variables.
int VariableGrammarAction();

// Constantes.
int IntegerConstantGrammarAction(const int value);

//String
void StringGrammarAction();
void EmptyStringGrammarAction();

// String body 
void CharsBodyStringGrammarAction(); 
void IntegerBodyStringGrammarAction(); 
void ExpressionResultBodyStringGrammarAction();
void ConcatCharsBodyStringGrammarAction();
void ConcatIntegerBodyStringGrammarAction();
void ConcatExpressionResultBodyStringGrammarAction();

#endif
