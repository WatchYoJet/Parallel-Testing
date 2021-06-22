CONFIG=config.default
include ${CONFIG}

#---------Compiler-Options---------
COMPILER=gcc
CFLAGS=-Wall -Wextra -Werror -ansi -pedantic -g
FILES=$(wildcard $(PROJECT_PATH)/*.c)
#---------------Macros-------------
# In order to change this, you'll need to do it on the making.sh file too
HELP=-h
MOVE=-m
VALGRIND=-v
LIZARD=-l
#----------------------------------

all:
	@$(COMPILER) $(CFLAGS) -o $(EXE_NAME) $(FILES)
	@mv $(EXE_NAME) $(PROJECT_PATH)

run:
	$(COMPILER) $(CFLAGS) -o $(EXE_NAME) $(FILES)
	./$(EXE_NAME)

m:
	./making.sh $(MOVE) $(filter-out $@,$(MAKECMDGOALS))

h:
	@./making.sh $(HELP)

v:
	@touch v
	@$(MAKE) -j$(PROCESSOR) v
	@rm -f v
	@./making.sh $(VALGRIND)

l:
	@touch l
	@$(MAKE) -j$(PROCESSOR) l
	@rm -f l
	@./making.sh $(LIZARD)

testing:
	@$(MAKE) -j$(PROCESSOR)
	@./making.sh

#I hate this so much, trust me
%:
	@:

difl:
	@diff -b ./tests/$(filter-out $@,$(MAKECMDGOALS)).out \
	./tests/$(filter-out $@,$(MAKECMDGOALS)).myout \
	> ./tests/$(filter-out $@,$(MAKECMDGOALS)).diff

mof:
	@./$(EXE_NAME) < ./tests/$(filter-out $@,$(MAKECMDGOALS)).in \
	> ./tests/$(filter-out $@,$(MAKECMDGOALS)).myout

test_comp:
	@$(COMPILER) $(CFLAGS) -o $(EXE_NAME) $(FILES)

clean:
	@rm -f $(PROJECT_PATH)/$(EXE_NAME) tests/*.diff tests/*.myout ./$(EXE_NAME) failed/*