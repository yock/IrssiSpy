use strict;
use vars qw($VERSION %IRSSI);
use Irssi;
use WWW::Curl::Easy;
use WWW::Curl::Share;
use WWW::Curl::Form;

$VERSION = '0.1';
%IRSSI = (
	authors => 'Michael Yockey',
	contact => 'mike@mikeyockey.com',
	url =>
		"https://mikeyockey.com",
	name => 'mailgun_notifier',
	description =>
		"Sends an email when you're mentioned.",
	license => 'MIT',
);

Irssi::settings_add_str('misc', $IRSSI{'name'} . '_base_url', 'https://api.mailgun.net/v3/');
Irssi::settings_add_str('misc', $IRSSI{'name'} . '_from_address', 'irssi@localhost');
Irssi::settings_add_str('misc', $IRSSI{'name'} . '_to_address', 'me@example.com');
Irssi::settings_add_str('misc', $IRSSI{'name'} . '_domain', 'mailgun.com');
Irssi::settings_add_str('misc', $IRSSI{'name'} . '_api_key', 'key-');
Irssi::settings_add_bool('misc', $IRSSI{'name'} . '_verbose', 0);

my $curl = new WWW::Curl::Easy;
my $curlsh = new WWW::Curl::Share;
$curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_COOKIE);
$curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_DNS);
$curl->setopt(CURLOPT_SHARE, $curlsh);

my $verbose = Irssi::settings_get_bool($IRSSI{'name'} . '_verbose');

sub set_curl_opts {
	my $url = Irssi::settings_get_str($IRSSI{'name'} . '_base_url')
						. Irssi::settings_get_str($IRSSI{'name'} . '_domain')
						. '/messages';
	$curl->setopt(CURLOPT_URL, $url);
	$curl->setopt(CURLOPT_USERPWD, 'api:' . Irssi::settings_get_str($IRSSI{'name'} . '_api_key'));
}

sub prepare_email {
	my $net = shift;
	my $target = shift;
	my $user = shift;
	my $curlf = new WWW::Curl::Form;
	$curlf->formadd("from", Irssi::settings_get_str($IRSSI{'name'} . '_from_address'));
	$curlf->formadd("to", Irssi::settings_get_str($IRSSI{'name'} . '_to_address'));
	$curlf->formadd("subject", "New mentions on " . ucfirst($net));
	$curlf->formadd("text", $user . ' mentioned you in ' . $target);
	return $curlf;
}

sub notify {
	my $form = shift;
	&set_curl_opts;
	my $response_body;
	$curl->setopt(CURLOPT_WRITEDATA,\$response_body);
	$curl->setopt(CURLOPT_HTTPPOST, $form);
	if ($curl->perform != 0) {
		Irssi::print($curl->errbuf);
	} elsif ($verbose) {
		Irssi::print('Mailgun API response');
		Irssi::print('HTTP status: ' . $curl->getinfo(CURLINFO_HTTP_CODE));
		Irssi::print($response_body);
	}
}

sub handle_pub {
	my ($server, $message, $user, $address, $target) = @_;
	$verbose = Irssi::settings_get_bool($IRSSI{'name'} . '_verbose');
	if (index($message, $server->{nick}) >= 0) {
		if ($verbose) {
			Irssi::print('I heard your name, so I will send you an email');
		}
		my $form = &prepare_email($server->{chatnet}, $target, $user);
		notify($form);
	}
}

Irssi::signal_add_last("message public", "handle_pub");
