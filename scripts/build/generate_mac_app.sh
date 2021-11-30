flutter build macos
rm -rf ./build/macos/Build/Products/Release/移动到这
ln -s -f /Applications ./build/macos/Build/Products/Release/移动到这
tar -zcvf ./速享_macOS.tar  -C ./build/macos/Build/Products/  "Release/速享.app/" Release/移动到这
rm -rf ./build/macos/Build/Products/Release/移动到这