package Slim::Plugin::Queen::Plugin;

# $Id$

use strict;
use base qw(Slim::Plugin::OPMLBased);

use Slim::Plugin::Queen::ProtocolHandler;

sub initPlugin {
	my $class = shift;
	
	Slim::Player::ProtocolHandlers->registerHandler(
		queen => 'Slim::Plugin::Queen::ProtocolHandler'
	);

	$class->SUPER::initPlugin(
		feed   => Slim::Networking::SqueezeNetwork->url( '/api/queen/v1/opml' ),
		tag    => 'queen',
		is_app => 1,
	);
}

# Don't add this item to any menu
sub playerMenu { }

1;
