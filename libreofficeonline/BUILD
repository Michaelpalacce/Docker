#! /bin/bash
# This file is part of the LibreOffice project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# -- Available env vars --
# * DOCKER_HUB_REPO - which Docker Hub repo to use
# * DOCKER_HUB_TAG  - which Docker Hub tag to create
# * LIBREOFFICE_BRANCH  - which branch to build in core
# * LIBREOFFICE_ONLINE_REPO - which git repo to clone online from
# * LIBREOFFICE_ONLINE_BRANCH - which branch to build in online
# * LIBREOFFICE_BUILD_TARGET - which make target to run (in core repo)
# * ONLINE_EXTRA_BUILD_OPTIONS - extra build options for online
# * NO_DOCKER_IMAGE - if set, don't build the docker image itself, just do all the preps

# check we can sudo without asking a pwd
echo "Trying if sudo works without a password"
echo
echo "If you get a password prompt now, break, and fix your setup using 'sudo visudo'; add something like:"
echo "yourusername ALL=(ALL) NOPASSWD: /sbin/setcap"
echo
sudo echo "works"

if [ -z "$LIBREOFFICE_BRANCH" ]; then
  LIBREOFFICE_BRANCH="master"
fi;
echo "Building core branch '$LIBREOFFICE_BRANCH'"

if [ -z "$LIBREOFFICE_ONLINE_REPO" ]; then
  LIBREOFFICE_ONLINE_REPO="https://git.libreoffice.org/online"
fi;
if [ -z "$LIBREOFFICE_ONLINE_BRANCH" ]; then
  LIBREOFFICE_ONLINE_BRANCH="master"
fi;
echo "Building online branch '$LIBREOFFICE_ONLINE_BRANCH' from '$LIBREOFFICE_ONLINE_REPO'"

if [ -z "$LIBREOFFICE_BUILD_TARGET" ]; then
  LIBREOFFICE_BUILD_TARGET=""
fi;
echo "LibreOffice build target: '$LIBREOFFICE_BUILD_TARGET'"


SRCDIR=$(realpath `dirname $0`)
INSTDIR="$SRCDIR/instdir"

if [ -z "$(lsb_release -si)" ]; then
	echo "WARNING: Unable to determine your distribution"
	echo "(Is lsb_release installed?)"
	echo "Using Ubuntu Dockerfile."
	HOST_OS="Ubuntu"
else
	HOST_OS=$(lsb_release -si)
fi
BUILDDIR="$SRCDIR/builddir"

mkdir -p "$BUILDDIR"
cd "$BUILDDIR"

rm -rf "$INSTDIR" || true
mkdir -p "$INSTDIR"

##### cloning & updating #####

# libreoffice repo
if test ! -d libreoffice ; then
    git clone https://git.libreoffice.org/core libreoffice || exit 1
fi

( cd libreoffice && git fetch --all && git checkout $LIBREOFFICE_BRANCH && ./g pull -r ) || exit 1

# online repo
if test ! -d online ; then
    git clone "$LIBREOFFICE_ONLINE_REPO" online || exit 1
fi

( cd online && git fetch --all && git checkout -f $LIBREOFFICE_ONLINE_BRANCH && git clean -f -d && git pull -r ) || exit 1

##### LibreOffice #####

# build LibreOffice
( cd libreoffice && ./autogen.sh --with-distro=LibreOfficeOnline) || exit 1
( cd libreoffice && make $LIBREOFFICE_BUILD_TARGET ) || exit 1

# copy stuff
mkdir -p "$INSTDIR"/opt/
cp -a libreoffice/instdir "$INSTDIR"/opt/libreoffice

##### loolwsd & loleaflet #####

# build
( cd online && ./autogen.sh ) || exit 1
( cd online && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-silent-rules --with-lokit-path="$BUILDDIR"/libreoffice/include --with-lo-path=/opt/libreoffice $ONLINE_EXTRA_BUILD_OPTIONS) || exit 1
( cd online && scripts/locorestrings.py "$BUILDDIR"/online "$BUILDDIR"/libreoffice/translations )
( cd online && scripts/unocommands.py --update "$BUILDDIR"/online "$BUILDDIR"/libreoffice )
( cd online && scripts/unocommands.py --translate "$BUILDDIR"/online "$BUILDDIR"/libreoffice/translations )
( cd online && make -j 8) || exit 1

# copy stuff
( cd online && DESTDIR="$INSTDIR" make install ) || exit 1

# Create new docker image
if [ -z "$NO_DOCKER_IMAGE" ]; then
  cd "$SRCDIR"

  # Pull the image first to be sure we're using the latest available
  docker pull $(grep "FROM " $HOST_OS | cut -d ' ' -f 2)

  docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile -t stefangenov/libre-office-online:latest --push .
else
  echo "Skipping docker image build"
fi;
