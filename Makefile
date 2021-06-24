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
	@chmod +x ./making.sh
	./making.sh $(MOVE) $(filter-out $@,$(MAKECMDGOALS))

h:
	@chmod +x ./making.sh
	@./making.sh $(HELP)

v:
	@touch v
	@$(MAKE) -s -j$(PROCESSOR) v
	@rm -f v
	@chmod +x ./making.sh
	@./making.sh $(VALGRIND)

l:
	@touch l
	@$(MAKE) -s -j$(PROCESSOR) l
	@rm -f l
	@chmod +x ./making.sh
	@./making.sh $(LIZARD)

testing:
	@$(MAKE) -s -j1 clean
	@$(MAKE) -s -j$(PROCESSOR)
	@chmod +x ./making.sh
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