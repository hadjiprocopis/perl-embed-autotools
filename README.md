Skeleton for building perlembed projects using Autotools.

Quick starting in a unix system:

    sh bootstrap.sh && ./configure && make clean && make all

If in a windows system just execute the
autotools commands in `bootstrap.sh`
manually or in a batch file. But seriously,
wouldn't you be happier doing something else
for a living?

If all goes well you will see your executable:

    src/myperlembed

corresponding to the C program embedding a perl interpreter

    src/myperlembed.c

Embedding a Perl interpreter into your C code opens a whole
new can of possibilities for computer visionaries. And it's dead
simple. See https://perldoc.perl.org/perlembed.html for more details
but here is an example program in C which acts just like perl.exe:
```
/* WARNING: For perl-5.30.0 !!!! */
/* check https://perldoc.perl.org/perlembed.html */

#include <EXTERN.h>/* from the Perl distribution*/
#include <perl.h>  /* from the Perl distribution*/
static PerlInterpreter *my_perl;  /***    The Perl interpreter    ***/
int main(int argc, char **argv, char **env)
{
  PERL_SYS_INIT3(&argc,&argv,&env);
  my_perl = perl_alloc();
  perl_construct(my_perl);
  PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
  perl_parse(my_perl, NULL, argc, argv, (char **)NULL);
  perl_run(my_perl);
  perl_destruct(my_perl);
  perl_free(my_perl);
  PERL_SYS_TERM();
  exit(EXIT_SUCCESS);
}
```

Compiling this simple program is not that simple.

The problem in compiling perl-embedding code, such as the above,
is that there
are a lot of CFLAGS and LDFLAGS which need to be passed
to the compiler in order to find all the dependency libraries
and include files. Additionally, it must find which compiler
was used to compile the original perl and use this same
compiler for compiling your code. Finally, there is the
decision whether this will be a static- or dynamic-linking
build. Static is the most useful for distribution and notoriously
difficult because all modules any perl scripts interpreted by
your perl-embedding code must be statically compiled too and
embedded into the final perl-embedding executable!

This skeleton takes care of the nitty-gritty job of
enquiring CFLAGS and LDFLAGS and CC for compiling your
perl-embeding programs. Which means that you can use 

    configure.ac

and

    Makefile.am

as they are, without any modifications, in order to compile this

    src/myperlembed.c

painlessly and, hopefully, successfully.

If you want to add more C programs simply add them to the file

    src/Makefile.am

If you want a more complex project structure whereas src/ has subdirs
and so on, then that's simple too but you better read more on Autotools.
Your kilometerage may vary by just adding subdirs in top-level's

    Makefile.am

and for each of these subdirs have a Makefile.am styled along the lines of

    src/Makefile.am

If you renamed src/ dir or src/myperlembed.c, then
you will have to modify slightly

    configure.ac

Just search for these files/dirs and modify accordingly.

You may think this is hard work but it is not because you will only
have to do this once and then your project will be portable anywhere
the GNU Build System is in use or can be used by simple installation.
Yes even for windows. Just make a tarball of your project, untar in
another system and the usual:

    sh bootstrap.sh && ./configure && make clean && make all

will get you going guaranteed.

-----------------------------------

However, for the faint hearted I have also created a

    Makefile.PL

This uses ExtUtils::MakeMaker to produce a Makefile which will
then compile your perl-embeding code. In the

    postamble

section of

    Makefile.PL

you will see how the compilation variables are extracted via Perl's

    %Config

and

    ExtUtils::Embed::ccopts 
    ExtUtils::Embed::ldopts 
    ExtUtils::Embed::xsinit 

Be warned that this is not as a robust solution as Autotools meaning
that you will have to modify it heavily    
if you want to add more complex targets,
for example building binary libraries from your C code and linking your
perl-embeding code to them or even installing your executables. With
doubtful results.

It's just a convenient and familiar-for-most way to compile C programs
but it is not the natural way and presented here in the spirit
of TIMTOWTDI which makes Perl and Perl Hackers shine.

-----------------------------------

Now some details which you can do without.

There are two m4 macros which call

    perl -MExtUtils::Embed -e ccopts -e ldopts

parse the output and export these symbols:

Macro #1 : AX_PERL_EXT (in m4/ax_perl_ext.m4):

    PERL_EXT_PREFIX: top-level perl installation path (--prefix)
    PERL_EXT_INC: XS include directory
    PERL_EXT_LIB: Perl extensions destination directory
    PERL_EXT_CPPFLAGS: C preprocessor flags to compile extensions
    PERL_EXT_LDFLAGS: linker flags to build extensions
    PERL_EXT_DLEXT: extensions suffix for perl modules (e.g. ".so")

call it like this:

    AX_PERL_EXT()

This macro was written by

    Stanislav Sedov <stas@FreeBSD.org>

    Thomas Klausner <tk@giga.or.at>

---------------------------------------

Macro #2 : AX_PERL_EMBED_EXT (in m4/ax_perl_embed_ext.m4):

    PERL_EMBED_EXT_CC: the CC used to compile perl, you need to use this for compiling your app
    PERL_EMBED_EXT_CPPFLAGS: C preprocessor flags to compile extensions
    PERL_EMBED_EXT_LDFLAGS: linker flags to build extensions

call it like this:
```
     AX_PERL_EMBED_EXT(
	[HTML::Parser Net::IP:XS],
	[-I... -I... -xyz -abc]
     )
```
This macro was written by Andreas Hadjiprocopis and is heavily based
on AX_PERL_EXT (in m4/ax_perl_ext.m4).

The first parameter is a SPACE-separated list of modules to compile
with your application ONLY in the case that you are linking statically.
Otherwise leave this first parameter empty (e.g. [])

The second parameter is a SPACE-separated list of parameters to the perl
executing:

    perl -MExtUtils::Embed -e ccopts -e ldopts

This is in the case when you are using another perl and you have different INC
for example. If you are building for your current perl, then leave this empty
(e.g. []). If you are building for another perl which is not default then
make it default e.g. by using perlbrew. If you do that then you can
leave this parameter empty too. So, normally you call this macro like:

    AX_PERL_EMBED_EXT([],[])

Suppose that you want to compile perl-embed file
    myperlembed.c

in subdir src/

Then simply add 

    -I$(PERL_EXT_INC)

to its CFLAGS

and

    $(PERL_EMBED_EXT_LDFLAGS)

to its LDFLAGS and you are good to go. See src/Makefile.am


AUTHORS:

m4 macro m4/ax_perl_ext.m4 (providing AX_PERL_EXT) was written by:

    Copyright (c) 2011 Stanislav Sedov <stas@FreeBSD.org>

    Copyright (c) 2014 Thomas Klausner <tk@giga.or.at>

all the other files including m4 macro m4/ax_perl_embed_ext.m4
providing AX_PERL_EMBED_EXT was written by:

    Andreas Hadjiprocopis (andreashad2@gmail.com / bliako@cpan.org)

This work is provided as is under GPL v3.


Andreas,

Jan 2019 - Banana Republic.
