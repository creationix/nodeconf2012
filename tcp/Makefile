OS_NAME=$(shell uname -s)
MH_NAME=$(shell uname -m)
ifeq (${OS_NAME},Darwin)
ifeq (${MH_NAME},x86_64)
LDFLAGS+=-framework CoreServices -pagezero_size 10000 -image_base 100000000
else
LDFLAGS+=-framework CoreServices
endif
else ifeq (${OS_NAME},Linux)
LDFLAGS+=-Wl,-E -lrt
endif

LDFLAGS+=-lm -ldl -lpthread

CFLAGS+=-pedantic-errors -Ilibuv/include --std=c89 -D_GNU_SOURCE -g -Wall -Werror


tcp: tcp.o libuv/uv.a
	$(CC) tcp.o libuv/uv.a -o tcp $(LDFLAGS)

tcp.o: tcp.c
	$(CC) -c tcp.c -o tcp.o $(CFLAGS)

libuv/uv.a: libuv/Makefile
	$(MAKE) -C libuv

clean:
	rm -f tcp tcp.o
