PROGRAM = python.prg
OBJS = \
	python.o \
	tests/doug.o

AS = cl65
ASFLAGS = -c -t c64 -l $(basename $<).list --create-dep $(basename $<).d
LDFLAGS = -t c64 -C c64-asm.cfg -u __EXEHDR__ -m $(basename $<).map -Ln $(basename $<).vice

$(PROGRAM): $(OBJS)
	cl65 $(LDFLAGS) -o $@ $^

-include $(OBJS:.o=.d)

clean:
	rm -fr *.o *.d *.list */*.o */*.d */*.list *.map *.vice *.prg

run:	$(PROGRAM)
	xscpu64 -moncommands hello.vice -fs9 . -device9 1 -iecdevice9 $(PROGRAM)
