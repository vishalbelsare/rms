#include <R_ext/RS.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .Fortran calls */
extern void F77_NAME(lrmll)(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void F77_NAME(matinv)(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);
extern void F77_NAME(robcovf)(void *, void *, void *, void *, void *, void *, void *, void *);
extern void F77_NAME(ormll)(void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *, void *);

static const R_FortranMethodDef FortranEntries[] = {
    {"lrmll",   (DL_FUNC) &F77_NAME(lrmll),   19},
    {"matinv",  (DL_FUNC) &F77_NAME(matinv),  11},
    {"robcovf", (DL_FUNC) &F77_NAME(robcovf),  8},
    {"ormll",   (DL_FUNC) &F77_NAME(ormll),   33},
    {NULL, NULL, 0}
};

void R_init_rms(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, NULL, FortranEntries, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
