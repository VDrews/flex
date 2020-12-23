%option noyywrap
/*----- Seccion de Declaraciones ----------------*/
%{
#include <iostream>
#include <fstream>

using namespace std;

ifstream fichero;
int nc, np, nl;
void escribir_datos (int dato1, int dato2, int dato3);
%}

%%
[^ \t\n]+ { np++; nc += yyleng; }
[ \t]+ { nc += yyleng; }
\n { nl++; nc++; }
%%

/*----- Seccion de Procedimientos --------*/
int main (int argc, char *argv[])
{
if (argc == 2)
{
fichero.open (argv[1]);
if (fichero==0)
{
cout << "error de lecura" << endl;
exit (1);
}
}
else exit(1);
nc = np = nl = 0;
yyFlexLexer flujo (&fichero,0);
flujo.yylex();
escribir_datos(nc,np,nl);
return 0;
}
void escribir_datos (int dato1, int dato2, int dato3)
{
cout << "Num_lineas = " << dato3 << endl;
cout << "Num_palabras = " << dato2 << endl;
cout << "Num_caracteres = " << dato1 << endl;
}