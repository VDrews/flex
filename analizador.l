%option noyywrap
/*----- Seccion de Declaraciones ----------------*/
%{
#include <iostream>
#include <fstream>
#include <list>
#include <map>

using namespace std;

ifstream fichero;
int nc, np, nl;
list<string> colores;

map<string, int> elementos;
map<string, int> elementosIniciales;
int hashtagCount;
int labelCount;

void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5);
string barra_carga(int valor, int total);
%}

%%
\<[a-zA-Z0-9]+ {
  string word(yytext);
  word = word.substr(1, word.length() - 1);

  if (elementosIniciales.find(word) == elementosIniciales.end()) {
    elementosIniciales.insert(pair<string,int>(word,1));
  }
  else {
    auto it = elementosIniciales.find(word); 
    it->second += 1;
  }
}
\<\/[^\>\n]+\> {
  labelCount++;
  string word(yytext);
  word = word.substr(2, word.length() - 3);

  if (elementos.find(word) == elementos.end()) {
    elementos.insert(pair<string,int>(word,1));
  }
  else {
    auto it = elementos.find(word); 
    it->second += 1;
  }
}
(#[0-9a-f]{6}|rgb[\(].*\)) { hashtagCount++; colores.push_back(yytext);}
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

cout << "\nCOLORES USADOS\n";
list<string>::iterator it = colores.begin();
for(; it != colores.end(); it++) {
  cout << *it << endl;
}

cout << "\nELEMENTOS USADOS\n";
map<string, int>::iterator ite = elementos.begin();

for(; ite != elementos.end(); ite++) {
  bool valoresIguales = false;
  if (elementosIniciales.find(ite->first) != elementosIniciales.end()) {
    valoresIguales = (elementosIniciales.find(ite->first)->second != ite->second);
  }
  string estaCerrado = valoresIguales ? "CERRADO INCORRECTAMENTE" : "CERRADO CORRECTAMENTE";
  cout << ite->first << '\t' << ite->second << '\t' << elementosIniciales.find(ite->first)->second << '\t' 
       << estaCerrado << '\t' << barra_carga(ite->second, labelCount) << endl;
}

return 0;
}
void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5)
{
cout << "Num_colores = " << dato4 << endl;
cout << "Num_etiquetas = " << dato5 << endl;
}

string barra_carga(int valor, int total) {
  string barra = "";
  float porcentaje = ((valor * 1.0)/(total * 1.0)) * 100;
  for (int i = 0; i < porcentaje / 5; i++)
  {
    barra += "██"; 
  }

  return barra;
}