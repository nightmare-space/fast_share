target=root@$server:/home/nightmare/YanTool/resources/AdbTool
if [ -f "AdbTool_macOS.tar" ]; then
    rsync -v AdbTool_macOS.tar $target/
fi
rsync -v build/app/outputs/apk/release/app-release.apk $target/AdbTool_android_arm64.apk