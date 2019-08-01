# ===========================================================================
#       https://www.gnu.org/software/autoconf-archive/ax_perl_ext.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_PERL_EMBED_EXT
#
# INPUT PARAMS:
#   space-separated list of modules to search for their libraries in Perl's paths
#   for example:
#       AX_PERL_EMBED_EXT(
		[HTML::Parser Net::IP:XS], <<<< SPACE-SEPARATED
		[-I.. -xxx ] <<< params to perl SPACE-SEPARATED too
	)
# DESCRIPTION
#
#   Fetches the CC, linker flags and C compiler flags for compiling and linking
#   Perl-embed applications.  The macro substitutes PERL_EMBED_EXT_CC
#   PERL_EMBED_EXT_CPPFLAGS, PERL_EMBED_EXT_LDFLAGS
#   variables if Perl executable was found.  It also checks
#   the same variables before trying to retrieve them from the Perl
#   configuration.
#
#     PERL_EMBED_EXT_CC: the CC used to compile perl, you need to use this for compiling your app
#     PERL_EMBED_EXT_CPPFLAGS: C preprocessor flags to compile extensions
#     PERL_EMBED_EXT_LDFLAGS: linker flags to build extensions
#
#   Examples:
#
#     AX_PERL_EMBED_EXT
#     if test x"$PERL_EMBED_EXT_CC" = x; then
#	AC_ERROR(["cannot find Perl"])
#     fi
#
# LICENSE
#
# This is lightly modified version of AX_PERL_EXT all credit to the original authors
#
#   Copyright (c) 2011 Stanislav Sedov <stas@FreeBSD.org>
#   Copyright (c) 2014 Thomas Klausner <tk@giga.or.at>
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are
#   met:
#
#   1. Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
#   THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
#   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
#   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
#   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
#   THE POSSIBILITY OF SUCH DAMAGE.

#serial 3

AC_DEFUN([AX_PERL_EMBED_EXT],[

	#
	# Check if perl executable exists.
	#
	AC_PATH_PROGS(PERL, ["${PERL-perl}"], [])

	if test -n "$PERL" ; then

		#
		# Check for Perl CC
		#
		AC_ARG_VAR(PERL_EMBED_EXT_CC, [Perl CC])
		AC_MSG_CHECKING([for Perl CC])
		if test -z "$PERL_EMBED_EXT_CC" ; then
			[PERL_EMBED_EXT_CC=`$PERL -MConfig -e 'print $Config{cc};'`];
		fi
		AC_MSG_RESULT([$PERL_EMBED_EXT_CC])
		AC_SUBST(PERL_EMBED_EXT_CC)

		#
		# Check for Perl embed CPPFLAGS
		#
		AC_ARG_VAR(PERL_EMBED_EXT_CPPFLAGS, [Perl CPPFLAGS])
		AC_MSG_CHECKING([for Perl CPPFLAGS])
		if test -z "$PERL_EMBED_EXT_CPPFLAGS" ; then
			[PERL_EMBED_EXT_CPPFLAGS=`$PERL -MExtUtils::Embed -e ExtUtils::Embed::ccopts`];
		fi
		AC_MSG_RESULT([$PERL_EMBED_EXT_CPPFLAGS])
		AC_SUBST(PERL_EMBED_EXT_CPPFLAGS)

		#
		# Check for Perl embed LDFLAGS
		#
		AC_ARG_VAR(PERL_EMBED_EXT_LDFLAGS, [Perl LDFLAGS])
		AC_MSG_CHECKING([for Perl LDFLAGS])
		if test -z "$PERL_EMBED_EXT_LDFLAGS" ; then
			# not defined PERL_EMBED_EXT_LDFLAGS
			if test "$1" != ""; then
				AC_MSG_RESULT([with special request for these modules $1])
			fi
			if test "$2" != ""; then
				AC_MSG_RESULT([with additional parameters to perl: $2])
			fi
			# extra flags (like -I.. -I.. to perl are given with 2nd input argument
			CMD="$PERL $2 -MExtUtils::Embed -e "'print ExtUtils::Embed::ldopts(undef,[qw/'"$1"'/])'
			AC_MSG_RESULT([executing ${CMD}])
			[PERL_EMBED_EXT_LDFLAGS=`$PERL $2 -MExtUtils::Embed -e 'print ExtUtils::Embed::ldopts(undef,[qw/'"$1"'/])'`];
		else
			AC_MSG_ERROR([sorry but PERL_EMBED_EXT_LDFLAGS is already defined])
		fi
		AC_MSG_RESULT([$PERL_EMBED_EXT_LDFLAGS])
		AC_SUBST(PERL_EMBED_EXT_LDFLAGS)

		#
		# Check if Perl supports dynamic loading
		#
		AC_ARG_VAR(PERL_EMBED_EXT_DYNAMIC_LOADING, [Perl Dynamic Loading Support])
		AC_MSG_CHECKING([for Perl Dynamic Loading Support])
		if test -z "$PERL_EMBED_EXT_DYNAMIC_LOADING" ; then
			[PERL_EMBED_EXT_DYNAMIC_LOADING=`perl -MConfig -e 'print $Config{dlext} eq q/none/ ? 0:1'`];
		fi
		AC_MSG_RESULT([$PERL_EMBED_EXT_DYNAMIC_LOADING])
		AC_SUBST(PERL_EMBED_EXT_DYNAMIC_LOADING)

		#
		# Check if Perl is built static
		#
		AC_ARG_VAR(PERL_EMBED_EXT_IS_BUILT_STATIC, [Perl is built static])
		AC_MSG_CHECKING([for Perl built static])
		if test -z "$PERL_EMBED_EXT_IS_BUILT_STATIC" ; then
			# unfortunately this shit prints to stdout if run with '-e'...
			[PERL_EMBED_EXT_IS_BUILT_STATIC=`((perl -MExtUtils::Embed -e 'ExtUtils::Embed::ldopts()' -- -o STDOUT|grep 'B.a'>/dev/null)&&echo 1)||echo 0`];
		fi
		AC_MSG_RESULT([$PERL_EMBED_EXT_IS_BUILT_STATIC])
		AC_SUBST(PERL_EMBED_EXT_IS_BUILT_STATIC)

		# Fix LDFLAGS for OS X.  We don't want any -arch flags here, otherwise
		# linking will fail.  Also, OS X Perl LDFLAGS contains "-arch ppc" which
		# is not supported by XCode anymore.
		case "${host}" in
		*darwin*)
			PERL_EMBED_EXT_LDFLAGS=`echo ${PERL_EMBED_EXT_LDFLAGS} | sed -e "s,-arch [[^ ]]*,,g"`
			;;
		esac
		AC_MSG_RESULT([$PERL_EMBED_EXT_LDFLAGS])
		AC_SUBST(PERL_EMBED_EXT_LDFLAGS)

	fi
])
