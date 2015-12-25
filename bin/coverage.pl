#!/usr/bin/env perl
#
# scan the tests and templates and tell us which territories
# don't yet have rules and tests
# 
use strict;
use warnings;

use Data::Dumper;
use Getopt::Long;

my $help    = 0;
my $details = 0;
GetOptions (
    'details' => \$details,
    'help'    => \$help,
) or die "invalid options";

if ($help) {
    usage();
    exit(0);
}

# get the list of countries
my %countries;
my $country_file = "../conf/country_codes.yaml";
open my $FH, "<", $country_file or die "unable to open $country_file $!";
while (my $line = <$FH>){
    chomp($line);
    if ($line =~ m/^(\w\w): \# (.*)$/){
        $countries{$1} = $2;
    }
}
close $FH;
print "We are aware of " . scalar(keys %countries) . " territories \n";


# which countries have tests?
my $test_dir = '../testcases/countries';
opendir(my $dh, $test_dir) || die "Error: Couldn't opendir($test_dir): $!\n";
my @files = grep { -f "$test_dir/$_" } readdir($dh);
closedir($dh);

my %test_countries;
foreach my $f (sort @files){
    $f =~ s/\.yaml//;
    $f = uc($f);
    $test_countries{$f} = 1;
}
print "We have tests for " . scalar(keys %test_countries) . " territories \n";
if ($details){
    print "We need tests for:\n";
    foreach my $cc (sort keys %countries){
        next if (defined($test_countries{$cc}));
        print "\t" . $cc . "\t". $countries{$cc}. "\n";
    }
}

# which countries have rules?
my $rules_file = '../conf/countries/worldwide.yaml';
open my $RFH, "<", $rules_file or die "unable to open $rules_file $!";
my %rules;
while (my $line = <$RFH>){
    chomp($line);
    if ($line =~ m/^"?(\w\w)"?:\s*$/){
        $rules{$1} = 1;
    }
}
close $RFH;
print "We have rules for " . scalar(keys %rules) . " territories \n";
if ($details){
    print "We need rules for:\n";
    foreach my $cc (sort keys %countries){
        next if (defined($rules{$cc}));
        print "\t" . $cc . "\t". $countries{$cc}. "\n";
    }
}








sub usage {
    print "\tHow many territories have formatting rules and tests?\n";
    print "\tBy default prints just a high level summary\n";
    print "\tusage:\n";
    print "\t\t no required parameters\n";
    print "\n";
    print "\t\t optional parameters:\n";
    print "\t\t --detail\t print full list of countries missing rules and tests\n";
    print "\t\t --help\t print this message \n";
    print "\n";
}


