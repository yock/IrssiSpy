use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

use IrssiSpy::IFTTTWebhook;
use IrssiSpy::Logger;

$VERSION = '0.2.0';
%IRSSI = (
	authors => 'Michael Yockey',
	contact => 'mike@mikeyockey.com',
	url =>
		"https://mikeyockey.com",
	name => 'IrssiSpy',
	description =>
		"A smart Irssi notification system.",
	license => 'MIT',
);

Irssi::settings_add_str('misc', $IRSSI{'name'} . '_api_url', 'https://maker.ifttt.com/trigger/');
Irssi::settings_add_str('misc', $IRSSI{'name'} . '_api_key', 'key-');

my $logger = new IrssiSpy::Logger(
	prefix => $IRSSI{'name'}
);

sub handle_pub {
	my ($server, $message, $user, $address, $target) = @_;
	if (index($message, $server->{nick}) >= 0) {
		$logger->debug('Sending notification');
		my $ifttt_webhook = IrssiSpy::IFTTTWebhook->new(
		api_url   	=> Irssi::settings_get_str($IRSSI{'name'} . '_api_url'),
		api_key   	=> Irssi::settings_get_str($IRSSI{'name'} . '_api_key'),
		logger			=> $logger,
		event_name	=> 'irssi',
		nick				=> $server->{nick},
		channel			=> $target,
	);
		$ifttt_webhook->trigger();
	}
}

sub test {
	my ($self, $message, $nick, $address, $target) = @_;
	$logger->debug('Testing webhook', 1);
	my $ifttt_webhook = IrssiSpy::IFTTTWebhook->new(
		api_url   	=> Irssi::settings_get_str($IRSSI{'name'} . '_api_url'),
		api_key   	=> Irssi::settings_get_str($IRSSI{'name'} . '_api_key'),
		logger			=> $logger,
		event_name	=> 'irssi',
		nick				=> $nick,
		channel			=> $target,
	);
	$ifttt_webhook->trigger();
}

Irssi::signal_add_last("message public", "handle_pub");
Irssi::signal_add_last("message own_private", "test");
