#include <stdlib.h>
#include <stdio.h>
int main(void)
{
	void *ptr = malloc(2);

	if ((int)ptr % 16 == 0) {
		printf("%d", 1);
		return 1;
	}
	printf("%d", 0);
	return 0;
}