%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "upa.tab.h"
#include "struct.h"

// #define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)

//extern "C" int yywrap(){};
//extern "C" int yylex();
%}

%%
"se"         { return SE; } 

"senao"       { return SENAO; } 

"enquanto"      { return ENQUANTO; } 

"para"        { return PARA; }

"principal" { printf("#include <iostream>\n#include <math.h>\n#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n\nint main() {\n"); return PRINCIPAL; }

"inteiro"	{ return INTEIRO; }

"fimprincipal" { return FIMPRINCIPAL;}

"imprima_int"	{return IMPRIMA_INT; }

[-+]?[0-9]+("."[0-9]*)?([eE]"-"?[0-9]*)? { yylval.pont->val = atof(yytext);
                                           return NUM;
                                         }
[a-zA-Z][a-zA-z0-9]* { strncpy(yylval.pont->nome, yytext, 256);
                       return VAR;
                     }

"=="   { return IGUAL; }
"!="   { return DIFERENTE; }
">"    { return MAIORQUE; }
">="   { return MAIORIGUAL; }
"<"    { return MENORQUE; }
"<="   { return MENORIGUAL; }
"("    { return ABRE_PAR; }
")"    { return FECHA_PAR; }
"{"    { return ABRE_CHAV; }
"}"    { return FECHA_CHAV; }
";"    { return PONTOEVIRGULA; }



[ \t\n]  /* Ignora */
.      { return *yytext; }

%% 
int yywrap(void){
  return 0; 
}  
