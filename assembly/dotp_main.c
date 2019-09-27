#define N 6

int dotp_func_v1(short* x, short* y,int count);
int dotp_func_v2(short* x, short* y,int count);
int dotp_func_test(short* x, short* y,int count);
/*
int dotp_func(short* x, short* y,int count){
	int sum=0;
	int i=0;

	for (i=0; i<N; i++){
		sum +=x[i]*y[i];
	}

	for (i=0; i<N; i++){
		x[i]=x[i+1];
	}

	return sum;
}
*/

short x[N]={1,2,3,4,5,0};
short y[N]={2,4,6,8,10,12};
main() {
	int s=0;
	int e=6;
	while (1) {
		x[N-1]=e;
		s=dotp_func_v2(x,y,N);
		e++;
	}
}
