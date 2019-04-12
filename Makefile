OBJS =	python.prg

SRCS =	python.s \
		memory.s \
		stdio.s \
		defs.s

all:	$(OBJS)

python.prg:	$(SRCS)

%.prg:	%.s
	acme -r $@.list -f cbm -o $@ $^

%.o:	%.s
	acme -f plain -o $@ $^

clean:
	rm *.prg *.list

run:	test.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 python.prg
