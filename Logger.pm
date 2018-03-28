package IrssiSpy::Logger;

use Moose;
use Irssi;

has 'prefix'    => ( is => 'ro' );
has 'log_level' => ( is => 'rw' );

sub error {
  my ($self, $message) = @_;
  $self->send('error', $message);
}

sub debug {
	my ($self, $message) = @_;
	if ($self->log_level >= 1) {
		$self->send('debug', $message);
	}
}

sub verbose {
  my ($self, $message) = @_;
	if ($self->log_level >= 2) {
		$self->send('debug', $message);
	}
}

sub send {
  my ($self, $level, $message) = @_;
  Irssi::print($self->prefix . ': ' . $level . ' -- ' . $message);
}

1;
