#!/bin/sh
cd "$(dirname $0)"

use_gdb=""
use_dbg="-d mgw"
use_pdb="-DPDB=OFF"
if [ "$1" == "-g" ]; then
	use_gdb="gdb --args"
elif [ "$1" == "-d" ]; then
	use_pdb="-DPDB=ON"
	use_dbg="-d vs"
fi

gamePath=/l/Program\ Files\ \(x86\)/EA\ Games/Command\ \&\ Conquer\ Generals\ Zero\ Hour/
cmake .. -G"MSYS Makefiles" -DCMAKE_BUILD_TYPE=Debug $use_pdb && make -j$(grep processor /proc/cpuinfo | wc -l) &&
(
	cp -Rav ../shaders "$gamePath";
	rm openSage.RPT 2>/dev/null;
	$use_gdb ./openSage.exe $use_dbg -r "$gamePath"
)
