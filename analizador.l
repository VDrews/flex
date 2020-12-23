%option noyywrap
/*----- Seccion de Declaraciones ----------------*/
%{
#include <iostream>
#include <fstream>

using namespace std;

ifstream fichero;
int nc, np, nl;
int hashtagCount;
int labelCount;

void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5);
%}

%%
#[0-9a-f]{6} { hashtagCount++; cout << yytext << endl;}
[rgb\(].*\) { hashtagCount++;}

%%

/*----- Seccion de Procedimientos --------*/
int main (int argc, char *argv[])
{
if (argc == 2)
{
fichero.open (argv[1]);
if (fichero==0)
{
cout << "error de lectura" << endl;
exit (1);
}
}
else exit(1);
nc = np = nl = hashtagCount = labelCount = 0;
yyFlexLexer flujo (&fichero,0);
flujo.yylex();
escribir_datos(nc,np,nl,hashtagCount, labelCount);
return 0;
}
void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5)
{
cout << "Num_lineas = " << dato3 << endl;
cout << "Num_palabras = " << dato2 << endl;
cout << "Num_caracteres = " << dato1 << endl;
cout << "Num_colores = " << dato4 << endl;
cout << "Num_etiquetas = " << dato5 << endl;
}