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
LDFLAGS := $(LDPATH) -m32
ifeq ($(RELEASE), 1)
O_LEV := s
DSYM :=
DBG :=
else
O_LEV := g
DSYM := -g
DBG := -DLAMBDACHIP_DEBUG
endif

CFG := -D GC_RECYCLE_CURRENT_FRAME

CFLAGS := -O$(O_LEV) $(DSYM) -I$(INC) -MD -Wall -Wno-unused -Werror -Wextra -m32 \
	-Wno-int-to-pointer-cast -Wno-pointer-to-int-cast -Wno-pointer-arith \
	-fdiagnostics-color=always -Wno-strict-aliasing -Wno-discarded-qualifiers\
	-DLAMBDACHIP_LINUX $(DBG) $(CFG)
PROG := lambdachip-vm

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
