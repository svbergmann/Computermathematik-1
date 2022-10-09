#include <stdlib.h>
#include <maplec.h>

ALGEB factorial( MKernelVector kv,
                 ALGEB args )
{
  int i, n;
  long res=1;
  ALGEB mr;
  
  if (MapleNumArgs(kv,args) != 1)
    MapleRaiseError(kv, "one argument expected");

  if (!IsMapleInteger32(kv,(ALGEB)args[1]))
    MapleRaiseError(kv,"argument has to be of type integer");

  n = MapleToInteger32(kv,(ALGEB)args[1]);

  if ( n < 0 )
    MapleRaiseError(kv,"argument has to be > 0");

  for(i=2;i<=n;++i)
    res *= i;
  
  mr = ToMapleInteger(kv, res);

  return( mr );
}
