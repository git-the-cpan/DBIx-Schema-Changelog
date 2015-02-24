# ABSTRACT: A gentle introduction to DBIx::Schema::Changelog
package DBIx::Schema::Changelog::Manual;

=head1 VERSION

Version 0.1.0

=cut

our $VERSION = '0.1.0';

__END__

=pod

=head1 NAME

	DBIx::Schema::Changelog::Manual - A gentle introduction to DBIx::Schema::Changelog

=head1 DESCRIPTION

	Continuous Database Migration
	Package to databases in sync with the development of the application to keep.

=encoding utf8

=head1 INSTALL

Installation of DBIx::Schema::Changelog is simple:

    perl -MCPAN -e 'install DBIx::Schema::Changelog'

Thanks to the magic of cpanminus, if you do not have CPAN.pm configured, or just
want a quickfire way to get running, the following should work, at least on
Unix-like systems:

    wget -O - http://cpanmin.us | sudo perl - DBIx::Schema::Changelog

(If you don't have root access, omit the 'sudo', and cpanminus will install
DBIx::Schema::Changelog and prereqs into C<~/perl5>.)

=head1 MAIN CHANGELOG

=head2 Implemnt Subchangelog files

=head2 Define Template

=head1 SUBCHANGELOG FILES

=head2 Create Table

=head2 Alter Table

=head2 Create Views

=head2 Create Indexes

=head1 AUTHOR

Mario Zieschang, C<< <mario.zieschang at combase.de> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Mario Zieschang.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut
