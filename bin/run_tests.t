#!/usr/bin/env perl
#
# run by Github Actions, see .github/workflows/ci.yml
#

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
    my $country = shift;
    my $rh_test = shift;
    my $abbrv   = shift || 0;

    my $formatted;
    if ($abbrv){
        $formatted = $GAF->format_address($rh_test->{components}, {abbreviate => 1});
    }
    else {
        $formatted = $GAF->format_address($rh_test->{components});
    }
    is(
        $formatted,
        $rh_test->{expected},
        $country . ' - ' . $rh_test->{description}
    );
}

foreach my $filename (@files){
    my $abbrv = 0;
    if ($filename =~ m/abbreviations/){
        $abbrv = 1;
    }
    my $country = basename($filename);
    $country =~ s/\.\w+$//; # us.yaml => us

    my @a_testcases = ();
    lives_ok {
        @a_testcases = LoadFile($filename);
    } "parsing file $filename";

    foreach my $rh_testcase (@a_testcases){
        _one_testcase($country, $rh_testcase, $abbrv);
    }
}


done_testing();
