/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/alt_timestamp.h>

#define MATRIX_SIZE 100

int main()
{
	int a[MATRIX_SIZE][MATRIX_SIZE], b[MATRIX_SIZE][MATRIX_SIZE], c[MATRIX_SIZE][MATRIX_SIZE];
	short i, j, k, sum;
	unsigned long long start_time, end_time;

	printf("Generating matrices\n");
	// Generate random matrices
	for(i = 0; i < MATRIX_SIZE; i++) {
		for(j = 0; j < MATRIX_SIZE; j++) {
			a[i][j] = 1;//rand();
			b[i][j] = 1;//rand();
			c[i][j] = 1;//rand();
		}
	}

	// Timer exercises
	printf("Start timer\n");
	alt_timestamp_start();
	start_time = (unsigned long long) alt_timestamp();

	for(i = 0; i < MATRIX_SIZE; i++) {
		for(j = 0; j < MATRIX_SIZE; j++) {
			sum = 0;
			for(k = 0; k < MATRIX_SIZE; k++) {
				sum = sum + a[i][k] * b[k][j];
			}
			c[i][j] = sum;
		}
	}

	end_time = (unsigned long long) alt_timestamp();
	printf("Start: %llu\n", start_time);
	printf("End: %llu\n", end_time);

	printf("Time taken: %llu clock ticks\n", end_time - start_time);
	printf("			%f seconds\n", (float) (end_time - start_time) / (float) alt_timestamp_freq());

	return 0;
}
