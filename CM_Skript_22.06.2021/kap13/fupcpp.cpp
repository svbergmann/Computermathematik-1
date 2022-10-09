class Vektor {
private:
  float *vek;
public:
  void setzten(float *v){vek = v;}
  void erhoehen(int);
};

void Vektor::erhoehen(int anzahl)
{
  int i;
  for( i=0; i < anzahl; ++i)
    vek[i] = vek[i] + (i+1)*3.14;
}

extern "C" void fup( int m, float y[] )
{
  int i;
  for( i=0; i < m; ++i)
    y[i] = y[i] + (i+1)*3.14;
}
