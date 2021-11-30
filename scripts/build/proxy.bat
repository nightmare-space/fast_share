@echo off
@REM set http_proxy=http://127.0.0.1:10809
@REM set http_proxys=http://127.0.0.1:10809
set http_proxy=socks5://127.0.0.1:10808
set https_proxy=socks5://127.0.0.1:10808
git config --global http.proxy http://127.0.0.1:10809
git config --global https.proxy http://127.0.0.1:10809
git config --global http.postBuffer 5242880000
git config --global https.postBuffer 5242880000
git config --global --unset http.proxy
git config --global --unset https.proxy