#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 100
#define GRID_SIZE 100
#define N GRID_SIZE * BLOCK_SIZE

__global__ void VectorAdd (int *A, int *B, int *C) {
	int x = threadIdx.x + blockIdx.x * blockDim.x;
	C[x] = A[x] + B[x];
}

int main () {
	int *hA, *hB, *hC;
	int *dA, *dB, *dC;
	int size = N * sizeof(int);
	int i;
	printf ("%d", size);
	// STEP 1 : Allocate memory for Host and Device variables
	hA = (int *) malloc(size);
	hB = (int *) malloc(size);
	hC = (int *) malloc(size);
	
	cudaMalloc((void **)&dA, size);
	cudaMalloc((void **)&dB, size);
	cudaMalloc((void **)&dC, size);

	for (i = 0; i < N ; i++) {
		hA[i] = i;
		hB[i] = 2*i;
	}

	printf("\n Arrays to be added are:\n");
	printf("Array A:\n");
	for (i = 0; i < N ; i++) {
		printf("%d ", hA[i]);
	}

	printf("\nArray B:\n");
	for (i = 0; i < N ; i++) {
		printf("%d ", hB[i]);
	}

	// STEP 2: Copy data from Host to Device
	cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);

	// STEP 3: Kernel Launch
	VectorAdd<<<GRID_SIZE, BLOCK_SIZE>>> (dA, dB, dC);

	// STEP 4: Copy results back to Host
	cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);

	// STEP 5 : Print the result
	printf("\n\nVector Addition is:\n");
	for (i = 0; i < N ; i++) {
		printf("%d ", hC[i]);
	}
	return 0;
}
