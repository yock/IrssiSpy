# Irssi Spy

Notification system for Irssi using the IFTTT Maker service.

## Setup

First, make sure you have enabled both the [Maker service][maker_service] and the [Notifications service][notifications_service] on IFTTT. 

## Settings

All settings for this script are stored in Irssi's `misc` section and will be re-
evaluated each run. You can make settings changes with Irssi's `/set` command from
any tab. For example, to set your api key:

    /set IrssiSpy_api_key key-longstringofstuff

Take care to not accidentally share your API key. I suggest making settings changes on the server tab.

| Key                           | Default value                    | Description
| ----------------------------- | -------------------------------- | -----------
| IrssiSpy_api_url              | https://maker.ifttt.com/trigger/ | URL for the IFTTT Maker service. |
| IrssiSpy_api_key              | key-                             | API key for the IFTTT Maker service. You can find it [here][ifttt_maker_settings] |

[maker_service]: https://ifttt.com/maker_webhooks
[notifications_service]: https://ifttt.com/if_notifications
[ifttt_maker_settings]: https://ifttt.com/services/maker_webhooks/settings
