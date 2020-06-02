
#include "grayscale.h"

void grayscale(int r[WIDTH], int g[WIDTH], int b[WIDTH], int sink[WIDTH]){
#pragma HLS INTERFACE ap_fifo port=r
#pragma HLS INTERFACE ap_fifo port=g
#pragma HLS INTERFACE ap_fifo port=b
#pragma HLS INTERFACE ap_fifo port=sink
#pragma HLS DATAFLOW

	for(int i = 0; i < WIDTH; i++){
#pragma HLS PIPELINE
        int gray = r[i] * 77 + g[i] * 150 + b[i] * 28;
		sink[i] = gray;
	}

}
