TOP := $(shell pwd)
OBJ := $(TOP)/obj
SRC := $(TOP)/lambdachip
INC := $(SRC)/inc
MAKE := make
V := @
cfile := $(sort $(shell find $(SRC) -name *.c))
ofile := $(cfile:.c=.o)
ofile := $(addprefix $(OBJ)/,$(ofile))
dfile := $(ofile:.o=.d)
LDFLAGS := $(LDPATH) -E
CFLAGS := -Og -g -I$(INC) -MD -Wall -Wno-unused -Werror -Wextra \
	-fdiagnostics-color=always
PROG := lambdachip-vm
program-framework := $(ofile)

-include $(dfile)

all:
	$(V)echo $(program-framework)
	$(V)$(MAKE) $(PROG)
	@echo "$(PROG) build successfully!"

$(OBJ)/%.o: %.cc
	@echo + cc $<
	$(V)mkdir -p $(@D)
	$(V)$(CC) $(CFLAGS) -c -o $@ $<

$(PROG): $(program-framework)
	@echo + generate $(PROG) from $^
	$(V)$(CC) $(CFLAGS) -c -o $(OBJ)/main.o $(TOP)/main.c
	$(V)$(CC) -Wl,--as-needed -o $@ $^ $(OBJ)/main.o $(LDFLAGS)

.PHONY: clean

clean:
	-rm -fr $(OBJ)
