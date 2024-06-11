#!/bin/bash

jdtlsdir="dev"
appdir="apps"

for tool in git wget npm mvnw; do
  if ! command -v $tool &> /dev/null; then
    echo "$tool is not installed. Please install it and try again."
    exit 1
  fi
done

if [[ -z "$JAVA_HOME" ]]; then
  echo "JAVA_HOME is not set"
else
  echo "JAVA_HOME is set to $JAVA_HOME"
fi

# Clone eclipse.jdt.ls
git clone https://github.com/eclipse/eclipse.jdt.ls ~/$basedir/eclipse/eclipse.jdt.ls

# Build eclipse.jdt.ls
cd ~/$jdtlsdir/eclipse/eclipse.jdt.ls || exit
 ./mvnw clean install -DskipTests

# Clone java-debug
git clone https://github.com/microsoft/java-debug ~/$jdtlsdir/microsoft/java-debug

# Build java-debug
cd ~/$jdtlsdir/microsoft/java-debug || exit
./mvnw clean install

# Clone vscode-java-test
git clone https://github.com/microsoft/vscode-java-test ~/$jdtlsdir/microsoft/vscode-java-test

# Build vscode-java-test
cd ~/$jdtlsdir/microsoft/vscode-java-test || exit
git clean -xdff
npm install
npm run build-plugin


# Create async-profiler folder
mkdir -p ~/$appdir/async-profiler/

# Fetch sjk.jar
wget -O ~/$appdir/sjk.jar "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=org.gridkit.jvmtool&a=sjk&v=LATEST"

# Get and unpack async-profiler
wget -O /tmp/async-profiler.tar.gz "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v1.8/async-profiler-1.8-linux-x64.tar.gz"
tar -xzf /tmp/async-profiler.tar.gz -C ~/$appdir/async-profiler/ --strip-components=1
rm /tmp/async-profiler.tar.gz

# Create jmc folder
mkdir -p ~/$appdir/jmc/

# Get and unpack jmc
wget -O /tmp/jmc.tar.gz "https://download.java.net/java/GA/jmc8/05/binaries/jmc-8.3.1_linux-x64.tar.gz"
tar -xzf /tmp/jmc.tar.gz -C ~/$appdir/jmc/ --strip-components=1
rm /tmp/jmc.tar.gz

# Create symlink for jmc
ln -sf ~/$appdir/jmc/*/jmc ~/.local/bin/jmc

# Clone vscode-java-decompiler
git clone https://github.com/dgileadi/vscode-java-decompiler ~/$jdtlsdir/dgileadi/vscode-java-decompiler

echo "Setup is completed"
