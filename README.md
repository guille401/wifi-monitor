
A simple ruby script that parse airodump-ng captures (csv) and send telegram messages when new devices are found.

# Wifi-monitor

Date: 2020-05

Author: Guillermo Fernandez

## Overview
 
This is a simple ruby script thought to be run with an airodump-ng csv capture file. It compares the data against a known hosts csv file and alerts via telegram when a new device is detected.

Currently information provided in the Telegram message: 

* Client MAC address
* Client BSSID if connected
* Access Point Location. Correlates against a known aps csv file
* Device vendor. Use https://api.macvendors.com/ to resolve device vendor via MAC address

## Prerequisites / Installation

Before you use this, you will need to follow the following instructions:

- Create a new Telegram bot [Telegram Bot](https://core.telegram.org/bots).
- Download and install [Ruby](https://www.ruby-lang.org/en/).
- Install TelegramBot gem: 
```bash
$ gem install telegram_bot
```
- Download and install aircrack-ng suite [Aircrack-ng](https://www.aircrack-ng.org/doku.php?id=install_aircrack)
- A wifi network interface with monitor mode capabilities is recommended. However, the script can be feed by the capture file.


## Release Notes
 
### Version 1.0

* Initial Release
  
 
### Support / Features
 
This utility has limited support.  If you have any issues, bugs, or feature requests, please send them to <6uillermo.fernandez@gmail.com>.
 
 
## Configuration
 
The configuration of the tool are all in `config.json` and looks like this:




## Execution

Run airodump-ng:
```bash
$ airodump-ng wlan1mon -w /home/pi/airodumpCapture --write-interval 30 --output-format csv
```

To run or execute the Wifi Monitor script, simply run the script using this command: `./wifi-monitor.rb`
The script is thouight to run in schedulled manner using 

