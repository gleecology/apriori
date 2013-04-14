#!/usr/bin/env perl

# this is used to skip asking questions
use CPAN;


sub main {
    
	my $f = shift @ARGV;
	-f $f or die "usage: $0 <cpan_mods_file>";
		
    _init();

	open my $fh, '<', $f or die "failed to open:$!";

	while(<$fh>){ 
		next if $_ =~ /^\s*#/ or $_ =~ /^[\s\t]*$/ ;
		try_install($1) if m@(\S+)@;
	}
	close $fh;
};


sub _init {
    my $d = "$ENV{HOME}/.cpan/CPAN";
    my $f = "MyConfig.pm"; 
    -f "$d/$f" and return;
    -d or print STDERR `mkdir -p $d`;
    -f "./$f" or die "you need to configure cpan for the first time!";
    print STDERR "using $f found in this dir\n";
    print STDERR `cp $f $d/`;
}




sub try_install { 
    my $m = shift;
    print STDERR "--" x 10, "module=$m", '--' x 10, "\n";
    my $obj = CPAN::Shell->expand('Module',$m);
    if ($obj) {
        eval { CPAN::Shell->install($m) };
		$@ and print STDERR "-----\n eval($m) Shell eval reporting: $@\n-----\n";

    } else {
        print "\t no object \n";
    }
}


main();


1;


__END__
