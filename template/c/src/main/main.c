#include <stdio.h>
#include "foo.h"
#include "bar.h"
#include "hello.h"
int main(int argc,char ** argv){
	foo();
	bar();
	printf("%s\n",HELLO);
	return 0;
}
