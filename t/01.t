BEGIN {
  use lib 'lib';
  use strict;
  use Test::More;

  plan tests => 8;

  use_ok('Data::Dumper');
  use_ok('Math::Combinatorics');
}

my @data = qw( a b c d );

my $f = 0;
my @r;
my $c;

$c = Math::Combinatorics->new(
                              data => \@data,
                              count => 2,
                             );

$f = 0;
while(my(@combo) = $c->next_combination){
  $f++;
}
ok($f == 6);

$c = Math::Combinatorics->new(
                              data => \@data,
                              count => 3,
                             );
$f = 0;
while(my(@combo) = $c->next_combination){
  $f++;
}
ok($f == 4);

@r = combine(2,@data);
ok(scalar(@r) == 6);

@r = combine(3,@data);
ok(scalar(@r) == 4);

#####################

$c = Math::Combinatorics->new(
                              data => \@data,
                              count => 2,
                             );

$f = 0;
while(my(@combo) = $c->next_permutation){
  $f++;
}
ok($f == 24);

@r = permute(@data);
ok(scalar(@r) == 24);

#my @c = permute(@data);
##print join "\n", sort { $a cmp $b } map { join " ", @$_ } @c;
#print join "\n", map { join " ", @$_ } @c;
#print "\n";
