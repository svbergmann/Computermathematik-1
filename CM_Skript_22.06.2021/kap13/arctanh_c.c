#include <Nag/nag.h>
#include <Nag/nag_names.h>
#include <Nag/nag_stdlib.h>
#include <Nag/nags.h>

double arctanh( double x)
{
  return nag_arctanh( x, NAGERR_DEFAULT);
}
