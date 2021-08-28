#include "srm.h"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

static void randomStr(char *s, const size_t len) {
    static char alphanum[ASCII_SIZE] = "";

    for (register uint8_t i = 0; i < ASCII_SIZE; i++)
        alphanum[i] = i;
    srand(time(0));
    for (register size_t i = 0; i < len; ++i)
        s[i] = alphanum[rand() % (sizeof(alphanum) - 1)];
    s[len] = 0;
}

uint8_t srm(int32_t fd)
{
    size_t size = lseek(fd, 0, SEEK_END);
    char *data  = malloc(size);

    if (!size || !data) {
        perror("srm");
        return (FAILURE);
    }
    lseek(fd, 0, SEEK_SET);
    randomStr(data, size - 1);
    for (register size_t i = 0; i < size; i++)
        write(fd, &data[i], 1);
    free(data);
    close(fd);
    return (SUCCESS);
}
