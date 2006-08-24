package Slim::Control::Command;

# SlimServer Copyright (C) 2001-2006 Sean Adams, Slim Devices Inc.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License,
# version 2.

=head1 NAME

Slim::Buttons::Command

=head1 DESCRIPTION

L<Slim::Buttons::Command>
 Legacy support for Command Line Interface.  Please use Request.pm class for new work.
 
=cut

use strict;

use Slim::Control::Request;
use Slim::Utils::Misc qw(msg errorMsg);

our %executeCallbacks = ();

=head1 METHODS

=head2 execute( $client, $parrayref, $callback, @callbackargs )

 execute - did all the hard work, thanks. 
 PLEASE USE THE REQUEST.PM CLASS
 takes:
   a client reference
   a reference to an array of parameters
   a reference to a callback function
   a list of callback function args

 returns an array containing the given parameters

=cut

sub execute {

	return Slim::Control::Request::executeLegacy(@_);
}

sub setExecuteCallback {
	my $callbackRef = shift;
	
	$executeCallbacks{$callbackRef} = $callbackRef;
	
	# Let Request know if it needs to call us
	Slim::Control::Request::needToCallExecuteCallback(scalar(keys %executeCallbacks));
	
	# warn about deprecated call
	errorMsg("Slim::Control::Command::setExecuteCallback() has been deprecated!");
	errorMsg("Please use Slim::Control::Request::subscribe() instead!");
	errorMsg("Documentation is available in Slim::Control::Request.pm\n");
}

sub clearExecuteCallback {
	my $callbackRef = shift;
	
	delete $executeCallbacks{$callbackRef};
	
	# Let Request know if it needs to call us
	Slim::Control::Request::needToCallExecuteCallback(scalar(keys %executeCallbacks));
	
	# warn about deprecated call
	errorMsg("Slim::Control::Command::clearExecuteCallback() has been deprecated!");
	errorMsg("Please use Slim::Control::Request::unsubscribe() instead!");
	errorMsg("Documentation is available in Slim::Control::Request.pm\n");
}

sub executeCallback {
	my $client = shift;
	my $paramsRef = shift;
	my $dontcallDispatch = shift;

#	$::d_command && msg("Command: executeCallback()\n");

	no strict 'refs';
		
	for my $executecallback (keys %executeCallbacks) {
		$executecallback = $executeCallbacks{$executecallback};
		&$executecallback($client, $paramsRef);
	}
	
	# make sure we inform Request not to call us again by defining the third
	# parameter. Request does the same for us, so we avoid an infinite loop.
	Slim::Control::Request::notifyFromArray($client, $paramsRef, "no no no") 
		if !defined $dontcallDispatch;
}

=head1 SEE ALSO

L<Slim::Control::Request.pm>

=cut

1;
