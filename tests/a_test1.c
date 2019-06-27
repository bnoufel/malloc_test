#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main()
{
	char *str, *ptr;
	if (!(str = malloc(10)))
		return 0;
	printf("Malloc OK\n");
	if (!(ptr = realloc(str, 2)))
		return 0;
	printf("Realloc OK\n");
}