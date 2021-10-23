version='1.2.2'
target=root@$server:/home/nightmare/YanTool/resources/SpeedShare
if [ -f "速享_macOS.tar" ]; then
    rsync -v "速享_macOS.tar" "$target/速享_$version\_macOS.tar"
fi
if [ -f "速享_Windows.zip" ]; then
    rsync -v "速享_Windows.zip" "$target/速享_$version\_Windows.zip"
fi
#rsync -v build/app/outputs/apk/release/app-release.apk "$target/速享_$version\_Android_arm64.apk"
