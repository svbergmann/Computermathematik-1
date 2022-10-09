#include <math.h>

void fup( int m, float y[])
{
  int i;
  float Pi = M_PI;

  for( i=0; i < m; ++i)
    y[i] = y[i] + (i+1)*Pi;
}
