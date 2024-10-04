NAME      := libintercept.so

CC        ?= cc
CFLAGS    += -Wall -Wextra -Werror -fPIC
DEPFLAGS   = -M -MP -MF $@ -MT "$(OBJDIR)/$*.o $@"
LDFLAGS   := -shared
LDLIBS    := -ldl

SRCDIR    := .
OBJDIR    := cache/objs
DEPDIR    := cache/deps

SRCS_BASE := intercept.c
SRCS_ALL  := $(wildcard *.c)

SRCS_BASE := $(addprefix $(SRCDIR)/,$(SRCS_BASE))
SRCS_ALL  := $(addprefix $(SRCDIR)/,$(SRCS_ALL))
OBJS_BASE := $(SRCS_BASE:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
OBJS_ALL  := $(SRCS_ALL:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
DEPS_BASE := $(SRCS_BASE:$(SRCDIR)/%.c=$(DEPDIR)/%.d)
DEPS_ALL  := $(SRCS_ALL:$(SRCDIR)/%.c=$(DEPDIR)/%.d)

MAKEFLAGS += -j
export CFLAGS

REBUILD_TARGETS := opt debug re
CLEAN_TARGETS   := clean fclean
.DEFAULT_GOAL   := all

.PHONY: all opt debug clean fclean re


all: $(NAME)

opt: CFLAGS += -O3
opt: re

debug: CFLAGS += -g
debug: re

$(NAME): $(OBJS_ALL)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

%: $(OBJDIR)/intercept_%.o $(OBJS_BASE)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $(NAME)

$(OBJDIR)/%.o: %.c | $(OBJDIR) $(DEPDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(DEPDIR)/%.d: %.c | $(DEPDIR)
	$(CC) $(DEPFLAGS) $(CFLAGS) $<

$(OBJDIR) $(DEPDIR):
	mkdir -p $@

ifeq (, $(filter $(REBUILD_TARGETS) $(CLEAN_TARGETS),$(MAKECMDGOALS)))
    ifneq (, $(wildcard $(OBJDIR)))
        -include $(DEPS_ALL)
    endif
endif

clean:
	rm -rf $(OBJDIR) $(DEPDIR)

fclean: clean
	rm -f $(NAME)

re: fclean
	$(MAKE) all

print-%:
	echo $* = $($*)
