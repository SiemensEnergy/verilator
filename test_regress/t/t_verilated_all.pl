#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003-2009 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.

scenarios(vlt => 1);

my $root = "..";

compile(
    # Can't use --coverage and --savable together, so cheat and compile inline
    verilator_flags2 => ['--cc --coverage-toggle --coverage-line --coverage-user --trace --vpi $root/include/verilated_save.cpp'],
    );

execute(
    check_finished => 1,
    );

my %hit;
foreach my $file (glob("$root/include/*.cpp $root/include/*.h")) {
    $file =~ s!.*/!!;
    print "NEED: $file\n" if $Self->{verbose};
    $hit{$file} = 0;
}
foreach my $dfile (glob("$Self->{obj_dir}/*.d")) {
    my $wholefile = file_contents($dfile);
    foreach my $file (split /\s+/, $wholefile) {
        $file =~ s!.*/!!;
        print "USED: $file\n" if $Self->{verbose};
        $hit{$file} = 1;
    }
}

foreach my $file (sort keys %hit) {
    if (!$hit{$file}
        && $file !~ /_sc/) {
        error("Include file not covered by t_verilated_all test: ",$file);
    }
}

ok(1);
1;
