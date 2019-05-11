OBJS =	python.prg

SRCS =	python.asm \
		defs.ah \
		dict.ah \
		memory.ah \
		string.ah \
		tables.ah \
		util.ah

all:	$(OBJS)

python.prg:	$(SRCS)
	acme -r $@.list -f cbm -o $@ $<

%.o:	%.s
	acme -f plain -o $@ $<

clean:
	del *.prg *.list

run:	python.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 python.prg
