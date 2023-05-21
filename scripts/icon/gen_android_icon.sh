logo=ic_launcher.png
mkdir -p mipmap-hdpi
mkdir -p mipmap-mdpi
mkdir -p mipmap-xhdpi
mkdir -p mipmap-xxhdpi
mkdir -p mipmap-xxxhdpi
sips -z 72 72 $logo --out mipmap-hdpi/ic_launcher.png
sips -z 48 48 $logo --out mipmap-mdpi/ic_launcher.png
sips -z 96 96 $logo --out mipmap-xhdpi/ic_launcher.png
sips -z 144 144 $logo --out mipmap-xxhdpi/ic_launcher.png
sips -z 192 192 $logo --out mipmap-xxxhdpi/ic_launcher.png