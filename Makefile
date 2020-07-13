TOP := .
OBJ := $(TOP)/obj
SRC := $(TOP)/lambdachip
INC := $(SRC)/inc
MAKE := make
CC := gcc
V := @
cfile := $(sort $(shell find $(SRC)/ -name "*.c"))
ofile := $(cfile:.c=.o)
ofile := $(addprefix $(OBJ)/,$(ofile))
dfile := $(ofile:.o=.d)
LDPATH := -L$(OBJ)
LDFLAGS := $(LDPATH)
CFLAGS := -Og -g -I$(INC) -MD -Wall -Wno-unused -Werror -Wextra \
	-Wno-int-to-pointer-cast -Wno-pointer-to-int-cast -Wpointer-arith \
	-fdiagnostics-color=always -DLAMBDACHIP_LINUX -DLAMBDACHIP_DEBUG
PROG := lambdachip-vm

all:
	$(V)$(MAKE) $(PROG)
	@echo "$(PROG) build successfully!"

-include $(dfile)
program-framework := $(ofile)

$(OBJ)/main.o: $(TOP)/main.c
	@echo + cc $<
	$(V)mkdir -p $(@D)
	$(V)$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ)/%.o: %.c
	@echo + cc $<
	$(V)mkdir -p $(@D)
	$(V)$(CC) $(CFLAGS) -c -o $@ $<

$(PROG): $(program-framework) $(OBJ)/main.o
	$(V)$(CC) -o $@ $^ $(LDFLAGS)

.PHONY: clean

clean:
	-rm -fr $(OBJ) $(PROG)
