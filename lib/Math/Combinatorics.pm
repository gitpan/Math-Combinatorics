=head1 NAME

Math::Combinatorics - Perform combinations and permutations on lists

=head1 SYNOPSIS

Available as an object oriented API.

  use Math::Combinatorics;

  my @n = qw(a b c);
  my $combinat = Math::Combinatorics->new(count => 2,
                                          data => [@n],
                                         );

  print "combinations of 2 from: ".join(" ",@n)."\n";
  print "------------------------".("--" x scalar(@n))."\n";
  while(my @combo = $combinat->next_combination){
    print join(' ', @combo)."\n";
  }

  print "\n";

  print "combinations of 2 from: ".join(" ",@n)."\n";
  print "------------------------".("--" x scalar(@n))."\n";
  while(my @permu = $combinat->next_permutation){
    print join(' ', @permu)."\n";
  }

  output:

Or available via exported functions 'permute', 'combine', and 'factorial'.

  use Math::Combinatorics;

  my @n = qw(a b c);
  print "combinations of 2 from: ".join(" ",@n)."\n";
  print "------------------------".("--" x scalar(@n))."\n";
  print join("\n", map { join " ", @$_ } combine(2,@n)),"\n";
  print "\n";
  print "permutations of 3 from: ".join(" ",@n)."\n";
  print "------------------------".("--" x scalar(@n))."\n";
  print join("\n", map { join " ", @$_ } permute(@n)),"\n";


Output:

  combinations of 2 from: a b c
  ------------------------------
  a b
  a c
  b c

  combinations of 2 from: a b c
  ------------------------------
  a b c
  a c b
  b a c
  b c a
  c a b
  c b a

Output from both types of calls is the same, but the object-oriented approach consumes
much less memory for large sets.

=head1 DESCRIPTION

Combinatorics is the branch of mathematics studying the enumeration, combination,
and permutation of sets of elements and the mathematical relations that characterize
their properties.  As a jumping off point, refer to:

http://mathworld.wolfram.com/Combinatorics.html

This module provides a pure-perl implementation of nCk, nPk, and n! (combination,
permutation, and factorial, respectively).  Functional and object-oriented usages allow
problems such as the following to be solved:

nCk "Fun questions to ask the pizza parlor wait staff: how many possible combinations
of 2 toppings can I get on my pizza?".

nPk "Master Mind Game: ways to arrange pieces of different colors in a
certain number of positions, without repetition of a color".

Object-oriented usage additionally allows solving these problems by calling L</new()>
with a B<frequency> vector:

nPRk "morse signals: diferent signals of 3 positions using the 2 two symbol - and .".

nCRk "ways to extract 3 balls at once of a bag with black and white balls".

nPRk "different words obtained permuting the letters of the word PARROT".

=head2 EXPORT

the following export tags will bring a single method into the caller's
namespace.  no symbols are exported by default.  see pod documentation below for
method descriptions.

  combine
  permute
  factorial

=head1 AUTHOR

Allen Day <allenday@ucla.edu>, with algorithmic contributions from Christopher Eltschka and
Tye.

=head1 ACKNOWLEDGEMENTS

Thanks to everyone for helping to make this a better module.

For adding new features: Carlos Rica, David Coppit

For bug reports: Ying Yang, Joerg Beyer, Marc Logghe

=head1 BUGS

report them to the author.  a known bug (partial implementation bug) does not allow
parameterization of k for nPk in permute().  it is assumed k == n.  L</permute()> for
details.

=head1 SEE ALSO

L<Set::Scalar>

L<Set::Bag>

L<String::Combination> (misnamed, it actually returns permutations on a string).

http://perlmonks.thepen.com/29374.html

http://groups.google.com/groups?selm=38568F79.13680B86%40physik.tu-muenchen.de&output=gplain

=cut

package Math::Combinatorics;

use strict;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw( combine permute factorial);
our $VERSION = '0.04';

=head1 EXPORTED FUNCTIONS

=head2 combine()

 Usage   : my @combinations = combine($k,@n);
 Function: implements nCk (n choose k), or n!/(k!*(n-k!)).
           returns all unique unorderd combinations of k items from set n.
           items in n are assumed to be character data, and are
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
 Notes   : data is internally assumed to be alphanumeric.  this is necessary
           to efficiently generate combinations of large sets.  if you need
           combinations of non-alphanumeric data, or on data
           C<sort {$a cmp $b}> would not be appropriate, use the
           object-oriented API.  See L</new()> and the B<compare> option.

=cut

sub combine {
  my($k,@n) = @_;

  my @result = ();

  my $c = __PACKAGE__->new(data => [@n], count => $k);
  while(my(@combo) = $c->next_combination){
    push @result, [@combo];
  }

  return @result;
}

=head2 permute()

 Usage   : my @permutations = permute(@n);
 Function: implements nPk (n permute k) (where k == n), or n!/(n-k)!
            returns all unique permutations of k items from set n
           (where n == k, see "Note" below).  items in n are assumed to
           be character data, and are copied into the return data
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
 Notes   : data is internally assumed to be alphanumeric.  this is necessary
           to efficiently generate combinations of large sets.  if you need
           combinations of non-alphanumeric data, or on data
           C<sort {$a cmp $b}> would not be appropriate, use the
           object-oriented API.  See L</new()>, and the B<compare> option.

=cut

sub permute {
  my(@n) = @_;

  my @result = ();

  my $c = __PACKAGE__->new(data => [@n]);
  while(my(@combo) = $c->next_permutation){
    push @result, [@combo];
  }

  return @result;
}

=head2 factorial()

 Usage   : my $f = factorial(4); #returns 24, or 4*3*2*1
 Function: calculates n! (n factorial).
 Returns : undef if n is non-integer or n < 0
 Args    : a positive, non-zero integer
 Note    : this function is used internally by combine() and permute()

=cut

sub factorial {
  my $n = shift;
  return undef unless $n >= 0 and $n == int($n);

  my $f;

  for($f = 1 ; $n > 0 ; $n--){
    $f *= $n
  }

  return $f;
}

=head1 CONSTRUCTOR

=cut

=head2 new()

 Usage   : my $c = Math::Combinatorics->new( count => 2,       #treated as int
                                             data => [1,2,3,4] #arrayref or anonymous array
                                           );
 Function: build a new Math::Combinatorics object.
 Returns : a Math::Combinatorics object
 Args    : count     - required for combinatoric functions/methods.  number of elements to be
                       present in returned set(s).
           data      - required for combinatoric B<AND> permutagenic functions/methods.  this is the
                       set elements are chosen from.  B<NOTE>: this array is modified in place; make
                       a copy of your array if the order matters in the caller's space.
           frequency - optional vector of data frequencies.  must be the same length as the B<data>
                       constructor argument.  These two constructor calls here are equivalent:

                         $a = 'a';
                         $b = 'b';

                         Math::Combinatorics->new( count=>2, data=>[\$a,\$a,\$a,\$a,\$a,\$b,\$b] );
                         Math::Combinatorics->new( count=>2, data=>[\$a,\$b], frequency=>[5,2] );

                       so why use this?  sometimes it's useful to have multiple identical entities in
                       a set (in set theory jargon, this is called a "bag", See L<Set::Bag>).
           compare   - optional subroutine reference used in sorting elements of the set.  examples:

                       #appropriate for character elements
                       compare => sub { $_[0] cmp $_[1] }               
                       #appropriate for numeric elements
                       compare => sub { $_[0] <=> $_[1] }
                       #appropriate for object elements, perhaps
                       compare => sub { $_[0]->value <=> $_[1]->value }

                     defaults to "sub { $_[0] cmp $_[1] }"

=cut

sub new {
  my($class,%arg) = @_;
  my $self = bless {}, $class;
  $self->{compare} = $arg{compare} || sub { $_[0] cmp $_[1] };
  $self->{count}   = $arg{count};

  #convert bag to set
  my $freq            = $arg{frequency};
  if(ref($freq) eq 'ARRAY' and scalar(@$freq) == scalar(@{$arg{data}})){
    my @bag = @{$arg{data}};
    my @set = ();

    while(my $type = shift @bag){
      my $f = shift @$freq;
      next if $f < 1;
      for(1..$f){
        push @set, $type;
      }
    }
    $arg{data} = \@set;
  }

  my $compare = $self->{compare};

  $self->{data}    = [sort {&$compare($a,$b)} @{$arg{data}}];

  $self->{cin} = 1;
  $self->{pin} = 1;

  return $self;
}

=head1 OBJECT METHODS

=cut

=head2 next_combination()

 Usage   : my @combo = $c->next_combination();
 Function: get combinations of size $count from @data.
 Returns : returns a combination of $count items from @data (see L</new()>).
           repeated calls retrieve all unique combinations of $count elements.
           a returned empty list signifies all combinations have been iterated.
 Args    : none.

=cut

sub next_combination {
  my $self = shift;
  my $data = $self->data();
  my $combo_end = $self->count();

  my $begin = 0;
  my $end = $#{$data} + 1;

  my @result;

  if($self->{cin}){
    $self->{cin} = 0;

    for(0..$self->count-1){
      push @result, $data->[$_];
    }
    return @result;
  }

  if ($combo_end == $begin || $combo_end == $end) {
    return ();
  }

  my $combo = $combo_end;
  my $total_set;

  --$combo;
  $total_set = $self->upper_bound($combo_end,$end,$data->[$combo]);
  if ($total_set != $end) {
    $self->swap($combo,$total_set);

    for(0..$self->count-1){
      push @result, $data->[$_];
    }
    return @result;
  }

  --$total_set;
  $combo = $self->lower_bound($begin, $combo_end, $data->[$total_set]);

  if ($combo == $begin) {
    $self->rotate($begin, $combo_end, $end);
    return ();
  }

  my $combo_next = $combo;
  --$combo;
  $total_set = $self->upper_bound($combo_end, $end, $data->[$combo]);

  my $sort_pos = $end;
  $sort_pos += $combo_end - $total_set - 1;

  $self->rotate($combo_next, $total_set, $end);
  $self->rotate($combo, $combo_next, $end);
  $self->rotate($combo_end, $sort_pos, $end);

#warn @$data;

  for(0..$self->count-1){
    push @result, $data->[$_];
  }
  return @result;
}

=head2 next_permutation()

 Usage   : my @permu = $c->next_permutation();
 Function: get permutations of elements in @data.
 Returns : returns a permutation of items from @data (see L</new()>).
           repeated calls retrieve all unique permutations of @data elements.
           a returned empty list signifies all permutations have been iterated.
 Args    : none.

=cut

sub next_permutation {
  my $self = shift;
  my $data = $self->data();

  if($self->{pin}){
    $self->{pin} = 0;
    return @$data;
  }

  my $cursor = $self->_permutation_cursor();

  my $last= $#{$cursor};

  if($last < 1){
    return ();
  }

  # Find last item not in reverse-sorted order:
  my $i = $last - 1;
  $i-- while  0 <= $i  &&  $cursor->[$i] >= $cursor->[$i+1];

  if($i == -1){
    return ();
  }


  # Re-sort the reversely-sorted tail of the list:
  @{$cursor}[$i+1..$last] = reverse @{$cursor}[$i+1..$last]
    if $cursor->[$i+1] > $cursor->[$last];

  # Find next item that will make us "greater":
  my $j = $i+1;
  $j++ while  $cursor->[$i] >= $cursor->[$j];

  # Swap:
  @{$cursor}[$i,$j] = @{$cursor}[$j,$i];

  # map cursor to data array
  my @result;
  foreach my $c (@$cursor){
    push @result, $data->[$c];
  }
  return @result;
}

=head1 INTERNAL FUNCTIONS AND METHODS

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

=head2 compare()

 Usage   : $obj->compare()
 Function: internal, undocumented.  holds a comparison coderef.
 Returns : value of compare (a coderef)


=cut

sub compare {
  my($self,$val) = @_;
  return $self->{'compare'};
}


=head2 count()

 Usage   : $obj->count()
 Function: internal, undocumented.  holds the "k" in nCk or nPk.
 Returns : value of count (an int)

=cut

sub count {
  my($self) = @_;
  return $self->{'count'};
}


=head2 data()

 Usage   : $obj->data()
 Function: internal, undocumented.  holds the set "n" in nCk or nPk.
 Returns : value of data (an arrayref)

=cut

sub data {
  my($self) = @_;
  return $self->{'data'};
}


=head2 swap()

internal, undocumented.

=cut

sub swap {
  my $self = shift;
  my $first = shift;
  my $second = shift;
  my $data = $self->data();

  my $temp = $data->[$first];
  $data->[$first] = $data->[$second];
  $data->[$second] = $temp;
}

=head2 reverse()

internal, undocumented.

=cut

sub reverse {
  my $self = shift;
  my $first = shift;
  my $last = shift;
  my $data = $self->data();

  while (1) {
    if ($first == $last || $first == --$last) {
      return;
    } else {
      $self->swap($first++, $last);
    }
  }
}

=head2 rotate()

internal, undocumented.

=cut

sub rotate {
  my $self = shift;
  my $first = shift;
  my $middle = shift;
  my $last = shift;
  my $data = $self->data();

  if ($first == $middle || $last == $middle) {
    return;
  }

  my $first2 = $middle;

  do {
    $self->swap($first++, $first2++);

    if ($first == $middle) {
      $middle = $first2;
    }
  } while ($first2 != $last);

  $first2 = $middle;

  while ($first2 != $last) {
    $self->swap($first++, $first2++);
    if ($first == $middle) {
      $middle = $first2;
    } elsif ($first2 == $last) {
      $first2 = $middle;
    }
  }
}

=head2 upper_bound()

internal, undocumented.

=cut

sub upper_bound {
  my $self = shift;
  my $first = shift;
  my $last = shift;
  my $value = shift;
  my $compare = $self->compare();
  my $data = $self->data();

  my $len = $last - $first;
  my $half;
  my $middle;

  while ($len > 0) {
    $half = $len >> 1;
    $middle = $first;
    $middle += $half;

    if (&$compare($value,$data->[$middle]) == -1) {
      $len = $half;
    } else {
      $first = $middle;
      ++$first;
      $len = $len - $half - 1;
    }
  }

  return $first;
}

=head2 lower_bound()

internal, undocumented.

=cut

sub lower_bound {
  my $self = shift;
  my $first = shift;
  my $last = shift;
  my $value = shift;
  my $compare = $self->compare();
  my $data = $self->data();

  my $len = $last - $first;
  my $half;
  my $middle;

  while ($len > 0) {
    $half = $len >> 1;
    $middle = $first;
    $middle += $half;

    if (&$compare($data->[$middle],$value) == -1) {
      $first = $middle;
      ++$first;
      $len = $len - $half - 1;
    } else {
      $len = $half;
    }
  }

  return $first;
}

=head2 _permutation_cursor()

 Usage   : $obj->_permutation_cursor()
 Function: internal method.  cursor on permutation iterator order.
 Returns : value of _permutation_cursor (an arrayref)
 Args    : none

=cut

sub _permutation_cursor {
  my($self,$val) = @_;

  if(!$self->{'_permutation_cursor'}){
    my $data = $self->data();
    my @tmp = ();
    my $i = 0;
    push @tmp, $i++ foreach @$data;
    $self->{'_permutation_cursor'} = \@tmp;
  }

  return $self->{'_permutation_cursor'};
}

1;
