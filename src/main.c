#include "srm.h"

#include <stdio.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    int32_t fd = 0;

    if (argc != 2) {
        puts("USAGE:\n\t./srm <file>");
        return (FAILURE);
    }
    fd = open(argv[1], O_RDWR);
    if (fd == -1) {
        perror("srm");
        return (FAILURE);
    }
    srm(fd);
    remove(argv[1]);
    return (SUCCESS);
}
