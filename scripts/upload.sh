version=
target=root@$server:/home/nightmare/YanTool/resources/SpeedShare
if [ -f "速享_macOS.tar" ]; then
    rsync -v 速享_macOS.tar $target/
fi
if [ -f "速享_Windows.zip" ]; then
    rsync -v 速享_Windows.zip $target/
fi
rsync -v build/app/outputs/apk/release/app-release.apk $target/速享_Android_arm64.apk
