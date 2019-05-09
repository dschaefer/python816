OBJS =	python.prg

SRCS =	python.s \
		defs.ah \
		dict.s \
		memory.s \
		string.s \
		tables.s \
		util.s

all:	$(OBJS)

python.prg:	$(SRCS)
	acme -r $@.list -f cbm -o $@ $<

%.o:	%.s
	acme -f plain -o $@ $<

clean:
	del *.prg *.list

run:	python.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 python.prg
