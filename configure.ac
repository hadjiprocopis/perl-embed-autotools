# Example configure.ac written by Andreas Hadjiprocopis
# andreashad2@gmail.com / bliako@cpan.org

# the compiler will be decided later when we see the +/- debug switch, for the time use this
CC=gcc

################
dnl for these see at the end of file as well
AC_INIT([perlembed with autotools], [0.1], [andreashad2@gmail.com])
AC_CANONICAL_SYSTEM
AC_CANONICAL_TARGET
AC_CANONICAL_HOST
AC_CONFIG_MACRO_DIR([m4])
# just a single source file is enough
AC_CONFIG_SRCDIR([src/myperlembed.c])
AM_INIT_AUTOMAKE()

LT_INIT()

m4_pattern_allow([AC_CONFIG_MACRO])
m4_pattern_allow([AS_AC_EXPAND])
m4_pattern_allow([AC_MSG_ERROR])
m4_pattern_allow([AC_MSG_WARN])
m4_pattern_allow([AM_PROG_LIBTOOL])
m4_pattern_allow([AX_PERL_EXT])
m4_pattern_allow([AX_PERL_EMBED_EXT])

# checks for the perl compile ldflags, cppflags (see ax_perl_ext.m4)
AX_PERL_EXT(0.0)

# If you are building for another perl which is not your current
# (e.g. set it via perlbrew) then you need to execute this macro
# with that perl as active (in your path)
# perl sources
#PERLINCDIRS=-I/abc/xyz
#AX_PERL_EMBED_EXT([ \
#Data::Dumper \
#],
#[ \
#${PERLINCDIRS} \
#]) # additionally checks for CC/LDFLAGS/CPPFLAGS which work
# 
# If you have only 1 perl or you activated your target perl via perlbrew
# then you only need to do this:
AX_PERL_EMBED_EXT([],[])

# now, all the variables exported by AX_PERL_EXT and AX_PERL_EMBED_EXT are available
PKG_CHECK_MODULES([CHECK], [check])

AS_IF([test "x$PERL_EMBED_EXT_IS_BUILT_STATIC" == "x1"], [
	AC_MSG_RESULT(Disabling shared libraries, perl was build static)
	AC_DISABLE_SHARED
	enable_shared=no; enable_static=yes
])

# perl things need to be compiled with CC libperl was compiled initially
# so we may as well do them all with that crap
CC=${PERL_EMBED_EXT_CC}

#AC_PROG_RANLIB
AC_PROG_LIBTOOL

AC_PROG_CC
AC_SUBST(CFLAGS)
AC_SUBST(CXXFLAGS)

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET

AC_SUBST(AUTHOR, "Andreas Hadjiprocopis (andreashad2\@gmail.com)")
AC_SUBST(BUILTDATE, `date`)
AC_SUBST(TITLE, "perlembed Autotools Demo")
AC_SUBST(DATESTARTED, "Jan 2019")
AC_SUBST(SEARCHPATH, $PATH)

AC_OUTPUT(
	Makefile
	src/Makefile
)

AC_MSG_WARN([CFLAGS are: ${CFLAGS}])
AC_MSG_WARN([CXXFLAGS are: ${CXXFLAGS}])
AC_MSG_WARN([LDFLAGS are: ${LDFLAGS}])
AC_MSG_WARN([PERL_EMBED_EXT_LDFLAGS are: ${PERL_EMBED_EXT_LDFLAGS}])
AC_MSG_WARN([PERL_EXT_INC are: ${PERL_EXT_INC}])
