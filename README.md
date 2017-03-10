# Captive portal login script

Use this to login to networks using a "captive portal" (i.e. login page) semi-automatically. Currently the script only works on MacOS.


## Installation

Just download `captive_portal_login.sh`, then make it executable with `chmod`.


## Usage

```bash
./captive_portal_login.sh <SSID> <USERNAME> <PASSWORD>
```

Alternatively, you can edit `captive_portal_login.sh` and enter the SSID, username and password as the values for `$SSID`, `$USERNAME` and `$PASSWORD`. You can then select the Terminal app as the application to open the file and you will be able to login by just double-clicking it. (Just don't make ALL `.sh` files open in the Terminal app by default!)


## TODO

- Make requst more generic and remove extraneous params. The current request is copied from an actual login in Chrome.
- Make script fully automatic by polling network status. Right now a GET request is issued on each run to check internet connectivity, so that's gotta change.

