/* Definicao da Linguagem */

%{
#include<stdio.h>
#include<math.h> 
#include<stdlib.h>
#include<string.h>

//#include "linguagem.h"
//#include "var_aleatorio.h"
//#include "lista_var.h"

#define YYERROR_VERBOSE  /*fornece uma mensagem de erro mais especifica*/ 

/* prototipo */

void yyerror(char *s);
void imprima(struct No *root);

//FILE *entrada, *saida;

struct No *root;
char *var_nome;   

%}

%union{

struct {
  int token;
  double val;
  char nome[256];

  struct No *esq, *dir, *prox, *lookahead, *lookahead1, *lookahead2;
}No;

 struct No *pont;
}

/* Tipos de tokens */
%token <pont> FUNC
%token <pont> IF
%token <pont> PORC
%token <pont> ELSE
%token <pont> NUM

%token <pont> WHILE 
%token <pont> DO
%token <pont> FOR
%token <pont> IDENT

%token <pont> OPEN_BRACE
%token <pont> CLOSE_BRACE
%token <pont> OPEN_BLOCK
%token <pont> CLOSE_BLOCK
%token <pont> COMMA
%token <pont> SEMICOLON
%token <pont> ANYSOURCE

%token <pont> EQ /* == */ 
%token <pont> GQ /* > */
%token <pont> GE /* >=*/
%token <pont> LQ /* < */
%token <pont> LE /* <= */
%token <pont> NE /* != */

%type <pont> programa
%type <pont> lista_comando
%type <pont> bloco
%type <pont> exp
%type <pont> ident
%type <pont> source
%type <pont> funcao
%type <pont> lista_param
%type <pont> atribuicao
%type <pont> comando
%type <pont> comparacao
%type <pont> igualdade
%type <pont> diferenca
%type <pont> maior
%type <pont> maior_igual
%type <pont> menor
%type <pont> menor_igual
%type <pont> if_comando
%type <pont> while_comando
%type <pont> for_comando
%type <pont> variacao

%right '='
%left  '-' '+'
%left  '*' '/'
%left  '%'

/* Declaracao BISON - regras de gramatica */
%%

programa: lista_comando { root = $1; } 
;

lista_comando: comando SEMICOLON { $$ = (struct No*)malloc(sizeof(struct No));
				   $1->prox = 0;
                                   $$ = $1;
                                 }
             | comando SEMICOLON lista_comando { $1->prox = $3;
	                                         $$ = $1;
	                                       }
;


bloco: OPEN_BLOCK lista_comando CLOSE_BLOCK { $$ = $2; } 
;

ident: IDENT        { $$ = (struct No*)malloc(sizeof(struct No));
                      $$->token = IDENT;
		      strcpy($$->nome, yylval.pont->nome);
		      $$->esq = NULL;
		      $$->dir = NULL;
                    }  
;

source: ANYSOURCE {  $$ = (struct No*)malloc(sizeof(struct No));
                     $$->token = ANYSOURCE;
		     $$->esq = NULL;
		     $$->dir = NULL;
                   }
;

atribuicao: ident '=' exp { $$ = (struct No*)malloc(sizeof(struct No));
			    $$->token = '=';
			    $$->esq = $1;
			    $$->dir = $3;
                          }
  ;

exp:   ident

     | funcao

     | NUM          { $$ = (struct No*)malloc(sizeof(struct No));
                      $$->token = NUM;
		      $$->val = yylval.pont->val;
		      $$->esq = NULL;
		      $$->esq = NULL;
                    }
             
     | '-' NUM      { $$ = (struct No*)malloc(sizeof(struct No));
                      $$->token = NUM;
		      $$->val = - yylval.pont->val;
		      $$->esq = NULL;
		      $$->esq = NULL;
                    }
             
     | exp '+' exp  { $$ = (struct No*)malloc(sizeof(struct No));
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
     | exp '%' exp  { $$ = (struct No*)malloc(sizeof(struct No));
                      $$->token = '%';
		      $$->esq = $1;
		      $$->dir = $3;
                    }
     | OPEN_BRACE exp CLOSE_BRACE { $$ = (struct No*)malloc(sizeof(struct No));
                                    $$ = $2;
                                  }
;

lista_param:  exp { $$ = $1; }
           |  exp COMMA lista_param { $$ = (struct No*)malloc(sizeof(struct No));
	                              $$->token = COMMA;
				      $$->esq = $1;
				      $$->dir = $3;
                                    } 
;

funcao: ident OPEN_BRACE lista_param CLOSE_BRACE { $$ = (struct No*)malloc(sizeof(struct No));
                                                   $$->token = FUNC; 
                                                   $$->lookahead = $1;
						   $$->esq = $3;
						   $$->dir = NULL;
                                                 }
;

comando:  atribuicao
        | bloco
        | if_comando
        | while_comando
        | for_comando
;

variacao:  exp COMMA exp { $$ = (struct No*)malloc(sizeof(struct No));
                           $$->token = COMMA;
			   $$->esq = $1;
			   $$->dir = $3;
                         } 
;

comparacao: igualdade
          | diferenca
          | maior
          | maior_igual
          | menor
          | menor_igual
;

igualdade: exp EQ exp     { $$ = (struct No*)malloc(sizeof(struct No));
                            $$->token = EQ;
			    $$->esq = $1;
			    $$->dir = $3;
                          }
;

diferenca: exp NE exp     { $$ = (struct No*)malloc(sizeof(struct No));
                            $$->token = NE;
			    $$->esq = $1;
			    $$->dir = $3;
                          }
;

maior: exp GQ exp         { $$ = (struct No*)malloc(sizeof(struct No));
                            $$->token = GQ;
			    $$->esq = $1;
			    $$->dir = $3;
                          }
;

maior_igual: exp GE exp   { $$ = (struct No*)malloc(sizeof(struct No));
                            $$->token = GE;
			    $$->esq = $1;
			    $$->dir = $3;
                          }
;
menor: exp LQ exp         { $$ = (struct No*)malloc(sizeof(struct No));
                            $$->token = LQ;
			    $$->esq = $1;
			    $$->dir = $3;
                          }
;

menor_igual: exp LE exp   { $$ = (struct No*)malloc(sizeof(struct No));
                            $$->token = LE;
			    $$->esq = $1;
			    $$->dir = $3;
                          }
;

if_comando:  IF OPEN_BRACE comparacao CLOSE_BRACE bloco
                { $$ = (struct No*)malloc(sizeof(struct No));
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = NULL;
                }
           | IF OPEN_BRACE comparacao CLOSE_BRACE bloco ELSE bloco
                { $$ = (struct No*)malloc(sizeof(struct No));
		  $$->token = IF;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = $7;
                }
           | IF OPEN_BRACE exp CLOSE_BRACE bloco 
                { $$ = (struct No*)malloc(sizeof(struct No));
		  $$->token = PORC;
		  $$->lookahead = $3;
		  $$->esq = $5;
		  $$->dir = NULL;
                }
           | IF OPEN_BRACE exp CLOSE_BRACE bloco ELSE bloco
                    { $$ = (struct No*)malloc(sizeof(struct No));
		      $$->token = PORC;
		      $$->lookahead = $3;
		      $$->esq = $5;
		      $$->dir = $7;
		    }
;

while_comando: WHILE OPEN_BRACE variacao CLOSE_BRACE bloco
                     { $$ = (struct No*)malloc(sizeof(struct No));
		       $$->token = WHILE;
		       $$->lookahead = $3;
		       $$->esq = $5;
		       $$->dir = NULL;
                     }  
              | WHILE OPEN_BRACE comparacao CLOSE_BRACE bloco
                     { $$ = (struct No*)malloc(sizeof(struct No));
		       $$->token = DO;
		       $$->lookahead = $3;
		       $$->esq = $5;
		       $$->dir = NULL;
                     }
;

for_comando: FOR OPEN_BRACE ident COMMA exp CLOSE_BRACE bloco
                 { $$ = (struct No*)malloc(sizeof(struct No));
		   $$->token = FOR;
		   $$->lookahead = $3;
		   $$->lookahead1 = $5;
		   $$->esq = $7;
		   $$->dir = NULL;
		 }
;

%%

void yyerror(char *s) {
  printf("%s\n", s);
}

void imprima(struct No *root){

  if (root != NULL){
    switch(root->token){
    case NUM:
      fprintf(saida,"%g", root->val);
      break;

    case IDENT:
      fprintf(saida,"%s", root->nome);
      break;

    case '=':
      if (insere_var(root->esq->nome) == 0){
	fprintf(saida,"double ");
      }
      imprima(root->esq);
      fprintf(saida,"=");
      imprima(root->dir);
      fprintf(saida,";\n");
      break;
      
    case '+':
      imprima(root->esq);
      fprintf(saida,"+");
      imprima(root->dir);
      break;

    case '-':
      imprima(root->esq);
      fprintf(saida,"-");
      imprima(root->dir);
      break;

    case '*':
      imprima(root->esq);
      fprintf(saida,"*");
      imprima(root->dir);
      break;
      
    case '/':
      imprima(root->esq);
      fprintf(saida,"/");
      imprima(root->dir);
      break;

    case '%':
      fprintf(saida,"int(");
      imprima(root->esq);
      fprintf(saida,")");
      fprintf(saida,"%%");
      fprintf(saida,"int(");
      imprima(root->dir);
      fprintf(saida,")");
      break;

    case COMMA:
      imprima(root->esq);
      fprintf(saida,",");
      imprima(root->dir);
      break;

    case EQ:
      imprima(root->esq);
      fprintf(saida,"==");
      imprima(root->dir);
      break;

    case NE:
      imprima(root->esq);
      fprintf(saida,"!=");
      imprima(root->dir);
      break;

    case GQ:
      imprima(root->esq);
      fprintf(saida,">");
      imprima(root->dir);
      break;

    case LQ:
      imprima(root->esq);
      fprintf(saida,"<");
      imprima(root->dir);
      break;

    case GE:
      imprima(root->esq);
      fprintf(saida,">=");
      imprima(root->dir);
      break;

    case LE:
      imprima(root->esq);
      fprintf(saida,"<=");
      imprima(root->dir);
      break;

    case FUNC:
      imprima(root->lookahead);
      fprintf(saida,"(");
      imprima(root->esq);
      fprintf(saida,")");
      break;
      
    case IF:
      fprintf(saida," \nif ");
      fprintf(saida,"(");
      imprima(root->lookahead);
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(root->esq);
      fprintf(saida," }");
      
      if(root->dir != NULL){
	fprintf(saida,"\n else");
	fprintf(saida," {\n");
	imprima(root->dir);
	fprintf(saida," }\n");
      }
      else fprintf(saida,"\n");
      break;
      
    case PORC:
      fprintf(saida," if (rank == 0){");
      var_nome = nome();
      fprintf(saida,"\n double %s= ", var_nome);
      fprintf(saida,"Sort(");
      imprima(root->lookahead);
      fprintf(saida,");\n");
      fprintf(saida,"}");
      fprintf(saida," MPI_Bcast(&%s, 1, MPI_DOUBLE, 0, simCom);", var_nome);
      fprintf(saida," if");
      fprintf(saida,"(");
      fprintf(saida,"%s",var_nome);
      fprintf(saida,"< (f/100)");
      fprintf(saida,")");
      fprintf(saida,"{\n");
      imprima(root->esq);
      fprintf(saida,"\n}\n");
      
      if (root->dir != NULL){
	fprintf(saida,"\n else");
	fprintf(saida," {\n");
	imprima(root->dir);
	fprintf(saida," }\n");	
      }
      else fprintf(saida,"}\n");
      break;

    case WHILE:
      fprintf(saida," if (rank == 0){");
      var_nome = nome();
      fprintf(saida,"\ndouble %s = ", var_nome);
      fprintf(saida,"Var(");
      imprima(root->lookahead);
      fprintf(saida,");\n");
      fprintf(saida," MPI_Bcast(&%s, 1, MPI_DOUBLE, 0, simCom);\n\n", var_nome);
      fprintf(saida," while ");
      fprintf(saida,"(");
      fprintf(saida,"%s > 0", var_nome);
      fprintf(saida,")");
      fprintf(saida," {\n ");
      imprima(root->esq);
      fprintf(saida," %s--;", var_nome);
      fprintf(saida,"\n }\n");
      fprintf(saida,"\n }\n");
      break;

    case DO:
      fprintf(saida,"while");
      fprintf(saida,"(");
      imprima(root->lookahead);
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(root->esq);
      fprintf(saida,"\n }\n");
      break;
      
    case FOR:
      fprintf(saida," \n for");
      fprintf(saida,"(int ");
      imprima(root->lookahead);
      fprintf(saida,"=0");
      fprintf(saida,"; ");
      imprima(root->lookahead);
      fprintf(saida,"<");
      fprintf(saida,"(");
      imprima(root->lookahead1);
      fprintf(saida,")");
      fprintf(saida,"; ");
      imprima(root->lookahead);
      fprintf(saida,"++");
      fprintf(saida,")");
      fprintf(saida," {\n");
      imprima(root->esq);
      fprintf(saida,"\n } \n");
      break;

     default: 
      fprintf(saida,"Desconhecido ! Token = %d (%c) \n", root->token, root->token);
    }
    if (root->prox != NULL) {
      imprima(root->prox);
    }
  }
}

int main(int argc, char *argv[]){
  
  char buffer[256];

  extern FILE *yyin;

  yylval.pont = (struct No*)malloc(sizeof(struct No));

  if (argc < 2){
    printf("Ops! Voce fez alguma coisa errada!\n");
    exit(1);
  }
  
  entrada = fopen(argv[1],"r");
  if(!entrada){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyin = entrada;

  strcpy(buffer,argv[1]);
  strcat(buffer,".cc");
  
  saida = fopen(buffer,"w");
  if(!saida){
    printf("Erro! O arquivo nao pode ser aberto! \n");
    exit(1);
  }

  yyparse();

  fprintf(saida,"#include<iostream.h>\n");
  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");
  fprintf(saida,"#include<mpi.h>\n\n");
  fprintf(saida,"#include \"biblioteca.h\"\n");
  fprintf(saida,"\nvoid processador(int rank){\n");
  cria_lista();
  imprima(root);
  fprintf(saida,"\n}\n");

  fclose(entrada);
  fclose(saida);
}
