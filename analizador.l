%option noyywrap

/*----- Sección de declaraciones ----------------*/
%{
#include <iostream>
#include <fstream>
#include <list>
#include <map>

using namespace std;

//Apertura de los ficheros .html
ifstream fichero;

//Declaración de variables
list<string> colores;                 //Lista de colores (#hex o rgb(..,..,..))
map<string, int> elementos;           //Map de etiquetas (finales: </..>), con frecuencia
map<string, int> elementosIniciales;  //Ídem con etiquetas iniciales (<..>)
int hashtagCount;                     //Contador de colores
int labelCount;                       //Contador de etiquetas

//Declaración de la función de escritura de datos
//Parámetros: hashtagCount labelCount
void escribir_datos (int dato1, int dato2);

//Declaración de la barra de carga
string barra_carga(int valor, int total);
%}


/*----- Sección de reglas ----------------*/
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
(#[0-9a-f]{6}|rgb[\(].*\)) { 
    hashtagCount++; colores.push_back(yytext);
}
%%


/*----- Sección de procedimientos --------*/
int main(int argc, char *argv[])
{
  //Llamada al fichero
  if (argc == 2)
  {
    fichero.open(argv[1]);
    if (fichero.fail())
    {
      cout << "error de lectura" << endl;
      exit(1);
    }
  }
  else
    exit(1);
  
  //Inicialización de parámetros
  hashtagCount = labelCount = 0;
  yyFlexLexer flujo(&fichero, 0);
  flujo.yylex();
  escribir_datos(nc, np, nl, hashtagCount, labelCount);

  return 0;
}

//Implementación de escribir datos
void escribir_datos (int dato1, int dato2)
{
  cout << "Num_colores = " << dato1 << endl;
  cout << "Num_etiquetas = " << dato2 << endl;

  //Itera la lista de colores
  cout << "\nCOLORES USADOS\n";
  list<string>::iterator it = colores.begin();
  for (; it != colores.end(); it++)
    cout << *it << endl;

  //Itera la lista de elementos y compara las ocurrencias de etiquetas finales e iniciales
  //Si difieren, muestra en pantalla "ABIERTO"
  cout << "\nELEMENTOS USADOS\n";
  map<string, int>::iterator ite = elementos.begin();

  for (; ite != elementos.end(); ite++)
  {
    bool valoresIguales = false;
    if (elementosIniciales.find(ite->first) != elementosIniciales.end())
    {
      valoresIguales = (elementosIniciales.find(ite->first)->second != ite->second);
    }
    string estaCerrado = valoresIguales ? "ABIERTO" : "cerrado";
    cout << ite->first << '\t' << ite->second << '\t' << elementosIniciales.find(ite->first)->second << '\t'
          << estaCerrado << '\t' << barra_carga(ite->second, labelCount) << endl;
  }
}

//Implementación de la barra de carga
string barra_carga(int valor, int total) {
  string barra = "";
  float porcentaje = ((valor * 1.0)/(total * 1.0)) * 100;
  for (int i = 0; i < porcentaje / 5; i++)
    barra += "██";
  
  return barra;
}