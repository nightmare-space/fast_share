@echo off
@REM flutter clean
echo a
@REM flutter build windows
echo b
xcopy .\res\windows\runtime .\build\windows\runner\Release /s /f
Compress-Archive -Path .\build\windows\runner\Release\* -DestinationPath "windows.zip"