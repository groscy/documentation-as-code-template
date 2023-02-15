cd bin
git clone https://github.com/structurizr/cli.git
cd cli
git checkout v1.20.0
call .\gradlew.bat
echo Setup CLI in /bin/structurizr-cli
rmdir ..\structurizr-cli /s /q
mkdir ..\structurizr-cli
tar -xpf build\distributions\structurizr-cli-1.20.0.zip -C ..\structurizr-cli
cd ..\..
echo Done