#include <math.h>

// Copyright (c) 1990 by the University of Waterloo. All rights reserved.
double dFFT (int m, double *x, double *y)
{
  double n;
  double l;
  double le;
  double le1;
  double ur;
  double ui;
  double wr;
  double wi;
  double j;
  double i;
  double ip;
  double tr;
  double ti;
  double sr;
  double si;
  double nv2;
  double nm1;
  double k;
  n = (double) (int) pow((double) 2, (double) m);
  le1 = n;
  for (l = 0.10e1; l <= (double) m; l += 0.10e1)
  {
    le = le1;
    le1 = le / 0.2e1;
    ur = 0.1e1;
    ui = 0.0e0;
    wr = (double)(cos(0.3141592653589793e1 / le1));
    wi = (double)(-sin(0.3141592653589793e1 / le1));
    for (j = 0.10e1; j <= le1; j += 0.10e1)
    {
      for (i = j; i <= n; i += le)
      {
        ip = i + le1;
        tr = x[(int) i - 1] + x[(int) ip - 1];
        ti = y[(int) i - 1] + y[(int) ip - 1];
        sr = x[(int) i - 1] - x[(int) ip - 1];
        si = y[(int) i - 1] - y[(int) ip - 1];
        x[(int) ip - 1] = sr * ur - si * ui;
        y[(int) ip - 1] = sr * ui + si * ur;
        x[(int) i - 1] = tr;
        y[(int) i - 1] = ti;
      }
      tr = ur * wr - ui * wi;
      ui = ur * wi + ui * wr;
      ur = tr;
    }
  }
  nv2 = n / 0.2e1;
  nm1 = n - 0.1e1;
  j = 0.1e1;
  for (i = 0.10e1; i <= nm1; i += 0.10e1)
  {
    if (i < j)
    {
      tr = x[(int) j - 1];
      ti = y[(int) j - 1];
      x[(int) j - 1] = x[(int) i - 1];
      y[(int) j - 1] = y[(int) i - 1];
      x[(int) i - 1] = tr;
      y[(int) i - 1] = ti;
    }
    k = nv2;
    while (k < j)
    {
      j = j - k;
      k = k / 0.2e1;
    }
    j = j + k;
  }
  return(n);
}
