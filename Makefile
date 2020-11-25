SRC_DIR = src/
TEST_DIR = test/
SOURCE_FILES = $(addprefix $(SRC_DIR), arrayList.c)
HEADER_FILES = $(addprefix $(SRC_DIR), arrayList.h)
TEST_NAME = arrayListTest
TEST_FILE = $(TEST_DIR)$(TEST_NAME).c

OS := $(shell uname)

.PHONY: test
test: $(SOURCE_FILES) $(HEADER_FILES)
	gcc -Wall $(SOURCE_FILES) $(TEST_FILE) -o $(TEST_NAME)

./$(TEST_NAME): test

leakCheck: ./$(TEST_NAME)
	valgrind --leak-check=full ./$(TEST_NAME)
	rm -rf $(TEST_NAME).dSYM

ifeq ($(OS), Darwin)

LIB_NAME = libarraylist.a
OBJECT_FILES = arraylist.o
DESTDIR = /usr/local

.PHONY: install
install: $(LIB_NAME) $(HEADER_FILES)
	mv $(LIB_NAME) $(DESTDIR)/lib
	cp $(HEADER_FILES) $(DESTDIR)/include

$(LIB_NAME): $(OBJECT_FILES)
	ar -rcs $(LIB_NAME) $(OBJECT_FILES)
	rm -f $(OBJECT_FILES)

$(OBJECT_FILES): $(SOURCE_FILES)
	gcc -c $(SOURCE_FILES)

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)/lib/$(LIB_NAME)
	rm -f $(addprefix $(DESTDIR)/include/, $(HEADER_FILES))

endif