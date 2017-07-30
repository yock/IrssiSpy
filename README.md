# Irssi Mailgun Notifier

Watches for public mentions of your nick and sends notifications emails via Mailgun.

## Settings

All settings for this script are stored in Irssi's `misc` section and will be re-
evaluated each run. You can make settings changes with Irssi's `/set` command from
any tab. For example, to set your api key:

    /set mailgun_notifier_api_key key-longstringofstuff

Take care to not accidentally share your Mailgun API key. I suggest making settings
changes on the server tab.

| Key                           | Default value               | Description
| ----------------------------- | --------------------------- | -----------
| mailgun_notifier_base_url     | https://api.mailgun.net/v3/ | Prefix for your domain-specific API endpoint. You probably don't need to change this. |
| mailgun_notifier_from_address | irssi@localhost             | Sender address for notification email.
| mailgun_notifier_to_address   | me@example.com              | Address to which notifications will be sent.
| mailgun_notifier_domain       | mailgun.com                 | Your Mailgun sender domain.
| mailgun_notifier_api_key      | key-                        | Your Mailgun API key.
| mailgun_notifier_verbose      | 0                           | Whether or not some debugging messages will be printed to Irssi's server tab.
