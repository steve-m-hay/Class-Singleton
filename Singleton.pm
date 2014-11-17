#============================================================================
#
# Class::Singleton.pm
#
# Implementation of a "singleton" module which ensures that a class has
# only one instance and provides global access to it.  For a description 
# of the Singleton class, see "Design Patterns", Gamma et al, Addison-
# Wesley, 1995, ISBN 0-201-63361-2
#
# Written by Andy Wardley <abw@cre.canon.co.uk>
#
# Copyright (C) 1998 Canon Research Centre Europe Ltd.  All Rights Reserved.
#
#----------------------------------------------------------------------------
#
# $Id: Singleton.pm,v 1.1 1998/02/10 09:40:40 abw Exp abw $
#
#============================================================================

package Class::Singleton;

require 5.004;

use strict;
use vars qw( $RCS_ID $VERSION );

$VERSION = sprintf("%d.%02d", q$Revision: 1.1 $ =~ /(\d+)\.(\d+)/);
$RCS_ID  = q$Id: Singleton.pm,v 1.1 1998/02/10 09:40:40 abw Exp abw $;



#========================================================================
#                      -----  PUBLIC METHODS -----
#========================================================================

#========================================================================
#
# instance()
#
# Module constructor.  Creates an Class::Singleton (or derivative) instance 
# if one doesn't already exist.  The instance reference is stored in the
# _instance variable of the $class package.  This means that classes 
# derived from Class::Singleton will have the variables defined in *THEIR*
# package, rather than the Class::Singleton package.  The impact of this is
# that you can create any number of classes derived from Class::Singleton
# and create a single instance of each one.  If the _instance variable
# was stored in the Class::Singleton package, you could only instantiate 
# *ONE* object of *ANY* class derived from Class::Singleton.
#
# Returns a reference to the existing, or a newly created Class::Singleton
# object.
#
#========================================================================

sub instance {
    my $self  = shift;
    my $class = ref($self) || $self;

    # get a reference to the _instance variable in the $class package 
    my $instance = $self->_instance_var();

    $self  = defined $$instance
	? $$instance
	: ($$instance = bless {}, $class);

    $self;
}



#========================================================================
#
# _instance_variable()
#
# Returns a reference to the instance variable, $_instance, in the 
# calling package.
#
#========================================================================

sub _instance_var {
    my $self = shift;
    my $class = ref($self) || $self;

    # return a reference to the '_instance' variable in $class package
    no strict 'refs';
    \${ "$class\::_instance" };
}


1;

__END__

=head1 NAME

Class::Singleton - Implementation of a "Singleton" class 

=head1 SYNOPSIS

    use Class::Singleton;

    my $one = Class::Singleton->instance();   # returns a new instance
    my $two = Class::Singleton->instance();   # returns same instance

=head1 DESCRIPTION

This is the Class::Singleton module.  A Singleton describes an object class
that can have only one instance in any system.  An example of a Singleton
might be a print spooler or system registry.  This module implements a
Singleton class from which other classes can be derived.  By itself, the
Class::Singleton module does very little other than manage the instantiation
of a single object.  In deriving a class from Class::Singleton, your module 
will inherit the Singleton instantiation method and can implement whatever
specific functionality is required.

For a description and discussion of the Singleton class, see 
"Design Patterns", Gamma et al, Addison-Wesley, 1995, ISBN 0-201-63361-2.

=head1 PREREQUISITES

Class::Singleton requires Perl version 5.004 or later.  If you have an older 
version of Perl, please upgrade to latest version.  Perl 5.004 is known 
to be stable and includes new features and bug fixes over previous
versions.  Perl itself is available from your nearest CPAN site (see
INSTALLATION below).

=head1 INSTALLATION

The Class::Singleton module is available from CPAN. As the 'perlmod' man
page explains:

    CPAN stands for the Comprehensive Perl Archive Network.
    This is a globally replicated collection of all known Perl
    materials, including hundreds of unbunded modules.

    [...]

    For an up-to-date listing of CPAN sites, see
    http://www.perl.com/perl/ or ftp://ftp.perl.com/perl/ .

The module is available in the following directories:

    /modules/by-module/Class/Class-Singleton-<version>.tar.gz
    /authors/id/ABW/Class-Singleton-<version>.tar.gz

For the latest information on Class-Singleton or to download the latest
pre-release/beta version of the module, consult the definitive reference:

    http://www.kfs.org/~abw/perl/

Class::Singleton is distributed as a single gzipped tar archive file:

    Class-Singleton-<version>.tar.gz

Note that "<version>" represents the current version number, of the 
form "1.23".  See L<REVISION> below to determine the current version 
number for Class::Singleton.

Unpack the archive to create an installation directory:

    gunzip Class-Singleton-<version>.tar.gz
    tar xvf Class-Singleton-<version>.tar

'cd' into that directory, make, test and install the module:

    cd Class-Singleton-<version>
    perl Makefile.PL
    make
    make test
    make install

The 'make install' will install the module on your system.  You may need 
root access to perform this task.  If you install the module in a local 
directory (for example, by executing "perl Makefile.PL LIB=~/lib" in the 
above - see C<perldoc MakeMaker> for full details), you will need to ensure 
that the PERL5LIB environment variable is set to include the location, or 
add a line to your scripts explicitly naming the library location:

    use lib '/local/path/to/lib';

=head1 USING THE CLASS::SINGLETON MODULE

To import and use the Class::Singleton module the following line should 
appear in your Perl script:

    use Class::Singleton;

The instance() method is used to create a new Class::Singleton instance, 
or return a reference to an existing instance.  Using this method, it
is only possible to have a single instance of the class in any system.

    my $highlander = Class::Singleton->instance();

Assuming that no Class::Singleton object currently exists, this first
call to instance() will create a new Class::Singleton and return a reference
to it.  Future invocations of instance() will return the same reference.

    my $macleod    = Class::Singleton->instance();

In the above example, both $highlander and $macleod contain the same
reference to a Class::Singleton instance.  There can be only one.

=head1 DERIVING SINGLETON CLASSES

A module class may be derived from Class::Singleton and will inherit the 
instance() method that correctly instantiates only one object.

    package PrintSpooler;
    use vars qw(@ISA);
    @ISA = qw(Class::Singleton);

    # derived class specific code
    sub submit_job {
        ...
    }

    sub cancel_job {
        ...
    }

The PrintSpooler class defined above could be used as follows:

    use PrintSpooler;

    my $spooler = PrintSpooler->instance();

    $spooler->submit_job(...);

The Class::Singleton instance() method uses a package variable to store a
reference to any existing instance of the object.  This variable, 
"_instance", is coerced into the derived class package rather than
the base class package.

Thus, in the PrintSpooler example above, the instance variable would
be:

    $PrintSpooler::_instance;

This allows different classes to be derived from Class::Singleton that 
can co-exist in the same system, while still allowing only one instance
of any one class to exists.  For example, it would be possible to 
derive both 'PrintSpooler' and 'Registry' from Class::Singleton and
have a single instance of I<each> in a system, rather than a single 
instance of I<either>.

Note that the _instance variable is considered private and is not intended
to be manipulated directly.  The _instance_var() method is provided for
derived classes to access the variable.  It returns a reference to the 
variable in the correct package.  When no previous instance of the class
exists, the value of the variable referenced will be undefined (undef).

Consider a case where a Singleton class requires some initialization 
process.  The initialization code should be executed one and only once
when the sole instance is created.  The Class::Singleton instance() method
can be overloaded in the following way to acheieve this.  Note the use of
_instance_var() to gain access to the instance variable, and the calling
of the base class instance() method to create the object instance.

    package PrintSpooler;
    use vars qw(@ISA);
    @ISA = qw(Class::Singleton);

    sub instance {
        my $self  = shift;
        my $class = ref($self) || $self;

        # get a reference to the instance variable
        my $instvar = #self->_instance_var();

        # see if an instance is defined
        if (defined($$instvar)) {
               $self = $$instvar;
	}
        else {
            # call base class instance() constructor
            $self = $self->SUPER::instance();

            # call any initialization code
            $self->initialize(@_);
        }
	
        return $self;
    }

By coercing the instance variable into the derived class package it is 
possible to have many classes derived from Class::Singleton that each 
can have one and only once instance.  However, there may be times when 
there should be only one instance of one or more derived classes.

Returning to the print spooler example, we know that only one print 
spooler can be defined in a system.  We may have defined a number of 
different print spoolers classes, any one of which can be instantiated 
and used.  From that point on, it should not be possible to create any
other PrintSpooler or derived class.  

This can be acheived by deriving all mutually exclusive classes from a 
common base class.  The base class instance() method should be overload
as follows:

    package PrintSpooler;
    use vars qw(@ISA);
    @ISA = qw(Class::Singleton);

    sub instance {
        my $self  = shift;
        my $class = ref($self) || $self;

        # create a temporary $self instance blessed into a 
        # common 'PrintSpooler' class 
        $self = bless {}, 'PrintSpooler';

        # all derived classes now look like a 'PrintSpooler'
        # when they call Class::Singleton->instance())
        $self = $self->SUPER::instance();

        # now bless returned instance into the required class
        bless $self, $class;
    }

Using this approach, only one instance of I<any> class derived from 
PrintSpooler will be instantiated.

    package PrintSpoolerOne;
    use vars qw(@ISA);
    @ISA = qw(PrintSpooler);

    package PrintSpoolerTwo;
    use vars qw(@ISA);
    @ISA = qw(PrintSpooler);

    package main;
    
    my $spooler1 = PrintSpoolerOne->instance();
    my $spooler2 = PrintSpoolerTwo->instance();

In the above code, both $spooler1 and $spooler2 will reference the same 
hash, although they will be blessed into their respective PrintSpoolerOne
and PrintSpoolerTwo classes.

=head1 AUTHOR

Andy Wardley, C<E<lt>abw@cre.canon.co.ukE<gt>>

SAS Group, Canon Research Centre Europe Ltd.

=head1 REVISION

$Revision: 1.1 $

=head1 COPYRIGHT

Copyright (C) 1998 Canon Research Centre Europe Ltd.  All Rights Reserved.

This module is free software; you can redistribute it and/or modify it under 
the term of the Perl Artistic License.

=head1 SEE ALSO

=over 4

=item Andy Wardley's Home Page

http://www.kfs.org/~abw/

=item The SAS Group Home Page

http://www.cre.canon.co.uk/sas.html

The research group at Canon Research Centre Europe responsible for 
development of Class::Singleton and similar tools.

=item Design Patterns

Class::Singleton is an implementation of the Singleton class described in 
"Design Patterns", Gamma et al, Addison-Wesley, 1995, ISBN 0-201-63361-2

=back

=cut