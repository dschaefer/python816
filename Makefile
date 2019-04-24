OBJS =	python.prg

SRCS =	python.s \
		defs.ah \
		util.s \
		memory.s \
		string.s

all:	$(OBJS)

python.prg:	$(SRCS)
	acme -r $@.list -f cbm -o $@ $<

%.o:	%.s
	acme -f plain -o $@ $<

clean:
	rm *.prg *.list

run:	test.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 python.prg
