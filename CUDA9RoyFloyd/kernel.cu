#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

#define N 4

__global__ void RoyFloyd(int a[N][N], int k) {
	int i = threadIdx.x;
	int j = threadIdx.y;

	if (a[i][j] > a[i][k] + a[k][j])
	{
		a[i][j] = a[i][k] + a[k][j];
	}

}

int main(int argc, char **argv) {

	int numBlocks = 1;
	dim3 threadsPerBlock(N, N);
	int size = N*N;

	int a[N][N] = {
		{ 0, 5, 3, 10 },
		{ 6, 0, 3, 4 },
		{ 3, 3, 0, 1 },
		{ 10, 4, 1, 0 }
	};


	int *a_cuda;
	cudaMalloc(&a_cuda, size);

	cudaMemcpy(a_cuda, a, size, cudaMemcpyHostToDevice);

	for (int k = 0; k < N; k++)
	{
		RoyFloyd <<< numBlocks, threadsPerBlock >>> (a_cuda, k);
	}


	cudaMemcpy(a, a_cuda, size, cudaMemcpyDeviceToHost);
	cudaFree(a_cuda);
	return 0;
}