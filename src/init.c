
/* Symbol registration initialization.
 *
 * All functions called from R should be registered here (as well as declared
 * in tm.h). Note that we use a prefix (.fixup = "_C" defined in NAMESPACE).
 * Functions do _not_ have the C_ prefix in C but need the C_ prefix when
 * called (.Call()) from R.
 */
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

/* Include package header file */
#include "tm.h"

static const R_CallMethodDef callMethods[] = {
  {"tm_predict",             (DL_FUNC) &tm_predict,           6},
  {"tm_predict_pdfcdf",      (DL_FUNC) &tm_predict_pdfcdf,    4},
  {"tm_detect_cores",        (DL_FUNC) &tm_detect_cores,      0},
  {NULL, NULL, 0} // Termination entry
};


void R_init_TransitionModels(DllInfo *dll) {
    /* Registering .Call functions */
    R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
    /* Disable dynamic symbol lookup for safety reasons */
    R_useDynamicSymbols(dll, FALSE);
}
