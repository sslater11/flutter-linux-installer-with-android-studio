#!/bin/bash

# BSD 3-Clause License
# 
# Copyright (c) 2025, Simon Slater
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


android_backup_path=`mktemp -u -t Android.backup.XXXXXXX -p "$HOME/"`
flutter_backup_path=`mktemp -u -t flutter.backup.XXXXXXX -p "$HOME/"`


message_download_android_studio="Before running this, please download android studio ladybug from here\nhttps://developer.android.com/studio\nAnd then extract it to $HOME/android-studio-ladybug/\n\nPress enter when done and the script will setup flutter for android development"
whiptail --title "Information" --msgbox "$message_download_android_studio" 0 0
whiptail --title "Information" --msgbox "You will be asked to accept loads of licenses and it's all google's fault..." 0 0

if whiptail --title "Confirmation" --yesno "Warning: You are about to move files.\nBacking up old android($HOME/Android) to $android_backup_path\nDo you want to continue?" 0 0; then
    echo "User chose to continue."
else
    echo "User chose to cancel."
    exit
fi

echo "Backing up old android($HOME/Android) to $android_backup_path"
mv "$HOME/Android" "$android_backup_path"

echo "Creating new folder $HOME/Android"
mkdir -p "$HOME/Android/Sdk/"
cd "$HOME/Android/Sdk/"


echo "Downloading commandlinetools and extracting."
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip

# Create the cmdline-tools folder
# and also make a folder called 'latest' inside cmdline-tools, which is the exact same as cmdline-tools
unzip commandlinetools-linux-11076708_latest.zip
mkdir cmdline-tools/latest
unzip commandlinetools-linux-11076708_latest.zip -d cmdline-tools/latest
mv cmdline-tools/latest/cmdline-tools/* cmdline-tools/latest/ 
rm -rf cmdline-tools/latest/cmdline-tools/

cd cmdline-tools/bin

./sdkmanager --sdk_root="$HOME/Android/Sdk/" --install "build-tools;36.0.0-rc3"
./sdkmanager --sdk_root="$HOME/Android/Sdk/" --install "platforms;android-35"
./sdkmanager --sdk_root="$HOME/Android/Sdk/" --install "platform-tools"
./sdkmanager --sdk_root="$HOME/Android/Sdk/" --install "emulator"
./sdkmanager --sdk_root="$HOME/Android/Sdk/" --install "cmdline-tools;latest"
./sdkmanager --sdk_root="$HOME/Android/Sdk/" --licenses # Ask user to accept all licenses

cd ../../

if whiptail --title "Confirmation" --yesno "Warning: You are about to move files.\nBacking up old flutter($HOME/flutter) to $flutter_backup_path\nDo you want to continue?" 0 0; then
    echo "User chose to continue."
else
    echo "User chose to cancel."
    exit
fi
echo "Downloading flutter"
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz

echo
echo "Backing up old flutter($HOME/flutter) to $flutter_backup_path"
mv "$HOME/flutter" "$flutter_backup_path"
tar -v -x -f "flutter_linux_3.27.1-stable.tar.xz"
mv "flutter" "$HOME/"

cd "$HOME/flutter/bin"

./flutter --disable-analytics
./flutter config --android-sdk="$HOME/Android/Sdk"
./flutter config --android-studio-dir="$HOME/android-studio-ladybug/"


echo
echo
echo "--------------------"
echo "Please add flutter to your \$PATH variable to make it executable using the 'flutter' command."
echo "For bash shell type this command to add it to your bash path permanently."
echo "echo 'export PATH=\"\$HOME/flutter/bin:\$PATH\"' >> ~/.bash_profile"
echo
echo "or to add it for just this bash session"
echo 'export PATH="$HOME/flutter/bin:$PATH"'
echo
echo "For fish shell, type this command"
echo "fish_add_path -g -p \"\$HOME/flutter/bin/\""
echo
echo
echo "Finally run in a terminal the command"
echo "flutter doctor"
echo "or"
echo "$HOME/flutter/bin/flutter doctor"
echo
echo "for a more detailed output run"
echo "$HOME/flutter/bin/flutter doctor -v"
echo
echo "and hopefully it'll work for you :)"

#Other environment variable that may be useful to someone :).
## for bash shell paste this into the terminal.
#export PATH=$PATH:"$HOME/flutter/flutter/bin/"
#export PATH=$PATH:"$HOME/Android/Sdk/platform-tools"
#export PATH=$PATH:"$HOME/Android/Sdk/cmdline-tools/latest/bin/"
#export PATH=$PATH:"$HOME/Android/Sdk/build-tools/36.0.0-rc3/"
#export PATH=$PATH:"$HOME/Android/Sdk/emulator/bin64/"

## for fish shell paste this into the terminal.
#fish_add_path -g -p "$HOME/Android/Sdk/platform-tools"
#fish_add_path -g -p "$HOME/Android/Sdk/cmdline-tools/latest/bin/"
#fish_add_path -g -p "$HOME/Android/Sdk/build-tools/36.0.0-rc3/"
#fish_add_path -g -p "$HOME/Android/Sdk/emulator/bin64/"
