package IrssiSpy::Notification;

use Time::Piece;
use Moose;

has 'network'     => ( is => 'ro' );
has 'location'    => ( is => 'ro' );
has 'name'        => ( is => 'ro' );

1;
