## ------ COLORS ------ ##

DEFAULT     =   "\033[00m"
RED         =   "\033[31m"
GREEN       =   "\033[1;32m"
TEAL        =   "\033[1;36m"
YELLOW      =   "\033[1;7;25;33m"
MAGENTA     =   "\033[1;3;4;35m"
ERROR       =   "\033[5;7;1;31m"
BLINK       =   "\033[5m"
END         =   "\n"

CC          =   clang

RULE        =   re

SRC         =   src/main.c	\
                src/srm.c

CFLAGS      =   -W -Wall -Wextra -Wpedantic -Wpadded -std=c99 -I include -O3

OBJ         =   $(SRC:.c=.o)

NAME        =   srm

%.o:	%.c
	@$(CC)  $(CFLAGS) -c $< -o $@ && \
	printf "["$(GREEN)"OK"$(DEFAULT)"] "$(TEAL)$<$(DEFAULT)" -----> "$(GREEN)$@$(DEFAULT)$(END) || \
	printf "["$(RED)"KO"$(DEFAULT)"] "$(BLINK)$(YELLOW)$^$(DEFAULT)$(END) 1>&2

all:    $(NAME) ## Build
	@printf "["$(GREEN)"INFO"$(DEFAULT)"] Compiler: $(CC)"$(END)

$(NAME): $(OBJ) ## Linking
	@$(CC) -o $(NAME) $(OBJ) $(CFLAGS) $(LDFLAGS)
	@printf "["$(GREEN)"OK"$(DEFAULT)"]"$(TEAL)" Done : "$@$(DEFAULT)$(END) || \
	printf "["$(RED)"KO"$(DEFAULT)"]"$(BLINK)$(YELLOW)$(NAME)$(DEFAULT)$(END) 1>&2

debeug: CFLAGS += -g3 ## Build with debeug symbols
debeug: LDFLAGS += -g3
debeug: RULE = debeug
debeug: all

install: re
	cp $(NAME) ~/bin

clean: ## Remove obj files
	@rm -f $(OBJ)
	@printf "["$(RED)"DEL"$(DEFAULT)"] $(OBJ)"$(END)

fclean: clean ## Restart to 0
	@rm -f $(NAME)
	@printf "["$(RED)"DEL"$(DEFAULT)"] $(NAME)"$(END)

re:     fclean all

docker_test: fclean ## Build in docker
	docker run --rm -v $(PWD):/project -it epitech zsh -c "cd project && make tests_run"

help: ## Display help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all clean fclean
