flutter build web --web-renderer html
# flutter build web --web-renderer canvaskit --release
cp -f ./scripts/index.html ./build/web/
rm -r ./build/web/canvaskit