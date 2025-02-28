#!/bin/bash
cd "$(dirname "$0")" || exit
# set -e
source scripts/utils.sh
QT += x11extras
CXX="g++"
CXXFLAGS="-Wall -Wextra -std=c++17 -O2 -fPIC"

SuccessExit=0
CompilationErrorExit=1
LinkingErrorExit=2
ErrorExit=3

chmod +x scripts/deepinstall.sh
scripts/deepinstall.sh || ShowWarn "Failed to install dependencies"

QtIncludePath=$(find /usr/include /usr/local/include -type d -name "qt5" 2>/dev/null | head -n 1)
KF5IncludePath=$(find /usr/include /usr/local/include -type d -name "KF6" 2>/dev/null | head -n 1)

INCLUDEPATH=(
  "/usr/include"
  "$QtIncludePath"
  "$QtIncludePath/QtCore"
  "$QtIncludePath/QtWidgets"
  "$QtIncludePath/QtGui"
  "$QtIncludePath/QtX11Extras"
  "$KF5IncludePath/KConfig"
  "$KF5IncludePath/KConfigCore"
  "$PWD/src/Include"
  "$PWD/src"
)

QtLibPath=$(find /usr/lib* /usr/local/lib* -type f -name "libQt5Core.so*" 2>/dev/null | xargs -r dirname | head -n 1)
[ -z "$QtLibPath" ] && QtLibPath="$(pkg-config --variable=libdir Qt5 2>/dev/null)"
[ -z "$QtLibPath" ] && QtLibPath="/usr/lib64/qt5"


KF5LibPath=$(find /usr/lib* /usr/local/lib* -type f -name "libkconfig.so*" 2>/dev/null | xargs -r dirname | head -n 1)
[ -z "$KF5LibPath" ] && KF5LibPath="$(pkg-config --variable=libdir KF6Config 2>/dev/null)"
[ -z "$KF5LibPath" ] && KF5LibPath="/usr/lib64/KConfig"


LIBS=(
  "-L$QtLibPath"
  "-L$KF5LibPath"
  "-lQt5Core"
  "-lQt5Widgets"
  "-lQt5Gui"
  "-lQt5X11Extras"
  "-lQt5Concurrent"
  "-lQt5Network"
  "-lQt5Xml"
  "-lQt5DBus"
  "-lQt5PrintSupport"
  "-lKF5ConfigCore"
  "-lKF5ConfigGui"
  "-lKF5CoreAddons"
  "-lX11"
)

SRC="src"
BUILD="build"

OUT="Universe.elf"
OUTDIR="bin"

mkdir -p "$BUILD" || ShowError $ErrorExit "Failed to create build directory"
mkdir -p "$OUTDIR" || ShowError $ErrorExit "Failed to create output directory"

SOURCES=($(find "$SRC" -type f -name "*.cpp"))
OBJECTS=()
total=${#SOURCES[@]}
compiled=0

for src in "${SOURCES[@]}"; do
  obj="$BUILD/$(basename "${src%.cpp}.o")"
  OBJECTS+=("$obj")

  if [[ ! -f "$obj" || "$(stat -c %Y "$src")" -gt "$(stat -c %Y "$obj")" ]]; then
    $CXX $CXXFLAGS "${INCLUDEPATH[@]/#/-I}" -c "$src" -o "$obj" || ShowError $CompilationErrorExit "Compilation failed for $src"
    ((compiled++))
    printf "\033[1;34m[%3d%% ]\033[94m %s\n" "$((compiled * 100 / total))" "$src -> $obj"
  fi
done

$CXX $CXXFLAGS "${OBJECTS[@]}" "${LIBS[@]}" -o "$OUTDIR/$OUT" || ShowError $LinkingErrorExit "Linking failed."

ShowSuccess "Build completed: $OUT"
exit $SuccessExit
