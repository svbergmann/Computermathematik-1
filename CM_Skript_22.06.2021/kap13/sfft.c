#include <math.h>

// Copyright (c) 1990 by the University of Waterloo. All rights reserved.
float sFFT (int m, float *x, float *y)
{
  float n;
  float l;
  float le;
  float le1;
  float ur;
  float ui;
  float wr;
  float wi;
  float j;
  float i;
  float ip;
  float tr;
  float ti;
  float sr;
  float si;
  float nv2;
  float nm1;
  float k;
  n = (float) (int) pow((float) 2, (float) m);
  le1 = n;
  for (l = 0.10e1f; l <= (float) m; l += 0.10e1f)
  {
    le = le1;
    le1 = le / 0.2e1f;
    ur = 0.1e1f;
    ui = 0.0e0f;
    wr = (double)(cos(0.31415927e1f / le1));
    wi = (double)(-sin(0.31415927e1f / le1));
    for (j = 0.10e1f; j <= le1; j += 0.10e1f)
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
  nv2 = n / 0.2e1f;
  nm1 = n - 0.1e1f;
  j = 0.1e1f;
  for (i = 0.10e1f; i <= nm1; i += 0.10e1f)
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
      k = k / 0.2e1f;
    }
    j = j + k;
  }
  return(n);
}
