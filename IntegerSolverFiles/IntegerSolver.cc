/* 
  Author: Filip Jorissen, KU Leuven, Belgium

  This code is an integer solver plugin for TACO.

*/


#include "IntegerSolver.h"
#include <cmath>        // std::abs

/* This file contains all code that is solver-independent */


/*  This initialises the solver 
	Only modify the indicated line
	*/
int IntegerSolver_init(
	IntegerSolver* solver, 
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
	double* iNom,
	int(*getOutputFun)(IntegerSolver* solver, double * integers, double * outputs),
	int(*getAllOutputsFun)(IntegerSolver* solver, double * integers, double * outputs, double * objectiveTerms)){


	solver->n_x = n_x;
	solver->n_i = n_i;
	solver->n_out = n_out;
	solver->n_controlIntervals = n_controlIntervals;
	solver->optVarNames = optVarNames;
	solver->intVarNames = intVarNames;
	solver->outVarNames = outVarNames;
	solver->intVarQuantities = intVarQuantities;
	solver->getOutput = getOutputFun;
	solver->getAllOutputs = getAllOutputsFun;

	// get the data block sizes requested by the solver
	solver->dt_controlInterval = dt_controlInterval;
	solver->intervalLengths = intervalLengths;
	solver->lenData = new std::vector<int>();
	*solver->lenData = getLenData(solver); 

	const int n_data = solver->lenData->size();

	//allocate memory for the vector of vector pointers
	solver->data = new double*[n_data]; /* 'data' is a new vector of double pointers */
	for (int i = 0; i < n_data; ++i){
		//allocate memory for each double pointer
		solver->data[i] = new double[(*solver->lenData)[i]];
		std::fill (solver->data[i], solver->data[i] + (*solver->lenData)[i], -1);
	}

	// allocate memory
	solver->ubi = new double[n_i];
	solver->lbi = new double[n_i];
	solver->iNom = new double[n_i];

	solver->allowWarmStart = allowWarmStart(solver);

	// initial values
	std::copy(ubi, ubi + n_i, solver->ubi); // store upper bounds for later use
	std::copy(lbi, lbi + n_i, solver->lbi); // store lower bounds for later use
	std::copy(iNom, iNom + n_i, solver->iNom); // store nominal values for later use
	
	return 0;
}

int IntegerSolver_finalize_init(IntegerSolver* solver){
	// call solver-specific initialisations _after warm start_
	return initData(solver);
}

// Do not change this function.
void IntegerSolver_close(IntegerSolver* solver){
	const int n_data = solver->lenData->size();
	for (int i = 0; i < n_data; ++i){
		// free memory
		delete[] solver->data[i];
	}
	delete[] solver->data;
	delete solver->lenData;
	delete[] solver->ubi;
	delete[] solver->lbi;
	delete[] solver->iNom;
}

