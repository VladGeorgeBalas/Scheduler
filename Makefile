OUT_FILE = a.o

build:
	nim -o:$(OUT_FILE) c main.nim

test:
	nim -o:$(OUT_FILE) c modules/test.nim
