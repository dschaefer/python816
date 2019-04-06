OBJS =	test.prg \
		test.o

all:	$(OBJS)

%.prg:	%.s
	acme -r $@.list -f cbm -o $@ $^

%.o:	%.s
	acme -f plain -o $@ $^

clean:
	rm $(OBJS)

run:	test.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 test.prg
