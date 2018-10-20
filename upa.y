%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>
#include "struct.h"

void yyerror (char const *s);
void executa( No *raiz );

int sym[26];

struct No *raiz;
FILE *entrada;

%}

%union{
struct {
  int token;
  int val;
  char nome[256];

  struct No *esq, *dir, *prox, *lookahead, *lookahead1, *lookahead2;
}No;

 struct No *pont;

 int token;
}

/* Tipos de tokens */

%token <pont> NUM
%token <pont> VAR
%token <pont> IDENT
%token <token> MAIS
%token INTEIRO

%token <pont> SE
%token <pont> SENAO
%token <pont> ENQUANTO
%token <pont> PARA

%token <pont> ANYSOURCE
%token PRINCIPAL
%token <pont> IMPRIMA_INT

%token <pont> IGUAL
%token <pont> DIFERENTE
%token <pont> MAIORQUE
%token <pont> MAIORIGUAL
%token <pont> MENORQUE
%token <pont> MENORIGUAL
%token <pont> ABRE_PAR
%token <pont> FECHA_PAR
%token ABRE_CHAV
%token FECHA_CHAV
%token PONTOEVIRGULA
%token FIMPRINCIPAL


%type <pont> programa
%type <pont> linha
%type <pont> comando
%type <pont> identificador
%type <pont> atribuicao
%type <pont> exp
%type <pont> menor
%type <pont> for_comando
%type <pont> imprima_int

%right '='
%left  '-' '+'
%left  '*' '/'
%left  '%'

%%

programa	: PRINCIPAL linha { raiz = $2;}
		;


linha		: comando PONTOEVIRGULA { $$ = (struct No*)malloc(sizeof(struct No));
				   	  $1->prox = NULL;
                                   	  $$ = $1;
	                                }
		| comando PONTOEVIRGULA linha { $$ = (struct No*)malloc(sizeof(struct No));
				   	  	$1->prox = $3;
                                   	  	$$ = $1;
	                               	      }
		;

comando		: atribuicao
		| menor
		| for_comando
		| identificador
		| imprima_int
		;

identificador	: VAR { $$ = (No*)malloc(sizeof(No));
				$$->token = VAR;
				strcpy($$->nome, yylval.pont->nome);
				$$->esq = NULL;
			        $$->dir = NULL;			
				}   
		;


atribuicao	: INTEIRO identificador '=' exp { $$ = (No*)malloc(sizeof(No)); 
					  	  $$->token = '='; 
					  	  $$->esq = $2;
					  	  $$->dir = $4; }
		;

exp		: NUM { $$ = (No*)malloc(sizeof(No));
                      	$$->token = NUM;
		      	$$->val = yylval.pont->val;
		      	$$->esq = NULL;
		      	$$->esq = NULL; 
                    } 

		| exp '+' exp { $$ = (No*)malloc(sizeof(No));
			         $$->token = '+';
			         $$->esq = $1;
			         $$->dir = $3;
			       }

		| identificador
		;

menor		: exp MENORQUE exp { $$ = (struct No*)malloc(sizeof(struct No));
                            	     $$->token = MENORQUE;
				     $$->esq = $1;
				     $$->dir = $3; 
			           }
		;


for_comando	: PARA ABRE_PAR comando PONTOEVIRGULA comando PONTOEVIRGULA identificador FECHA_PAR comando
                 	{ $$ = (struct No*)malloc(sizeof(struct No));
			  $$->token = PARA;
			  $$->lookahead = $3;
			  $$->lookahead1 = $5;
			  $$->lookahead2 = $7;
			  $$->esq = $9;
			  $$->dir = NULL; 
		 	} 
		;

imprima_int	: IMPRIMA_INT identificador { $$ = (struct No*)malloc(sizeof(struct No));
					      $$->token = IMPRIMA_INT;
					      $$->esq = $2;
					      $$->dir = NULL;
					    }
;


%%

void yyerror (char const *s) {
	printf("Error: %s\n", s);
}

void executa (struct No* raiz) {
	if (raiz->token != 0){
    		switch(raiz->token){
			case NUM:
			      printf("%d", raiz->val);
			      break;
			
			case VAR:
			      printf("%s", raiz->nome);
			      break;

			case '=':
			      printf("int ");
			      executa(raiz->esq);
			      printf(" = ");
			      executa(raiz->dir);
			      printf(";\n");
			      break; 

			case '+': 
			      executa(raiz->esq);
	      		      printf(" + ");
	      	              executa(raiz->dir);
			      break;
			
			case MENORQUE:
			      executa(raiz->esq);
			      printf(" < ");
			      executa(raiz->dir);
			      printf(";");
			      break;

			case PARA:
			      printf("\nfor (");
			      executa(raiz->lookahead);
			      executa(raiz->lookahead1);
			      executa(raiz->lookahead2);
			      printf("++");
			      printf(")");
			      printf(" {\n");
			      executa(raiz->esq);
			      printf("\n} \n");
			      break;
			
			case IMPRIMA_INT:
			      printf("printf(\"%%d\", ");
			      executa(raiz->esq);
			      printf(");");
			      break;
			
			case FIMPRINCIPAL:
			     printf("fim");
			     break;
		}
	}
	else
	 printf("Raiz vazia\n");

	if (raiz->prox != NULL) {
	      executa(raiz->prox);
    	}

}

int main (int argc, char *argv[]) {	
	yylval.pont = (No*)malloc(sizeof(No));
	yyparse();	
	executa(raiz);
}

