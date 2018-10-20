#ifndef _STRUCT_H_
#define _STRUCT_H_

struct No {
  int token;
  int val;
  char nome[256];

  struct No *esq, *dir, *prox, *lookahead, *lookahead1, *lookahead2;
};

typedef struct No No;

#endif
