#include <stdio.h>

__global__ void printHello() {
	printf("The Device says \"Hello World\"\n");
}

int main()
{
	
	printHello<<<1,1>>>();
	
	return 0;
}