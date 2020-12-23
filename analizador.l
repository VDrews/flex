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

//Variables para mostrar información
list<string> colores;                 //Lista de colores
map<string, int> elementos;           //Map con etiquetas (labels) y frecuencia. Se usan los finales (</..>)
map<string, int> elementosIniciales;  //Ídem, con los iniciales (<..>)
int hashtagCount;                     //Contador de colores (rgb(), #hex)
int labelCount;                       //Contador de etiquetas

//Función de escritura de datos
//Parámetros: hashtagCount, labelCount
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
    //Apertura de fichero
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
    
    //Inicialización de variables
    hashtagCount = labelCount = 0;
    yyFlexLexer flujo(&fichero, 0);
    flujo.yylex();
    escribir_datos(hashtagCount, labelCount);

    return 0;
}

//Implementación de la función de escritura.

void escribir_datos(int dato1, int dato2)
{
    //Muestra el nr. de colores y etiquetas basándose en la 2. y 3. reglas
    cout << "Num_colores = " << dato1 << endl;
    cout << "Num_etiquetas = " << dato2 << endl;

    //Itera sobre la lista de colores
    cout << "\nCOLORES USADOS\n";
    list<string>::iterator it = colores.begin();
    for (; it != colores.end(); it++)
        cout << *it << endl;

    //Itera sobre la lista de elementos (finales) y compara con la lista de elementos iniciales. Muestra en pantalla el nombre de etiqueta y su número de finales e iniciales
    //Si no coincideran, la sentencia HTML no está cerrada, muestra "ABIERTO"
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
             << estaCerrado << endl;
    }
}