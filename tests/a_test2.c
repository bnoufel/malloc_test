#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main()
{
	char *str, *ptr;
	if (!(str = malloc(10)))
		return 0;
	printf("Malloc OK\n");
	if (!(ptr = realloc("wiwiwiwi", 12)))
		return 0;
	printf("Realloc OK\n");
}