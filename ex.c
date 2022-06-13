#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv)
{
	int16_t mem[4096];
	int16_t flag = 0;
	mem[10]=10;
loop:
	printf("Zelle 10 hat den Wert %d\n",mem[10]);
	mem[10] = mem[10]-1;
	flag=(mem[10]<0)*(-1)+(mem[10]>0)*1;
	if(flag!=0)goto loop;
	printf("%s", "Fertig\n");
}
