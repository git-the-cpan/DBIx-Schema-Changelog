DBIx-Schema-Changelog - Continuous Database Migration 

[![Build Status](https://travis-ci.org/mziescha/DBIx-Schema-Changelog.svg?branch=master)](https://travis-ci.org/mziescha/DBIx-Schema-Changelog)
[![Coverage Status](https://coveralls.io/repos/mziescha/DBIx-Schema-Changelog/badge.svg)](https://coveralls.io/r/mziescha/DBIx-Schema-Changelog)

A package which allows a continuous development with an application that hold the appropriate database system synchronously.

MOTIVATION

When working with several people on a large project that is bound to a database.
If you there and back the databases have different levels of development.

You can keep in sync with SQL statements, but these are then incompatible with other database systems.

INSTALLATION

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc DBIx::Schema::Changelog

You can also look for information at:

    RT, CPAN's request tracker (report bugs here)
        http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBIx-Schema-Changelog

    AnnoCPAN, Annotated CPAN documentation
        http://annocpan.org/dist/DBIx-Schema-Changelog

    CPAN Ratings
        http://cpanratings.perl.org/d/DBIx-Schema-Changelog

    Search CPAN
        http://search.cpan.org/dist/DBIx-Schema-Changelog/


LICENSE AND COPYRIGHT

Copyright (C) 2015 Mario Zieschang

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

http://www.perlfoundation.org/artistic_license_2_0

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, trade name, or logo of the Copyright Holder.

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
THE IMPLIED WARRANTIES OF MERCHANT ABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

