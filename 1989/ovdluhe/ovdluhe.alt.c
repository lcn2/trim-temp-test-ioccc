#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
typedef char ape;
#define EA register
#define EP unsigned
#define A 1
#define AP (A<<A)
#ifndef P
#define P (A<<AP)
#endif
#define AE ((P<<P)<<A)
#define PE (((A<<P)<<P)<<P)
#define E ((EP)A>>A)
#define APE {EA EP ape,ea=AE;while(ea--) e[ea]=E;}
PA();
;ape a[PE+A],ap,*ae,p[P+A],e[AE];
main(){ape pe,*ep=a;srand((EP)time((long)E));
while(((*(ep++)=getchar())!=-A)&&((ep-a)<PE));
*(ae= --ep)=E;for(ap=E;ap<=P;){APE;if(pe=PA())
{putchar(pe);if(ap<P){p[ap]=pe;ap++;}else{
ep=p+A;while(*ep) *(ep-A)= *(ep++); *(ep-A)=pe;}}else break;}}
PA(){EA ape pe,*ep=a,pa,Ap=E;for(ep=a;ep<ae-P;ep++)
if(!strncmp(ep,p,ap)){e[*(ep+ap)]++;Ap++;}if(!Ap)return(Ap);
pa=rand()%Ap+A;pe=~E,Ap=!Ap;while((Ap+=e[++pe])<pa);return(pe);}
