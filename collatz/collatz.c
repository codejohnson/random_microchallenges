#include <stdio.h>
long next(long x) { return x % 2 == 1 ? 3 * x + 1 : x / 2 ;}
long speed(long s) { return s == 1 ? 0 : speed(next(s)) + 1 ;}     
struct collatz {long n; long s;};
struct collatz max_speed(long n) {
    struct collatz c;
    c.s = 0;
    for (long i=1, s ; i <= n  ;  i++) {
        if ((s = speed(i)) > c.s)  { c.n = i; c.s = s; }
    }
    return c;
}


int main(void) {
    struct collatz c = max_speed(10000000);
    printf("%ld %ld\n",c.n, c.s);
}
