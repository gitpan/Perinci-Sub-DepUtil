package Perinci::Sub::DepUtil;

use 5.010001;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       declare_function_dep
               );

our $VERSION = '0.02'; # VERSION

sub declare_function_dep {
    my %args    = @_;
    my $name    = $args{name}   or die "Please specify dep's name";
    my $schema  = $args{schema} or die "Please specify dep's schema";
    my $check   = $args{check};

    $name =~ /\A\w+\z/
        or die "Invalid syntax on dep's name, please use alphanums only";

    require Sah::Schema::Rinci;

    my $sch = $Sah::Schema::Rinci::SCHEMAS{rinci_function}
        or die "BUG: Schema structure changed (1)";
    my $props = $sch->[1]{_prop}
        or die "BUG: Schema structure changed (2)";
    $props->{deps}{_prop}{$name}
        and die "Dep clause '$name' already defined in schema";
    $props->{deps}{_prop}{$name} = {}; # XXX inject $schema somewhere?

    if ($check) {
        require Perinci::Sub::DepChecker;
        no strict 'refs';
        *{"Perinci::Sub::DepChecker::checkdep_$name"} = $check;
    }
}

1;
# ABSTRACT: Utility routines for Perinci::Sub::Dep::* modules

__END__

=pod

=encoding UTF-8

=head1 NAME

Perinci::Sub::DepUtil - Utility routines for Perinci::Sub::Dep::* modules

=head1 VERSION

version 0.02

=head1 RELEASE DATE

2014-04-27

=head1 SYNOPSIS

=head1 FUNCTIONS

=head2 declare_function_dep

=head1 SEE ALSO

L<Perinci>

Perinci::Sub::Dep::* modules.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Perinci-Sub-DepUtil>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Perinci-Sub-DepUtil>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Perinci-Sub-DepUtil>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
