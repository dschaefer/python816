-include python.d

python.prg:	python.asm
	64tass python.asm -L python.list -M python.d -o python.prg

run:	python.prg
	xscpu64 -fs9 . -device9 1 -iecdevice9 python.prg
