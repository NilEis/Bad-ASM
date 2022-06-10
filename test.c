#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
	int16_t mem[4096];
	int16_t flag = 0;

	printf("%s", "Hallo\n");
	printf("%s", "\tHallo\n");
	printf("INT: %d\n",15);
	printf("INT: %d\n",'2');
l:
label:
l_abel:
	printf("152: %d\n",mem[152]);
	mem[153]=123;
	mem[152] = mem[153]+123;
	printf("153: %d\n",mem[153]);
	printf("152: %d\n",mem[152]);
	goto l;
	if(flag==0)goto label;
}
