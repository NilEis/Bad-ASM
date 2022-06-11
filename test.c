#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv)
{
	int16_t mem[4096];
	int16_t flag = 0;
	mem[12]=13;
	mem[12]=mem[23];
	mem[13] = 12+mem[13];
	mem[13] = mem[12]+mem[156];
}
