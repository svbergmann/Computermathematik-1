#include <nag.h>
#include <nag_types.h>
#include <stdio.h>
#include <nag_stdlib.h>
#include <nagf04.h>

int linsol( int dim, double a[dim][dim], double b[dim], double sol[dim])
{
static NagError fail;

  f04arc( dim, (double*) a, dim, b, sol, &fail);
 
  return fail.code;
}
