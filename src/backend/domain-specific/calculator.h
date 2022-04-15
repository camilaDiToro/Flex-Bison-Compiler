#ifndef CALCULATOR_HEADER
#define CALCULATOR_HEADER

int Add(const int leftAddend, const int rightAddend);

int Subtract(const int minuend, const int subtract);

int Multiply(const int multiplicand, const int multiplier);

int Divide(const int dividend, const int divisor);

int Equals(const int leftFormula, const int rightFormula);

int Nequals(const int leftFormula, const int rightFormula);

int LessThan(const int leftFormula, const int rightFormula);

int LessOrEqualTo(const int leftFormula, const int rightFormula);

int GreaterThan(const int leftFormula, const int rightFormula);

int GreaterOrEqualTo(const int leftFormula, const int rightFormula);

int And(const int leftFormula, const int rightFormula);

int Or(const int leftFormula, const int rightFormula);

int Not(const int formula);

#endif
