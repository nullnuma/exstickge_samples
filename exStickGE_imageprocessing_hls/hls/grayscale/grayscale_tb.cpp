#include <iostream>

#include "grayscale.h"

int grayscale_expected(int r, int g, int b){
    return (r * 77 + g * 150 + b * 28);
}

int main(int argc, char **argv){
	int r[WIDTH];
	int g[WIDTH];
	int b[WIDTH];
	int gray[WIDTH];

	for(int i = 0; i < WIDTH; i++){
		r[i] = i;
		g[i] = i;
		b[i] = i;
	}

	grayscale(r, g, b, gray);

	for(int i = 0; i < WIDTH; i++){
		int expected = grayscale_expected(r[i], g[i], b[i]);
		if(expected != gray[i]){
			std::cout << r[i] << "," << g[i] << "," << b[i] << ": expected = " << expected << ", actual = " << gray[i] << std::endl;
			return -1;
		}
	}

	grayscale(r, g, b, gray);

	for(int i = 0; i < WIDTH; i++){
		int expected = grayscale_expected(r[i], g[i], b[i]);
		if(expected != gray[i]){
			std::cout << r[i] << "," << g[i] << "," << b[i] << ": expected = " << expected << ", actual = " << gray[i] << std::endl;
			return -1;
		}
	}

	return 0;
}
