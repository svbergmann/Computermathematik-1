
/* The options were    : Copyright (c) 1990 by the University of Waterloo. All rights reserved. */
#include <math.h>
float sFFT(m,x,y)
int m;
float *x;
float *y;
{
  int i;
  int ip;
  int j;
  float k;
  int l;
  float le;
  float le1;
  float n;
  float nm1;
  float nv2;
  float si;
  float sr;
  float ti;
  float tr;
  float ui;
  float ur;
  float wi;
  float wr;
  {
    n = pow(2.0,1.0*m);
    le1 = n;
    for(l = 1;l <= m;l++)
    {
      le = le1;
      le1 = le/2.0;
      ur = 1.0;
      ui = 0.0;
      wr = 0.1E1*cos(0.3141593E1/le1);
      wi = -0.1E1*sin(0.3141593E1/le1);
      for(j = 1;j <= le1;j++)
      {
        for(i = j;le < 0.0 && n-i <= 0.0 || -le <= 0.0 && le <= 0.0 || -le < 
0.0 && i-n <= 0.0;i += le)
        {
          ip = i+le1;
          tr = x[i-1]+x[ip-1];
          ti = y[i-1]+y[ip-1];
          sr = x[i-1]-x[ip-1];
          si = y[i-1]-y[ip-1];
          x[ip-1] = sr*ur-si*ui;
          y[ip-1] = sr*ui+si*ur;
          x[i-1] = tr;
          y[i-1] = ti;
        }
        tr = ur*wr-ui*wi;
        ui = ur*wi+ui*wr;
        ur = tr;
      }
    }
    nv2 = n/2.0;
    nm1 = -1.0+n;
    j = 1;
    for(i = 1;i <= nm1;i++)
    {
      if( i < j )
        {
          tr = x[j-1];
          ti = y[j-1];
          x[j-1] = x[i-1];
          y[j-1] = y[i-1];
          x[i-1] = tr;
          y[i-1] = ti;
        }
      k = nv2;
      while(k < j)
      {
        j += -k;
        k = k/2.0;
      }
      j += k;
    }
    return(n);
  }
}

