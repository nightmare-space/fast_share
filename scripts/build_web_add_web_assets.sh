./scripts/build_web.sh
rm -rf assets/web.zip
cd ./build/web/
zip -r ../../assets/web.zip ./*