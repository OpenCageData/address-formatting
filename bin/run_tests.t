#!/usr/bin/env perl

# copy of
# https://github.com/OpenCageData/perl-Geo-Address-Formatter/blob/master/t/unit/countries.t
# and runs in travis-CI (see .travis.yml)

use strict;
use lib 'perl/lib/perl5';
use File::Basename qw(basename dirname);
use File::Find::Rule;
use File::Spec;
use Test::Exception;
use Test::More;
use YAML::XS qw(LoadFile);

use utf8;
# nicer output for diag and failures, see
# http://perldoc.perl.org/Test/More.html#CAVEATS-and-NOTES
my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";


{
    # Some YAML parsers croak on duplicate keys. By default the Perl parser
    # doesn't. Here we make sure we didn't overlook any duplicate keys.
    $YAML::XS::ForbidDuplicateKeys = 1;

    my @a_conf_files = File::Find::Rule->file()
                                     ->name( '*.yaml' )
                                     ->in( dirname(__FILE__) . '/../conf/' );

    foreach my $conf_file (@a_conf_files) {
        lives_ok { LoadFile($conf_file) } "parsing file $conf_file";
    }
}


my $path = dirname(__FILE__) . '/../testcases';

my @files = File::Find::Rule->file()->name( '*.yaml' )->in( $path );

ok(scalar(@files), 'found at least one file');

my $CLASS = 'Geo::Address::Formatter';
use_ok($CLASS);

my $conf_path = dirname(__FILE__) . '/../conf';
my $GAF = $CLASS->new( conf_path => $conf_path );

sub _one_testcase {
    my $country    = shift;
    my $rh_testcase = shift;
    is(
        $GAF->format_address($rh_testcase->{components}),
        $rh_testcase->{expected},
        $country . ' - ' . $rh_testcase->{description}
    );
}

foreach my $filename (@files){
    my $country = basename($filename);
    $country =~ s/\.\w+$//; # us.yaml => us

    my @a_testcases = ();
    lives_ok {
        @a_testcases = LoadFile($filename);
    } "parsing file $filename";

    foreach my $rh_testcase (@a_testcases){
        _one_testcase($country, $rh_testcase);
    }
}


done_testing();
