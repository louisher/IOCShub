/*
  callIntegerSolver.cpp  --  diagnostic: print x and djdx every few iterations.

  The callback re-enters every SAMPLE_EVERY iterations (set via numIter). On
  each entry it prints, for every continuous variable, its name, current value
  x[i], and objective gradient djdx[i]. Both arrays have length n_x.

  This is an OBSERVER: it does not fix integers, it just samples until the NLP
  converges and then stops. Merge with your integer logic if you need both.

  Build with CompileIntegerSolver.sh, put the .so next to the model, run, read
  stdout.
*/

#include "IntegerSolver.h"
#include <cstdio>
#include <cmath>

#define SAMPLE_EVERY 5    // run this many NLP iterations between prints
#define MAX_PRINT    0    // 0 = print all continuous vars; else cap how many

std::vector<int> getLenData(IntegerSolver* solver){ return {1}; }
int initData(IntegerSolver* solver){ solver->data[0][0] = 0; return 0; }
int allowWarmStart(IntegerSolver* solver){ return 1; }

void callIntegerSolver(IntegerSolver* solver,
	double* x,
	const double* integers,
	double* lbi,
	double* ubi,
	const double objective,
	const double* djdx,
	const double* djdint,
	double conv,
	bool convergedNlp,
	int it,
	int &numIter,
	bool &integerSolverConverged){

	static bool banner = false;
	if (!banner){
		banner = true;
		printf("== x / djdx sampler (every %d iterations) ==\n", SAMPLE_EVERY);
		printf("n_x=%d  n_i=%d   (x and djdx both have length n_x)\n",
			solver->n_x, solver->n_i);
		fflush(stdout);
	}

	// sample again after SAMPLE_EVERY iterations
	numIter = SAMPLE_EVERY;

	if (x == nullptr || djdx == nullptr){
		printf("[it=%d] x or djdx is null this call (x=%p djdx=%p) -- skipping.\n",
			it, (void*)x, (const void*)djdx);
		fflush(stdout);
		integerSolverConverged = false;
		return;
	}

	const int n_x   = solver->n_x;
	const int limit = (MAX_PRINT > 0 && MAX_PRINT < n_x) ? MAX_PRINT : n_x;
	const size_t nNames = solver->optVarNames ? solver->optVarNames->size() : 0;

	printf("\n[it=%d] objective=%.10g  conv=%.4g  convergedNlp=%d\n",
		it, objective, conv, (int)convergedNlp);
	printf("  %4s  %-36s  %18s  %18s\n", "idx", "name", "x", "djdx");
	for (int i = 0; i < limit; ++i){
		const char* nm = ((size_t)i < nNames)
			? (*solver->optVarNames)[i].c_str() : "(no name)";
		printf("  %4d  %-36s  %18.10g  %18.10g\n", i, nm, x[i], djdx[i]);
	}
	if (limit < n_x)
		printf("  ... (%d more; set MAX_PRINT higher to see them)\n", n_x - limit);
	fflush(stdout);

	// stop the observer cleanly once the NLP has converged
	if (convergedNlp){
		printf("[it=%d] NLP converged -- final sample above. Stopping observer.\n", it);
		fflush(stdout);
		integerSolverConverged = true;
		numIter = 2000;
	} else {
		integerSolverConverged = false;
	}
}