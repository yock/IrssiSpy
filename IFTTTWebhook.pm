package IrssiSpy::IFTTTWebhook;

use Moose;
use HTTP::Tiny;
use JSON;
use URI;

has 'api_url'     => ( is => 'ro' );
has 'api_key'     => ( is => 'ro' );
has 'logger'      => ( is => 'ro' );
has 'event_name'  => ( is => 'ro' );
has 'nick'        => ( is => 'ro' );
has 'channel'     => ( is => 'ro' );

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
  my ($self) = @_;
  my $uri_path = $self->event_name . '/with/key/' . $self->api_key;
  my $uri = URI->new($uri_path)->abs($self->api_url);
  my $json = encode_json {
    value1 => $self->nick,
    value2 => $self->channel,
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
