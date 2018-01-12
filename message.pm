package IrssiSpy::Message;
use Moose;

has 'notifications' => (
  is => 'ro',
  isa => 'ArrayRef[Notification]'
  required=> 1
);

sub body {
  return "New notifications on IRC";
}
