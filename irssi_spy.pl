use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

use IrssiSpy::IFTTTWebhook;
use IrssiSpy::Logger;
use IrssiSpy::Notification;

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
Irssi::settings_add_int('misc', $IRSSI{'name'} . '_log_level', 1);

my $logger = IrssiSpy::Logger->new(
	prefix		=> $IRSSI{'name'},
	log_level	=> Irssi::settings_get_int($IRSSI{'name'} . '_log_level'),
);

my $ifttt_webhook = IrssiSpy::IFTTTWebhook->new(
	api_url   	=> Irssi::settings_get_str($IRSSI{'name'} . '_api_url'),
	api_key   	=> Irssi::settings_get_str($IRSSI{'name'} . '_api_key'),
	logger			=> $logger,
	event_name	=> 'irssi',
);

sub handle_pub {
	my ($server, $message, $user, $address, $target) = @_;
	if (index($message, $server->{nick}) != -1) {
		my $notification = new IrssiSpy::Notification(
			network		=> $address,
			location	=> $target,
			name			=> $user,
		);
		$ifttt_webhook->trigger($notification);
	}
}

sub update_config {
	$logger->log_level(Irssi::settings_get_int($IRSSI{'name'} . '_log_level'));
	$ifttt_webhook->api_url(Irssi::settings_get_str($IRSSI{'name'} . '_api_url'));
	$ifttt_webhook->api_key(Irssi::settings_get_str($IRSSI{'name'} . '_api_key'));
}

Irssi::signal_add_last("message public", "handle_pub");
Irssi::signal_add_last("setup reread", "update_config");
