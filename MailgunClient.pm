package IrssiSpy::MailgunClient;
use Moose;
use WWW::Curl::Easy;
use WWW::Curl::Share;
use WWW::Curl::Form;

has 'api_key'       => ( is => 'ro' );
has 'from_address'  => ( is => 'rw' );
has 'domain'        => ( is => 'ro' );

has 'base_url' => (
  is => 'ro',
  default => 'https://api.mailgun.net/v3/'
);
has 'curl' => (
  is => 'ro',
  default => new WWW::Curl::Easy
);

sub send {
  my $self, $to_address, $message = @_;
	my $curlf = new WWW::Curl::Form;
	$curlf->formadd("from", $self->from_address));
	$curlf->formadd("to", $to_address);
	$curlf->formadd("subject", "New mentions on IRC");
	$curlf->formadd("text", $message->body);
	return _send_email($curlf);
}

sub _send_email {
  my $self, $form = @_;
  my $response_body;
  my $response = {};
  $self->curl->setopt(CURLOPT_WRITEDATA, $response_body);
  $self->curl->setopt(CURLOPT_HTTPPOST, $form);
  if ($self->curl->perform != 0) {
    $response->error($self->curl->errbuf);
  }
  $response->status($self->curl->getinfo(CURLINFO_HTTP_CODE));
  $response->body($response_body);
  return $response;
}

after 'new' => sub {
  my $self = shift;
  my $url = $self->base_url . $self->domain . '/messages';
  my $curlsh = new WWW::Curl::Share;
	$self->curl->setopt(CURLOPT_URL, $url);
	$self->curl->setopt(CURLOPT_USERPWD, 'api:' . $self->api_key);
  $curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_COOKIE);
  $curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_DNS);
  $curl->setopt(CURLOPT_SHARE, $curlsh);
}
