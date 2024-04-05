#!/bin/bash

# Clone eclipse.jdt.ls
git clone https://github.com/eclipse/eclipse.jdt.ls ~/dev/eclipse/eclipse.jdt.ls

# Build eclipse.jdt.ls
cd ~/dev/eclipse/eclipse.jdt.ls || exit
 ./mvnw clean install -DskipTests 

# Clone java-debug
git clone https://github.com/microsoft/java-debug ~/dev/microsoft/java-debug

# Build java-debug
cd ~/dev/microsoft/java-debug || exit
./mvnw clean install 

# Clone vscode-java-test
git clone https://github.com/microsoft/vscode-java-test ~/dev/microsoft/vscode-java-test

# Build vscode-java-test
cd ~/dev/microsoft/vscode-java-test || exit
git clean -xdff
npm install
npm run build-plugin

# Create apps folder
mkdir -p ~/apps/

# Create async-profiler folder
mkdir -p ~/apps/async-profiler/

# Fetch sjk.jar
wget -O ~/apps/sjk.jar "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=org.gridkit.jvmtool&a=sjk&v=LATEST"

# Get and unpack async-profiler
wget -O /tmp/async-profiler.tar.gz "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v1.8/async-profiler-1.8-linux-x64.tar.gz"
tar -xzf /tmp/async-profiler.tar.gz -C ~/apps/async-profiler/ --strip-components=1
rm /tmp/async-profiler.tar.gz

# Create jmc folder
mkdir -p ~/apps/jmc/

# Get and unpack jmc
wget -O /tmp/jmc.tar.gz "https://download.java.net/java/GA/jmc8/05/binaries/jmc-8.3.1_linux-x64.tar.gz"
tar -xzf /tmp/jmc.tar.gz -C ~/apps/jmc/ --strip-components=1
rm /tmp/jmc.tar.gz

# Create symlink for jmc
ln -sf ~/apps/jmc/*/jmc ~/.local/bin/jmc

# Clone vscode-java-decompiler
git clone https://github.com/dgileadi/vscode-java-decompiler ~/dev/dgileadi/vscode-java-decompiler

