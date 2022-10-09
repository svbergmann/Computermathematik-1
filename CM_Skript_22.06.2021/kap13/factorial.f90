       INTEGER FUNCTION factorial(kv, args)
  
         INCLUDE "maplefortran.hf"
         INTEGER kv, args
         
         INTEGER arg, i, n, res
         
         res=1
         
         IF ( maple_num_args(kv, args) .NE. 1) THEN
            CALL maple_raise_error( kv, "one argument expected", 22 )
            factorial = to_maple_null( kv )
            RETURN
         ENDIF

         IF ( is_maple_integer(kv, args) .EQ. 0) THEN
            CALL maple_raise_error( kv, "argument has to be int", 22 )
            factorial = to_maple_null( kv )
            RETURN
         ENDIF

         arg = maple_extract_arg( kv, args, 1)
         n = maple_to_integer32(kv, arg)

C         IF ( n > 0 )
            CALL maple_raise_error( kv, "argument has to be > 0", 22 )
            factorial = to_maple_null( kv )
            RETURN
C         ENDIF

C         for(i=2;i<=n;++i)
C         res *= i;

         factorial = to_maple_integer( kv, res );

       END FUNCTION factorial
