package IrssiSpy::IFTTTWebhook;

use Moose;
use HTTP::Tiny;
use JSON;
use URI;
use IrssiSpy::Notification;

has 'api_url'       => ( is => 'rw' );
has 'api_key'       => ( is => 'rw' );
has 'logger'        => ( is => 'ro' );

has 'http' => (
  is => 'ro',
  default => sub {
    new HTTP::Tiny(
      default_headers => {
        'Content-Type' => 'application/json'
      }
    )
  }
);

sub trigger {
  my ($self, $event_name, $notification) = @_;
  my $uri_path = $event_name . '/with/key/' . $self->api_key;
  my $uri = URI->new($uri_path)->abs($self->api_url);
  my $json = encode_json {
    value1  => $notification->name,
    value2  => $notification->location,
    value3  => $notification->network,
  };
  $self->logger->debug($uri);
  $self->logger->debug($json);
  my $response = $self->http->post($uri => { content => $json });
  if ($response->{'is_success'}) {
    return decode_json $response->{'content'};
  } else {
    $self->logger->error($response->{'reason'});
    $self->logger->debug($response->{'content'});
  }
}

1;
