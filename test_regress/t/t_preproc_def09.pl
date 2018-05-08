#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003-2009 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.

scenarios(vlt => 1);

my $stdout_filename = "$Self->{obj_dir}/$Self->{name}__test.vpp";

compile(
    verilator_flags2 => ['-E'],
    verilator_make_gcc => 0,
    stdout_filename => $stdout_filename,
    );

ok(files_identical($stdout_filename, "t/$Self->{name}.out"));

1;
