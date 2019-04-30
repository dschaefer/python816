# Python816

Python for the upcoming Commander X16 and currently for the 65816 VICE SuperCPU emulator.

It's written in 65816 assembly language.

The assembler is the latest ACME assembler.

To build simply run ```make```. To run in the emulator run ```make run```.

More on the architecture as it settles down. Currently the idea is to fit all program code in page 0. We'll use a bytecode for code. All objects, including code objects will be stored in pages 2+. Objects will be referenced counted with
mark and sweep garbage collection as we start to run out of space.
