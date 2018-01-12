package IrssiSpy::Logger;

use Moose;
use Irssi;

has 'prefix'    => ( is => 'ro' );
has 'log_level' => (
  is      => 'ro',
  default => 'debug',
);

sub error {
  my ($self, $message) = @_;
  $self->send('error', $message);
}

sub debug {
	my ($self, $message) = @_;
	if ($self->log_level eq 'debug') {
		$self->send('debug', $message);
	}
}

sub send {
  my ($self, $level, $message) = @_;
  Irssi::print($self->prefix . ': ' . $level . ' -- ' . $message);
}

1;
