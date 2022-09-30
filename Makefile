TOP := .
OBJ := $(TOP)/obj
SRC := $(TOP)/animula
INC := $(SRC)/inc
MAKE := make
CC := gcc
V := @
cfile := $(sort $(shell find $(SRC)/ -name "*.c"))
ofile := $(cfile:.c=.o)
ofile := $(addprefix $(OBJ)/,$(ofile))
dfile := $(ofile:.o=.d)
LDPATH := -L$(OBJ)
LDFLAGS := $(LDPATH) -m32 -lm -fsanitize=address
ifeq ($(RELEASE), 1)
O_LEV := s
DSYM :=
DBG :=
else
O_LEV := g
DSYM := -g
DBG := -DANIMULA_DEBUG
endif

CFG := -D GC_RECYCLE_CURRENT_FRAME

CFLAGS := -O$(O_LEV) $(DSYM) -I$(INC) -MD -Wall -Wno-unused -Werror -Wextra -m32 \
	-Wno-int-to-pointer-cast -Wno-pointer-to-int-cast -Wno-pointer-arith -fsanitize=address \
	-fdiagnostics-color=always -Wno-strict-aliasing -Wno-unused-parameter -Wno-format-security -Wno-stringop-overread \
	-DANIMULA_LINUX $(DBG) $(CFG) -Wno-pragmas
PROG := animula-vm

all:
	$(V)$(MAKE) $(PROG)
	@echo "$(PROG) build successfully!"

-include $(dfile)
program-framework := $(ofile)

$(OBJ)/%.d: %.c | $(OBJ)
	set -e; rm -f $@; \
	$(CC) -MM $(CFLAGS) $(INC) $< > $@.$$$$; \
	sed 's|\($*\)\.o[ :]*|\1.o $@ : |g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

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
