#!/bin/bash

# 更新と依存パッケージのインストール
echo "システムを更新中..."
sudo apt update
sudo apt install -y curl unzip openjdk-17-jdk

# Flutter SDK のインストール
echo "Flutter SDKをインストール中..."
FLUTTER_DIR="$HOME/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_DIR
else
  echo "Flutter SDKは既にインストールされています。"
fi

# Flutterのパス設定
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
flutter doctor

# Android SDK コマンドラインツールのインストール
echo "Android SDK コマンドラインツールをインストール中..."
ANDROID_SDK_DIR="$HOME/android"
CMDLINE_TOOLS_DIR="$ANDROID_SDK_DIR/cmdline-tools"
if [ ! -d "$CMDLINE_TOOLS_DIR" ]; then
  mkdir -p $CMDLINE_TOOLS_DIR
  curl -L https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -o commandlinetools.zip
  unzip commandlinetools.zip -d $CMDLINE_TOOLS_DIR
  mv $CMDLINE_TOOLS_DIR/cmdline-tools $CMDLINE_TOOLS_DIR/latest
  rm commandlinetools.zip
else
  echo "Android SDK コマンドラインツールは既にインストールされています。"
fi

# Android SDKのパス設定
echo 'export ANDROID_SDK_ROOT="$HOME/android"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator"' >> ~/.bashrc
source ~/.bashrc

# 必要なAndroidモジュールのインストール
echo "必要なAndroid SDKモジュールをインストール中..."
sdkmanager --install "platform-tools" "emulator" "platforms;android-30" "build-tools;30.0.3" "system-images;android-30;default;x86_64"

# エミュレーターの作成
echo "エミュレーターを作成中..."
avdmanager create avd --name android30 --device "pixel" --package "system-images;android-30;default;x86_64" --force

# Android SDKライセンスへの同意
echo "Android SDKライセンスに同意します..."
yes | flutter doctor --android-licenses

# インストール完了メッセージ
echo "FlutterおよびAndroidエミュレーターのインストールが完了しました。"
echo "環境変数が適用されるように、端末を再起動するか、以下のコマンドを実行してください:"
echo "source ~/.bashrc"
