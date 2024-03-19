#!/usr/bin/env perl

use strict;
use utf8;
use lib 'perl/lib/perl5';
use File::Basename qw(basename dirname);
use Test::Exception;
use Test::More;
use YAML::XS qw(LoadFile);

my $conf_path = dirname(__FILE__) . '/../conf';
my $oneline;
lives_ok {
    $oneline = LoadFile($conf_path . '/countries/oneline.yaml');
} "parsing file oneline.yaml";

my %allowed_keys;
$allowed_keys{$_} = () foreach (
  'template', 'use_country', 'change_country', 'add_component', 'replace');

my %empty_lines_in;
$empty_lines_in{$_} = () foreach qw(AQ BT PN TC);

my @components = (
    # local house name
    ['house', 'quarter', ',', '/'],
    # address
    ['house_number', 'road', 'house', 'residential', ','],
    # city part
    ['suburb', 'city_district', 'neighbourhood', 'hamlet',
     'village', 'place', 'state_district', 'quarter'],
    # settlement
    ['city', 'town', 'village', 'hamlet', 'postal_city',
     'municipality', 'state_district', 'county', 'state',
     'suburb', 'region', 'island', 'city_district', 'neighbourhood'],
    # region
    ['county', 'state_district', 'state_code', 'county_code',
     'state', 'country', 'region', 'island', 'archipelago',
     'country', 'continent', 'province', 'municipality',
     'postcode'],
);

for my $country (keys %{$oneline}) {
  my $v = $country =~ /^generic/ ? { template => $oneline->{$country} } : $oneline->{$country};
  is(ref $v, ref {}, "$country value is a hash");

  ok(exists $allowed_keys{$_}, "key $_ valid for $country") for keys %{$v};

  ok(exists $v->{template} || exists $v->{use_country}, "template for $country exists");
  next if !exists $v->{template};

  my $t = $v->{template};
  is(ref $t, ref [], "template is a list for $country");
  is($#{$t}, 4, "template has 5 lines for $country");

  if (@{$t->[1]}) {
    ok(grep(/^road$/, @{$t->[1]}), "Road is present in line 2 of $country");
    ok(grep(/^house_number$/, @{$t->[1]}), "House number is present in line 2 of $country");
  }

  ok(grep(/^country$/, @{$t->[4]}), "Country is present in line 5 of $country");

  if (!exists $empty_lines_in{$country}) {
    for (0, 1, 3, 4) {
      ok(scalar @{$t->[$_]}, "Line ".($_ + 1)." of $country is not empty");
    }
  }

  for my $i (0..4) {
    for my $word (@{$t->[$i]}) {
      ok(grep(/^$word$/, @{$components[$i]}), "Known component $word in line ".($i+1)." of $country");
    }
  }
}


done_testing();
