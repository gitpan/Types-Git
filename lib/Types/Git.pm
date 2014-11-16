package Types::Git;
$Types::Git::VERSION = '0.01';
=head1 NAME

Types::Git - Type::Tiny types for git stuff.

=head1 SYNOPSIS

  package Foo;
  
  use Types::Git -types;
  
  use Moo;
  use strictures 1;
  use namespace::clean;
  
  has ref => (
    is  => 'ro',
    isa => GitRef,
  );

=head1 DESCRIPTION

This module provides several (well, one, currently) L<Type::Tiny>
types for several of git's data types.

=cut

use Type::Library -base;
use Type::Utils -all;
use Types::Common::String -types;
use List::MoreUtils qw( any );

use strictures 1;
use namespace::clean;

=head1 TYPES

=head2 GitRef

Matches a ref against the same rules that
L<git-check-ref-format|http://git-scm.com/docs/git-check-ref-format> uses.

=cut

my $GitRef = declare 'GitRef',
    as NonEmptySimpleStr,
    where {
        # 1. They can include slash / for hierarchical (directory) grouping,
        #    but no slash-separated component can begin with a dot . or end
        #    with the sequence .lock.
        ( ! any { $_ =~ m{^\.} or $_ =~ m{\.lock$} } split(/\//, $_) ) and
        # 2. They must contain at least one /.
        $_ =~ m{/} and
        # 3. They cannot have two consecutive dots .. anywhere.
        $_ !~ m{\.\.} and
        # 4. They cannot have ASCII control characters (i.e. bytes whose
        #    values are lower than \040, or \177 DEL), space, tilde ~, caret
        #    ^, or colon : anywhere.
        $_ !~ m{[\000-\040\177 ~^:]} and
        # 5. They cannot have question-mark ?, asterisk *, or open bracket [
        #    anywhere.
        $_ !~ m{[?*[]} and
        # 6. They cannot begin or end with a slash / or contain multiple
        #    consecutive slashes.
        $_ !~ m{^/} and $_ !~ m{/$} and $_ !~ m{//} and
        # 7. They cannot end with a dot ..
        $_ !~ m{\.$} and
        # 8. They cannot contain a sequence @{.
        $_ !~ m{\@\{} and
        # 9. They cannot be the single character @.
        $_ ne '@' and
        # 10. They cannot contain a \.
        $_ !~ m{\\}
    };

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@gmail.com>

=head1 ACKNOWLEDGEMENTS

Thanks to L<ZipRecruiter|https://www.ziprecruiter.com/>
for encouraging their employees to contribute back to the open
source ecosystem.  Without their dedication to quality software
development this distribution would not exist.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

