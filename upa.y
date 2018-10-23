%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>
#include "struct.h"

void yyerror (char const *s);
void executa( No *raiz );

int sym[26];
char nVarTxtLeia='0';
char nVarTxtImprime='0';
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
%token TEXTO

%token <pont> SE
%token <pont> SENAO
%token <pont> ENQUANTO
%token <pont> PARA
%token <pont> LEIA

%token PRINCIPAL
%token <pont> IMPRIMA_INT
%token <pont> IMPRIMA_MSG

%token IGUAL
%token DIFERENTE
%token MAIORQUE
%token MAIORIGUAL
%token MENORQUE
%token MENORIGUAL
%token ABRE_PAR
%token FECHA_PAR
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
%type <pont> menor_igual
%type <pont> maior
%type <pont> maior_igual
%type <pont> para_comando
%type <pont> imprima_int
%type <pont> imprima_msg
%type <pont> comparacao
%type <pont> se_comando
%type <pont> leia_int

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
		| comparacao
		| para_comando
		| identificador
		| imprima_int
		| imprima_msg
		| se_comando
		| leia_int
		;

comparacao	: maior
		| menor  
		| maior_igual
		| menor_igual
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

		| identificador '=' exp { $$ = (No*)malloc(sizeof(No)); 
					  $$->token = '!'; 
					  $$->esq = $1;
					  $$->dir = $3; }
		
		| INTEIRO identificador {   $$ = (No*)malloc(sizeof(No)); 
					    $$->token = '|'; 
					    $$->esq = $2;
					    $$->dir = NULL; 
					}

		| TEXTO identificador  {    $$ = (No*)malloc(sizeof(No)); 
					    $$->token = '@'; 
					    $$->esq = $2;
					    $$->dir = NULL; 
					}
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

		| exp '-' exp  { $$ = (struct No*)malloc(sizeof(struct No));
                      		 $$->token = '-';
		      		 $$->esq = $1;
		      		 $$->dir = $3;
                    		}

     		| exp '*' exp  { $$ = (struct No*)malloc(sizeof(struct No));
				 $$->token = '*';
				 $$->esq = $1;
				 $$->dir = $3;
				}   

		| exp '/' exp  { $$ = (struct No*)malloc(sizeof(struct No));
				 $$->token = '/';
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

menor_igual	: exp MENORIGUAL exp { $$ = (struct No*)malloc(sizeof(struct No));
                            	       $$->token = MENORIGUAL;
				       $$->esq = $1;
				       $$->dir = $3; 
			             }
		;

maior		: exp MAIORQUE exp { $$ = (struct No*)malloc(sizeof(struct No));
                            	     $$->token = MAIORQUE;
				     $$->esq = $1;
				     $$->dir = $3; 
			           }
		;

maior_igual	: exp MAIORIGUAL exp { $$ = (struct No*)malloc(sizeof(struct No));
                            	       $$->token = MAIORIGUAL;
				       $$->esq = $1;
				       $$->dir = $3; 
			             }
		;


para_comando	: PARA ABRE_PAR comando PONTOEVIRGULA comando PONTOEVIRGULA identificador FECHA_PAR comando
                 	{ $$ = (struct No*)malloc(sizeof(struct No));
			  $$->token = PARA;
			  $$->lookahead = $3;
			  $$->lookahead1 = $5;
			  $$->lookahead2 = $7;
			  $$->esq = $9;
			  $$->dir = NULL; 
		 	} 
		;

se_comando	: SE ABRE_PAR comando FECHA_PAR comando{ $$ = (struct No*)malloc(sizeof(struct No));
 						    $$->token = SE;
						    $$->lookahead = $3;
						    $$->esq = $5;
						    $$->dir = NULL;
						  }
		;

imprima_int	: IMPRIMA_INT ABRE_PAR identificador FECHA_PAR { $$ = (struct No*)malloc(sizeof(struct No));
 					      			 $$->token = IMPRIMA_INT;
							         $$->esq = $3;
							         $$->dir = NULL;
					                       }
		;

imprima_msg	: IMPRIMA_MSG ABRE_PAR identificador FECHA_PAR { $$ = (struct No*)malloc(sizeof(struct No));
 					      			 $$->token = IMPRIMA_MSG;
							         $$->esq = $3;
							         $$->dir = NULL;
					                       }
		;

leia_int	: LEIA ABRE_PAR exp FECHA_PAR { $$ = (struct No*)malloc(sizeof(struct No));
 					      		  $$->token = LEIA;
							  $$->esq = $3;
							  $$->dir = NULL;
					                }		

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
			
			case '|':
			      printf("int ");
			      executa(raiz->esq);
			      printf(";\n");
			      break;

			case '=':
			      printf("int ");
			      executa(raiz->esq);
			      printf(" = ");
			      executa(raiz->dir);
			      printf(";\n");
			      break;

			case '!':
			      executa(raiz->esq);
			      printf(" = ");
			      executa(raiz->dir);
			      printf(";\n");
			      break; 

			case '@':			       	
			      printf("char* txt%c= \"", nVarTxtLeia++);	
			      executa(raiz->esq);
			      printf("\"");	
			      printf(";\n");
			      break; 
				 
			case '+': 
			      executa(raiz->esq);
	      		      printf(" + ");
	      	              executa(raiz->dir);
			      break;

			case '-': 
			      executa(raiz->esq);
	      		      printf(" - ");
	      	              executa(raiz->dir);
			      break;

			case '*': 
			      executa(raiz->esq);
	      		      printf(" * ");
	      	              executa(raiz->dir);
			      break;
			
			case '/': 
			      executa(raiz->esq);
	      		      printf(" / ");
	      	              executa(raiz->dir);
			      break;
			
			case MENORQUE:
			      executa(raiz->esq);
			      printf(" < ");
			      executa(raiz->dir);
			      break;

			case MENORIGUAL:
			      executa(raiz->esq);
			      printf(" <= ");
			      executa(raiz->dir);
			      break;

			case MAIORQUE:
			      executa(raiz->esq);
			      printf(" > ");
			      executa(raiz->dir);
			      break;

			case MAIORIGUAL:
			      executa(raiz->esq);
			      printf(" >= ");
			      executa(raiz->dir);
			      break;

			case PARA:
			      printf("\nfor (");
			      executa(raiz->lookahead);
			      executa(raiz->lookahead1);
			      printf(";");
			      executa(raiz->lookahead2);
			      printf("++");
			      printf(")");
			      printf(" {\n");
			      executa(raiz->esq);
			      
			      if(raiz->dir != NULL){
			      	executa(raiz->dir);
			      }

			      printf("} \n");
			      break;
			
			case IMPRIMA_MSG:
			      printf("printf(\"%%s\\n\", txt%c);\n\n", nVarTxtImprime++);
			      break;

			case IMPRIMA_INT:
			      printf("printf(\"%%d\\n\", ");
			      executa(raiz->esq);
			      printf(");\n");
			      break;

			case SE:
			      printf("\nif ");
			      printf("(");
			      executa(raiz->lookahead);
			      printf(")");
			      printf(" {\n");
			      executa(raiz->esq);
			      printf(" }\n\n");
			      break;
	
			case LEIA:
			      printf("scanf(\"%%d\", &");
			      executa(raiz->esq);
			      printf(");\n");
			      break;
			
			case FIMPRINCIPAL:
			     printf("final\n");
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

