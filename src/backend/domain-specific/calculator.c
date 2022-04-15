#include "calculator.h"

/**
 * Implementación de "calculator.h".
 */

int Add(const int leftAddend, const int rightAddend) {
	return leftAddend + rightAddend;
}

int Subtract(const int minuend, const int subtract) {
	return minuend - subtract;
}

int Multiply(const int multiplicand, const int multiplier) {
	return multiplicand * multiplier;
}

int Divide(const int dividend, const int divisor) {
	return dividend / divisor;
}

int Equals(const int leftFormula, const int rightFormula) {
	return leftFormula == rightFormula;
}

int Nequals(const int leftFormula, const int rightFormula) {
	return leftFormula != rightFormula;
}

int LessThan(const int leftFormula, const int rightFormula) {
	return leftFormula < rightFormula;
}

int LessOrEqualTo(const int leftFormula, const int rightFormula) {
	return leftFormula <= rightFormula;
}

int GreaterThan(const int leftFormula, const int rightFormula) {
	return leftFormula > rightFormula;
}

int GreaterOrEqualTo(const int leftFormula, const int rightFormula) {
	return leftFormula >= rightFormula;
}

int And(const int leftFormula, const int rightFormula) {
	return leftFormula && rightFormula;
}

int Or(const int leftFormula, const int rightFormula) {
	return leftFormula || rightFormula;
}

int Not(const int formula) {
	return !(formula);
}