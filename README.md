
# Wifi-monitor

Date: 2020-05

Author: Guillermo Fernandez

## Overview
 
This is a simple ruby script thought to be run with an airodump-ng csv capture file. It compares the data against a known hosts csv file and alerts via telegram when a new device is detected.

Information provided in the Telegram message: 

* Client MAC address
* Client BSSID if connected
* Access Point Location. Correlates against a known aps csv file
* Device vendor. Uses https://api.macvendors.com/ to resolve device vendor via MAC address

## Prerequisites / Installation

Before you use this, you will need to follow the following instructions:

- Create a new Telegram bot [Telegram Bot](https://core.telegram.org/bots).
- Download and install [Ruby](https://www.ruby-lang.org/en/).
- Install TelegramBot gem: 
```bash
$ gem install telegram_bot
```
- Download and install aircrack-ng suite [Aircrack-ng](https://www.aircrack-ng.org/doku.php?id=install_aircrack)
- A wifi network interface with monitor mode capabilities is recommended. However, the script can be feed by the capture file, so NIC is not mandatory.


## Release Notes
 
### Version 1.0

* Initial Release
  
 
### Support / Features
 
This utility has limited support.  If you have any issues, bugs, or feature requests, please send them to <6uillermo.fernandez@gmail.com>.
 
 
## Configuration
 
The configuration of the tool are all in `config.json` and looks like this:

```json
{
  "defaults": {
    "airodump_capture": "airodumpCapture-01.csv",
    "know_hosts": "known_hosts.csv",
	   "known_aps": "known_aps.csv"
  },
  "session": {
    "token": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  }
}
```
In this configuration the following configuration values are as follows:

- `airodump_capture` - This is the input file path.
- `know_hosts` - This is the known clients file path. This file will be filled by the script in the first run. The script will compare new devices against this file
- `known_aps` - This is the known access point file path. This file will host the known network locations. For example, you can map your home access point MAC with any tag (like HOME)
- `token` - Telegram bot access token

## Execution

Run airodump-ng:
```bash
$ airodump-ng wlan1mon -w airodumpCapture --write-interval 30 --output-format csv
```
To run or execute the Wifi Monitor script, simply run the script using this command: `./wifi-monitor.rb`


