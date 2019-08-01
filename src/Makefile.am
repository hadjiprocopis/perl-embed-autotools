OPTIONS_AUTOMAKE=gnu
ACLOCAL_AMFLAGS=-I ./m4

# LDFLAGS for all executables in here
AM_LDFLAGS = \
$(PERL_EMBED_EXT_LDFLAGS)

# CFLAGS for all executables in here
AM_CFLAGS = \
	-I$(PERL_EXT_INC)

# All the executables we want to compile
bin_PROGRAMS = \
	myperlembed

# extra LDFLAGS for this executable ?
myperlembed_LDFLAGS = ${AM_LDFLAGS}
# extra CFLAGS for this executable ?
myperlembed_CFLAGS = ${AM_CFLAGS}

myperlembed_SOURCES = \
	myperlembed.c
