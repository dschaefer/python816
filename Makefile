OBJS =	python.prg

SRCS =	defs.s \
		python.s \
		memory.s \
		stdio.s

all:	$(OBJS)

python.prg:	$(SRCS)
	acme -r $@.list -f cbm -o $@ $^

%.o:	%.s
	acme -f plain -o $@ $^

clean:
	rm *.prg *.list

run:	test.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 python.prg
