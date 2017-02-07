#include<stdio.h>

int func(int a)
{
  int b = 1;
  int c = a + b;
  printf("%d",c);
  return 0;
}

int main(int argc, char* argv[])
{
  func(1);
  return 0;
}
