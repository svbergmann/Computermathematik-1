void matmul( int inRowA, int inColA, int inColB, 
             double inA[inRowA][inColA],
             double inB[inColA][inColB],
             double inC[inRowA][inColB] )
{
  int i, j, k;
  double temp;

  for(i=0; i < inRowA; ++i)
    for( j=0; j < inColB; ++j)
      {
        temp = 0;
	for( k=0; k < inColA; ++k)
          temp += inA[i][k]*inB[k][j];
        inC[i][j] = temp;
      }
}   
