BEGIN {
  use lib 'lib';
  use strict;
  use Test::More;

  plan tests => 4;

  use_ok('Data::Dumper');
  use_ok('Math::Combinatorics');
  use Math::Combinatorics qw(combine permute);
}

my @n = qw(a b c);
ok(my @c = combine(2,@n));
ok(my @p = permute(@n));

#print "combinations of 2 from: ".join(" ",@n)."\n";
#print "------------------------".("--" x scalar(@n))."\n";
#print join("\n", map { join " ", @$_ } combine(2,@n)),"\n";
#print "\n";
#print "permutations of 3 from: ".join(" ",@n)."\n";
#print "------------------------".("--" x scalar(@n))."\n";
#print join("\n", map { join " ", @$_ } permute(@n)),"\n";
