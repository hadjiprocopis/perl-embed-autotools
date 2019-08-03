use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Embed;
use Config;

sub MY::postamble {
	my (undef,%inparams) = @_;
	my @srcs = $inparams{C_EMBED_FILES};
	my @objs = map { my $x = $_; $x=~s/\.c$/.o/i; $x } @srcs;
	my @exes = map { my $x = $_; $x=~s/\.c$//i; $x } @srcs;
	my @VARS = (
		'PERL_EXT_INC = ' . $Config{archlibexp} . "/CORE",
		'PERL_EXT_LIB = ' . $Config{sitearch},
		'PERL_EXT_CPPFLAGS = ' . $Config{cppflags},
		'PERL_EXT_LDFLAGS = ' . (
			$Config{osname} eq 'darwin' ?
				 ($Config{lddlflags} =~ s/-arch [^ ]+//gr)
			: $Config{lddlflags}
		) ,
		'PERL_EXT_DLEXT = ' . $Config{'dlext'},
		'PERL_EXT_PREFIX = ' . $Config{'prefix'},
		'PERL_EXT_EMBED_CFLAGS = ' . eval { ExtUtils::Embed::ccopts },
		'PERL_EXT_EMBED_LDFLAGS = ' . eval { ExtUtils::Embed::ldopts },
	);
		
	return 	"SRCS=@srcs"."\n"
		. 'OBJS=$(SRCS:%.c=%.o)'."\n"
		. 'EXES=$(SRCS:%.c=%)'."\n\n"
		. 'CFLAGS+=${PERL_EXT_EMBED_CFLAGS}'."\n\n"
		. 'LDFLAGS+=${PERL_EXT_EMBED_LDFLAGS}'."\n\n"
		. join("\n", @VARS)
		. << 'EOC'
embed: $(EXES)

clean:: myclean

myclean:
	$(RM) $(OBJS) $(EXES)
EOC
}

WriteMakefile(
   INSTALL_BASE      => "$ENV{HOME}/usr",
    NAME	     => 'Statistics::Running::Tiny',
    AUTHOR	   => q{Andreas Hadjiprocopis <bliako@cpan.org>},
    VERSION     => '1.0',
    ABSTRACT => '',
    LICENSE	  => 'artistic_2',
    PL_FILES	 => {},
    MIN_PERL_VERSION => '5.006',
    CONFIGURE_REQUIRES => {
	'ExtUtils::MakeMaker' => '0',
    },
    BUILD_REQUIRES => {
	'Test::More' => '0',
	'Test::Harness' => '0',
    },
    PREREQ_PM => {
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Statistics-Running-Tiny-*' },
    postamble => { C_EMBED_FILES => glob 'src/*.c' }
);
