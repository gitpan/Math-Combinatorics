# Below is stub documentation for your module. You better edit it!

=head1 NAME

Math::Combinatorics - Perform combinations and permutations on lists

=head1 SYNOPSIS

  use Math::Combinatorics qw(combine permute);

  my @n = qw(a b c);
  print "combinations of 2 from: ".join(" ",@n)."\n";
  print "------------------------".("--" x scalar(@n))."\n";
  print join("\n", map { join " ", @$_ } combine(2,@n)),"\n";
  print "\n";
  print "permutations of 3 from: ".join(" ",@n)."\n";
  print "------------------------".("--" x scalar(@n))."\n";
  print join("\n", map { join " ", @$_ } permute(@n)),"\n";

  output:
  combinations of 2 from: a b c
  ------------------------------
  b c
  a c
  a b

  permutations of 3 from: a b c
  ------------------------------
  b a c
  b c a
  c b a
  c a b
  a c b
  a b c

=head1 DESCRIPTION

Combinatorics is the branch of mathematics studying the enumeration, combination,
and permutation of sets of elements and the mathematical relations that characterize
their properties.  As a jumping off point, refer to:

http://mathworld.wolfram.com/Combinatorics.html

This module provides a pure-perl implementation of nCk, nPk, and n! (combination,
permutation, and factorial, respectively).

=head2 EXPORT

the following export tags will bring a single method into the caller's
namespace.  no symbols are exported by default.  see pod documentation below for
method descriptions.

  combine
  permute
  factorial

=head1 AUTHOR

Allen Day <allenday@ucla.edu>

=head1 BUGS

report them to the author.  a known bug (partial implementation bug) does not allow
parameterization of k for nPk in permute().  it is assumed k == n.  L</permute()> for
details.

=head1 SEE ALSO

L<String::Combination> (misnamed, it actually returns permutations on a string).

=cut

package Math::Combinatorics;

use strict;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( combine permute factorial);
our $VERSION = '0.01';

=head1 METHODS

=head2 combine()

 Usage   : my @combinations = combine($k,@n);
 Function: implements nCk (n choose k), or n!/(k!*(n-k!)).
           returns all unique unorderd combinations of k items from set n.
           items in n can be scalars, or references... whatever.  they are
           copied into the return data structure (see "Returns" below).
 Example : my @n = qw(a b c);
           my @c = combine(2,@n);
           print join "\n", map { join " ", @$_ } @c;
           # prints:
           # b c
           # a c
           # a b
 Returns : a list of arrays, where each array contains a unique combination
           of k items from n
 Args    : a list of items to be combined


=cut

sub combine {
  my($k,@n) = @_;
  my $nlen = scalar(@n);

  if(($k != int($k)) or ($k < 1)){
    $@ = "k must be a non-zero positive integer";
    return ();
  } elsif($nlen == 1 || $nlen == $k){
    return ([@n]);
  } elsif($nlen < $k) {
    $@ = "k is greater than number of list elements";
    return ();
  } else {
    #good to go

    my @result;

    for(my $i = 1 ; $i <= 2 ** $nlen ; $i++){
      my @b = split '', sprintf("%0${nlen}b",$i);
      next unless sum(@b) == $k;

      my @tmp = ();
      for( my $i = 0; $i < scalar(@b) ; $i++){
        push @tmp, $n[$i] if $b[$i] == 1;
      }
      push @result, \@tmp;
    }

    return @result;
  }
}

=head2 permute()

 Usage   : my @permutations = permute(@n);
 Function: implements nPk (n permute k) (where k == n), or n!/(n-k)!
            returns all unique permutations of k items from set n
           (where n == k, see "Note" below).  items in n can be scalars,
           references... whatever.  they are copied into the return data
           structure.
 Example : my @n = qw(a b c);
           my @p = permute(@n);
           print join "\n", map { join " ", @$_ } @p;
           # prints:
           # b a c
           # b c a
           # c b a
           # c a b
           # a c b
           # a b c
 Returns : a list of arrays, where each array contains a permutation of
           k items from n (where k == n).
 Args    : a list of items to be permuted.
 Note    : k should really be parameterizable.  this will happen
           in a later version of the module.  send me a patch to
           make that version come out sooner.

=cut

sub permute {
  my(@n) = @_;
  return () unless @n;
  return @n if scalar(@n) == 1;

  my @result;

  my $i = 0;
  my $nlen = scalar(@n);

  my $perm_n = factorial(scalar(@n));
#  my $perm_n = factorial($k);

  while($i < $perm_n) {
    for(my $j = 0; $j < $nlen - 1; $j++,$i++) {

      ($n[$j],$n[$j+1]) = ($n[$j+1],$n[$j]); #swap

      my @tmp = @n; #copy
      push @result, \@tmp;
    }
  }

  return @result;
}

=head2 factorial()

 Usage   : my $f = factorial(4); #returns 24, or 4*3*2*1
 Function: calculates n! (n factorial).
 Returns : undef if n is non-integer or n < 1
 Args    : a positive, non-zero integer
 Note    : this function is used internally by combine() and permute()

=cut

sub factorial {
  my $n = shift;
  return undef unless $n > 0 and $n == int($n);

  my $f;

  for($f = 1 ; $n > 0 ; $n--){
    $f *= $n
  }

  return $f;
}

=head2 sum()

 Usage   : my $sum = sum(1,2,3); # returns 6
 Function: sums a list of integers.  non-integer list elements are ignored
 Returns : sum of integer items in arguments passed in
 Args    : a list of integers
 Note    : this function is used internally by combine()

=cut

sub sum {
  my $sum = 0;
  foreach my $i (@_){
    $sum += $i if $i == int($i);
  }
  return $sum;
}

1;
