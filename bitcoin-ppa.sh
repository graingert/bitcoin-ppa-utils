#!/bin/sh
echo "USAGE: bitcoin-debian build|upload|clean"
OLDPATH=`pwd`
cd /home/matt/Documents/DeveloperProjects/Bitcoin
rm bitcoin_*.debian.tar.gz
rm bitcoin_*.dsc
rm bitcoin_*_source*
rm bitcoin_*_amd64.*
rm bitcoin*.deb
cd bitcoin
git clean -f -x
rm -rf build/
rm -rf .pc/
DEBIAN_NEEDS_REMOVED=0
if [ ! -d debian -a -d contrib/debian ]; then
	cp -r contrib/debian .
	DEBIAN_RENEEDS_MOVED=1
fi
echo "#1001_use_system_json-spirit.patch" > debian/patches/series
if [ "$1" = "upload" ]; then
	debuild -S -sa -i
	cd ..
	dput ppa:bitcoin/bitcoin bitcoin_*_source.changes
	cd bitcoin
elif [ "$1" = "build" ]; then
	debuild -i
fi
if [ $DEBIAN_NEEDS_REMOVED -eq 1 ]; then
	rm -rf debian
fi
cd $OLDPATH


