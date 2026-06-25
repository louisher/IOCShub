/* 
  Author: Filip Jorissen, KU Leuven, Belgium

  This code is an integer solver plugin for TACO.

*/


#include <iostream>
#include <vector>

#ifndef INTSOLVER_h
#define INTSOLVER_h

using namespace std;

/* Struct for storing persistent solver data */

typedef struct IntegerSolver {
	// Fixed variables that should not be modified

	// sizes/lengths
	int n_x;	/* Number of continuous optimization variables */
	int n_i;	/* Number of integer optimization variables */
	int n_out;	/* Number of output variables */
	int n_controlIntervals; /* Number of control intervals */
	// int n_o;	/* Number of output variables */

	double * ubi;	/* Upper bounds for integer optimization variables */
	double * lbi;	/* Lower bounds for integer optimization variables */
	double * iNom;	/* Nominal values for integer optimization variables */

	// bool return_outputs; /* Set to true to compute outputs at each iteration (at the cost of 1 function evaluation) */

	double dt_controlInterval; /* The duration in seconds of a control interval with unit interval length. */
	const std::vector <int > * intervalLengths; /* Pointer to a vector containing the interval lengths */
	const std::vector <std::string > * optVarNames; /* Pointer to a vector of continous optimisation variable names */
	const std::vector <std::string > * intVarNames; /* Pointer to a vector of integer optimisation variable names */
	const std::vector <std::string > * outVarNames; /* Pointer to a vector of integer optimisation variable names */
	const std::vector <std::string > * intVarQuantities; /* Pointer to a vector of integer optimisation variable names */

	int allowWarmStart; /* if 1, caches solver->data when terminating */
	int(*getOutput)(IntegerSolver* integerSolver, double * integers, double * outputs);
	int(*getAllOutputs)(IntegerSolver* integerSolver, double * integers, double * outputs, double *objectiveTerms);

	// Operational variables that can be modified at will: 

	int status; /* Integer solver status */
	std::vector <int> *lenData; /* Vector of vector lengths that correspond to 'data' */
	double **data; /* Memory address for storing vectors of data */

} IntegerSolver;

int IntegerSolver_init(IntegerSolver* solver,
		int n_x, 
		int n_i, 
		int n_out, 
		int n_controlIntervals, 
		double dt_controlInterval,
		const std::vector<int> *intervalLengths,
		double* lbi, 
		double* ubi, 
		const std::vector <std::string > * optVarNames, 
		const std::vector <std::string > * intVarNames, 
		const std::vector <std::string > * outVarNames, 
		const std::vector <std::string > * intVarQuantities, 
		double *iNom,
		int(*getOutputFun)(IntegerSolver* integerSolver, double * integers, double * outputs),
		int(*getAllOutputsFun)(IntegerSolver* integerSolver, double * integers, double * outputs, double *objectiveTerms)
		);

int IntegerSolver_finalize_init(IntegerSolver* solver);

void IntegerSolver_close(IntegerSolver* solver);

void callIntegerSolver(IntegerSolver* solver, double* x, const double* integers, double* lbi, double* ubi, const double objective, const double* djdx, const double* djdint, double conv, bool convergedNlp, int it, int &numIter, bool & integerSolverConverged);

std::vector<int> getLenData(IntegerSolver* solver);

int initData(IntegerSolver *solver);

int allowWarmStart(IntegerSolver* solver);

#endif
