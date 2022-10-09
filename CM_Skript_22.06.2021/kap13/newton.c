#include <stdio.h>
#include <math.h>

double newton(double (*func)(double),
              double (*funcabl)(double),
              double startwert,
              double toleranz)
{
  int zaehler = 0;

  while( fabs(func(startwert)) > toleranz && zaehler++ < 100 )
    startwert = startwert - ( func(startwert)/funcabl(startwert) );

  return( zaehler>=100 ? 0 : startwert );
}
