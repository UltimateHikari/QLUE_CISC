#include <stdio.h>
#include <stdlib.h>

int main(){
	int n = 8; // 10bit
	int cat[8];
	cat[0] = 1;
						printf("%d ", cat[0]);
	for(int i = 1; i < 8; i++){
						cat[i] = 0;
		for(int k = 0; k < i; k++){
			cat[i] += cat[k]*cat[i-1-k];
		}
						printf("%d ", cat[i]);
	}

	return 0;
}
