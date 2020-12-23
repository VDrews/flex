%option noyywrap

/*----- Sección de declaraciones ----------------*/
%{
#include <iostream>
#include <fstream>
#include <list>
#include <map>

using namespace std;

ifstream fichero;

list<string> colores;
map<string, int> elementos;
map<string, int> elementosIniciales;
int hashtagCount;
int labelCount;

void escribir_datos (int dato1, int dato2);
%}


/*----------------Sección de Reglas----------------*/
%%
\<[a-zA-Z0-9]+ {
  string word(yytext);
  word = word.substr(1, word.length() - 1);

  if (elementosIniciales.find(word) == elementosIniciales.end()) 
  {
    elementosIniciales.insert(pair<string,int>(word,1));
  }
  else 
  {
    auto it = elementosIniciales.find(word); 
    it->second += 1;
  }
}

\<\/[^\>\n]+\> {
  labelCount++;
  string word(yytext);
  word = word.substr(2, word.length() - 3);

  if (elementos.find(word) == elementos.end()) 
  {
    elementos.insert(pair<string,int>(word,1));
  }
  else 
  {
    auto it = elementos.find(word); 
    it->second += 1;
  }
}

(#[0-9a-f]{6}|rgb[\(].*\)) { 
  hashtagCount++; colores.push_back(yytext);
}
%%

/*----- Sección de procedimientos --------*/
int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        fichero.open(argv[1]);
        if (fichero.fail())
        {
            cout << "error de lectura" << endl;
            exit(1);
        }
    }
    else exit(1);
    
    hashtagCount = labelCount = 0;
    yyFlexLexer flujo(&fichero, 0);
    flujo.yylex();
    escribir_datos(hashtagCount, labelCount);

    return 0;
}

void escribir_datos(int dato1, int dato2)
{
    cout << "Num_colores = " << dato1 << endl;
    cout << "Num_etiquetas = " << dato2 << endl;

    cout << "\nCOLORES USADOS\n";
    list<string>::iterator it = colores.begin();
    for (; it != colores.end(); it++)
        cout << *it << endl;

    cout << "\nELEMENTOS USADOS\n";
    map<string, int>::iterator ite = elementos.begin();

    for (; ite != elementos.end(); ite++)
    {
        bool valoresIguales = false;
        if (elementosIniciales.find(ite->first) != elementosIniciales.end())
        {
            valoresIguales = (elementosIniciales.find(ite->first)->second != ite->second);
        }
        string estaCerrado = valoresIguales ? "CERRADO INCORRECTAMENTE" : "CERRADO CORRECTAMENTE";
        cout << ite->first << '\t' << ite->second << '\t' << elementosIniciales.find(ite->first)->second << '\t'
             << estaCerrado << endl;
    }
}