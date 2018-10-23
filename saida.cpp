#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
int num;
int fatorial = 1;
char* txt0= "==FATORIAL==";
printf("%s\n", txt0);

char* txt1= "Numero:";
printf("%s\n", txt1);

scanf("%d", &num);

for (int aux = 1;
aux <= num;aux++) {
fatorial = fatorial * aux;
} 
char* txt2= "Fatorial:";
printf("%s\n", txt2);

printf("%d\n", fatorial);

return 0;
}
