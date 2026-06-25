/*
  callIntegerSolver.cpp  --  original brute-force integer solver + an optional
  probe that tests whether THIS callback can pin a CONTINUOUS variable through
  lower/upper bounds (lbx/ubx).

  Baseline behaviour (PROBE_XBOUNDS 0) is identical to the original plugin,
  plus two harmless prints: a build banner and the variable layout.

  ---------------------------------------------------------------------------
  HOW TO USE
   1. Build as-is:  ./CompileIntegerSolver.sh
      Put libIntegerSolver.{so,dylib} next to the model, run the optimization.
      In stdout, confirm:
        - the banner "== custom IntegerSolver build ... =="  (proves YOUR .so
          is the one loaded, not a cached/default copy on the load path);
        - the optVarNames list. Note the index/name of your continuous
          parameter p there.
   2. Find how continuous bounds reach the plugin in YOUR TACO build:
        grep -rniE 'lbx|ubx|lb_x|ub_x|x_lb|x_ub' --include=*.h --include=*.cc .
      and look at how callIntegerSolver is DECLARED in your real header.
   3. Set PROBE_XBOUNDS to 1, set PROBE_VARNAME, and uncomment the ONE XLB/XUB
      pair that matches what you found. Recompile and rerun. Read the result:
        - compile error            -> continuous bounds are NOT in scope in this
                                      hook. You're tier 2 (use the integer-grid
                                      target). No run needed.
        - compiles, var HOLDS the pinned value across re-converge -> tier 1,
                                      bounds are live and writable. Pin p_target
                                      directly.
        - compiles, var DRIFTS back -> array exists but the solver ignores
                                      mid-solve edits from here. Treat as tier 2.

  IMPORTANT: do NOT add lbx/ubx to the function signature just to make it
  compile. The signature must match what the TACO binary calls; inventing
  arguments it doesn't pass is undefined behaviour (garbage pointers/crashes).
  Only enable a form that your grep actually confirms.
  ---------------------------------------------------------------------------
*/

#include "IntegerSolver.h"
#include <cmath>        // std::abs, std::round
#include <string>

// ============================ PROBE CONFIG =================================
#define PROBE_XBOUNDS 0          // 0 = normal solver; 1 = run the bound probe
#define PROBE_VARNAME "p"        // name of the continuous variable to pin

#if PROBE_XBOUNDS
  // Uncomment EXACTLY ONE pair, matching how your build exposes continuous
  // bounds. Leave all commented and the #error below reminds you to choose.
  //
  //   (a) passed to this callback as arguments named lbx / ubx
  //       (only valid if your real signature already has them):
  // #define XLB(i) lbx[i]
  // #define XUB(i) ubx[i]
  //
  //   (b) fields on the solver struct:
  // #define XLB(i) solver->lbx[i]
  // #define XUB(i) solver->ubx[i]
  //
  //   (c) some builds name them differently, e.g.:
  // #define XLB(i) solver->x_lb[i]
  // #define XUB(i) solver->x_ub[i]

  #if !defined(XLB) || !defined(XUB)
    #error "PROBE_XBOUNDS=1: uncomment one XLB/XUB pair that matches your build."
  #endif
#endif
// ==========================================================================

// Locate a continuous variable by name in optVarNames.
// NOTE: this returns the index into optVarNames. Whether x[] is indexed the
// same way (vs. expanded per control interval) is toolchain-dependent -- if
// the printed "before" value looks wrong, your x layout differs and you should
// map the index accordingly. For a single time-invariant parameter it is
// normally one entry.
static int findOptVarIndex(IntegerSolver* solver, const std::string& name){
	if (!solver->optVarNames) return -1;
	for (size_t i = 0; i < solver->optVarNames->size(); ++i)
		if ((*solver->optVarNames)[i] == name) return (int)i;
	return -1;
}


// The line below is a template
// *solver->lenData = std::vector<int>({10,11,12});
std::vector<int> getLenData(IntegerSolver* solver){
	return {solver->n_i, 1, solver->n_i, 1};
}

// Initialise the data that has been allocated
int initData(IntegerSolver *solver){
	std::copy(solver->lbi, solver->lbi + solver->n_i, solver->data[0]); // lower bounds -> first array
	std::copy(solver->lbi, solver->lbi + solver->n_i, solver->data[2]); // lower bounds -> third array

	solver->data[1][0] = 1e100; // default value in first element of second array
	solver->data[3][0] = -1;

	return 0;
}

int allowWarmStart(IntegerSolver* solver){
	return 1;
}

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
	bool & integerSolverConverged){

	// ---- one-time banner + variable layout (harmless, always on) ----------
	static bool announced = false;
	if (!announced){
		announced = true;
		printf("== custom IntegerSolver build: xbound-probe v1 (PROBE_XBOUNDS=%d) ==\n",
			PROBE_XBOUNDS);
		printf("n_x=%d  n_i=%d  n_out=%d  n_controlIntervals=%d\n",
			solver->n_x, solver->n_i, solver->n_out, solver->n_controlIntervals);
		if (solver->optVarNames){
			printf("optVarNames (%zu):\n", solver->optVarNames->size());
			for (size_t i = 0; i < solver->optVarNames->size(); ++i)
				printf("  optVar[%zu] = %s\n", i, (*solver->optVarNames)[i].c_str());
		}
		if (solver->intVarNames){
			printf("intVarNames (%zu):\n", solver->intVarNames->size());
			for (size_t i = 0; i < solver->intVarNames->size(); ++i)
				printf("  intVar[%zu] = %s\n", i, (*solver->intVarNames)[i].c_str());
		}
		fflush(stdout);
	}

#if PROBE_XBOUNDS
	// ---- continuous-bound obedience probe ---------------------------------
	// phase 0: pin the variable away from its optimum; phase 1: read it back;
	// phase 2: done -> fall through to the normal integer logic.
	static int    probePhase = 0;
	static int    idx        = -1;
	static double origLb = 0.0, origUb = 0.0, target = 0.0;

	if (probePhase == 0 && convergedNlp){
		idx = findOptVarIndex(solver, PROBE_VARNAME);
		if (idx < 0){
			printf("[probe] '%s' not found in optVarNames -- cannot probe. "
			       "Check the layout dump above.\n", PROBE_VARNAME);
			probePhase = 2;
		} else {
			origLb = XLB(idx);
			origUb = XUB(idx);
			double cur = x[idx];

			// choose a target the variable must actually travel to, staying
			// inside its declared bounds (pinning outside bounds would look
			// like a failure when it's really an infeasibility).
			bool finiteLb = std::abs(origLb) < 1e19;
			bool finiteUb = std::abs(origUb) < 1e19;
			if (finiteLb && finiteUb){
				double range = origUb - origLb;
				target = origLb + 0.25 * range;
				if (std::abs(target - cur) < 0.05 * std::abs(range) + 1e-9)
					target = origLb + 0.75 * range;   // ensure a real gap from cur
			} else {
				target = cur + (std::abs(cur) > 1e-9 ? 0.3 * std::abs(cur) : 1.0);
				if (finiteUb && target > origUb) target = origUb;
				if (finiteLb && target < origLb) target = origLb;
			}

			printf("[probe] idx=%d name=%s  before x=%.10g  origLb=%.10g origUb=%.10g\n",
				idx, PROBE_VARNAME, cur, origLb, origUb);
			printf("[probe] pinning x[%d] to %.10g and re-converging...\n", idx, target);
			fflush(stdout);

			XLB(idx) = target;
			XUB(idx) = target;
			numIter = 30;            // give the NLP room to re-converge under the pin
			probePhase = 1;
			return;                  // inspect on the next callback
		}
	}

	if (probePhase == 1 && convergedNlp){
		double after = x[idx];
		double tol   = 1e-4 * (std::abs(target) + 1.0);
		printf("[probe] after  x=%.10g  (target %.10g, diff %.3g, tol %.3g)\n",
			after, target, after - target, tol);
		if (std::abs(after - target) < tol)
			printf("[probe] RESULT: continuous bounds are LIVE and writable here (tier 1).\n");
		else
			printf("[probe] RESULT: write had no/partial effect "
			       "(bounds exposed but ignored mid-solve -- treat as tier 2).\n");
		fflush(stdout);

		// restore so the remainder of the solve is unaffected by the probe
		XLB(idx) = origLb;
		XUB(idx) = origUb;
		numIter  = 5;
		probePhase = 2;
		return;
	}
#endif // PROBE_XBOUNDS

	// ================= ORIGINAL BRUTE-FORCE INTEGER LOGIC ==================
	numIter = 5;
	double * currentOptimumIntegers = solver->data[0];
	double * currentOptimumObjective= solver->data[1];
	double * currentIntegers = solver->data[2];
	double * convergedFlag = solver->data[3];

	if (convergedNlp){
		integerSolverConverged = false;
		bool incremented = false;
		if (objective < *currentOptimumObjective && *convergedFlag < 0){
			std::copy(currentIntegers, currentIntegers + solver->n_i, currentOptimumIntegers);
			*currentOptimumObjective = objective;
		}

		// brute-force the solution,
		// sequentially increment each of the integers until the upper bound is reached
		for (int i = 0; *convergedFlag < 0 && i < solver->n_i; ++i)
		{
			if (std::abs(currentIntegers[i] - solver->ubi[i]) < 1e-10){
				currentIntegers[i] = solver->lbi[i]; // reset this integer to lower bound and try to increment the next integer in next loop
				ubi[i] = solver->lbi[i];
				lbi[i] = solver->lbi[i];
			}else{
				currentIntegers[i]++;
				ubi[i] = currentIntegers[i];
				lbi[i] = currentIntegers[i];
				incremented = true;
				break;
			}
		}
		if (not incremented){ // we overflowed the integer vector and have thus evaluated all options
			if (*convergedFlag < 0){
				// use the best solution so far
				std::copy(currentOptimumIntegers, currentOptimumIntegers + solver->n_i, currentIntegers);
				std::copy(currentOptimumIntegers, currentOptimumIntegers + solver->n_i, ubi);
				std::copy(currentOptimumIntegers, currentOptimumIntegers + solver->n_i, lbi);
				std::cout << "Converged to integer values: ";
				for (int i = 0; i < solver->n_i; ++i){
					std::cout << currentIntegers[i] << " ";
				}
				std::cout << std::endl;
				*convergedFlag = 1; // do not converge yet, but set a flag for next time the integer solver is called
				// this forces 'numIter' more iterations before converging. Otherwise the problem may converge immediately.
			}else{
				std::cout << "Integer solver converged" << std::endl;

				//some example code for how to use getOutputs()
				int n_out = solver->n_out/solver->n_controlIntervals;
				double result[n_out];
				solver->getOutput(solver, solver->ubi, result);
				for (int i = 0; i < n_out; ++i){
					printf("Result output at ubi for index %i, name %s is %f\n", i, solver->outVarNames[0][i].c_str(), result[i]);
				}
				solver->getOutput(solver, solver->lbi, result);
				for (int i = 0; i < n_out; ++i){
					printf("Result output at lbi for index %i, name %s is %f\n", i, solver->outVarNames[0][i].c_str(), result[i]);
				}
				integerSolverConverged = true;

				double longResult[solver->n_out];
				double objectiveTerms[solver->n_controlIntervals + 1]; // the first term is the fixed objective term
				solver->getAllOutputs(solver, solver->ubi, longResult, objectiveTerms);
				printf("Fixed objective term: %e\n", objectiveTerms[0]);
				for (int i = 1; i <= solver->n_controlIntervals; ++i){
					printf("Objective term for interval %i: %e\n", i, objectiveTerms[i]);
				}
			}

		}else{
			// print some output
			std::cout << "Integers updated to: ";
			for (int i = 0; i < solver->n_i; ++i){
				std::cout << currentIntegers[i] << " ";
			}
			std::cout << std::endl;
		}
	}else{
		numIter = 1; // try again next iteration to see whether the nlp has converged
	}
}
