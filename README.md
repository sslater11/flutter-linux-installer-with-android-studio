# flutter-linux-installer-with-android-studio
This script will install Flutter locally, download the Android SDK, and configure everything.

I kept getting errors where running `flutter doctor`. It couldn't find the correct SDK location and it took me ages to figure out why, so I wrote this script.

# Warning
Script will backup your folders `$HOME/Android` and `$HOME/flutter`. It will then download Android SDK tools and Flutter, Saving them to `$HOME/Android` and `$HOME/flutter`.

# Usage
Read through the install guide and install all dependencies for flutter
https://docs.flutter.dev/get-started/install/linux/android

Then download this script which will download the Android SDK and flutter for you.

## Open a terminal and paste these lines to run the script.
```
wget "https://raw.githubusercontent.com/sslater11/flutter-linux-installer-with-android-studio/refs/heads/main/flutter_my_install.sh"
chmod +x flutter_my_install.sh
./flutter_my_install.sh
```


# Before running
Before running, you do need to download android studio ladybug and extract it to $HOME/android-studio-ladybug/

# Copyright / License
BSD 3-Clause License
