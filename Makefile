DEFAULT_OUTDIR=out

OUTDIR ?= $(DEFAULT_OUTDIR)

$(OUTDIR)/Makefile : configure
	./configure

.DEFAULT_GOAL := .DEFAULT

.DEFAULT: $(OUTDIR)/Makefile
	@make -C $(OUTDIR) --no-print-directory $(MAKECMDGOALS)

