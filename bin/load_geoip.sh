#!/usr/bin/env bash

# grab environment args
CURRENT_PATH=$(pwd)
BUILD_DIR=$CURRENT_PATH
TEMP_DIR="$CURRENT_PATH/tmp"

# Paths.
BIN_DIR=$(cd $(dirname $0); pwd) # absolute path
ROOT_DIR=$(dirname $BIN_DIR)

# Syntax sugar.
source bin/utils.sh

GEOIP_VERSION="1.6.0"

VENDORED_GEOIP="vendor/geoip/1.6.0"
APP_GEOIP="$TEMP_DIR/$VENDORED_GEOIP"

# Maxmind GeoIP C library

GEOIP_DIST_URL="https://github.com/maxmind/geoip-api-c/releases/download/v$GEOIP_VERSION/GeoIP-$GEOIP_VERSION.tar.gz"
GEOIP_DIST_DIR="GeoIP-$GEOIP_VERSION"

GEOLITECITY_URL="http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
GEOLITECITY_FILE="GeoLiteCity.dat"

GEOLITECOUNTRY_URL="http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
GEOLITECOUNTRY_FILE="GeoIP.dat"


puts-step "Installing Maxmind GeoIP C Library $GEOIP_VERSION"
if [ ! -d "$TEMP_DIR/geoip/$GEOIP_VERSION" ]; then
    mkdir -p $TEMP_DIR/geoip/$GEOIP_VERSION
fi

puts-step "Downloading GeoIP C Library into $TEMP_DIR"
curl -s -L -o $TEMP_DIR/geoip.tar.gz $GEOIP_DIST_URL
cd  $TEMP_DIR
tar -zxvf $TEMP_DIR/geoip.tar.gz
cd $TEMP_DIR/$GEOIP_DIST_DIR
./configure --prefix=$TEMP_DIR > /dev/null
make install > /dev/null

cd $BUILD_DIR

if [ ! -f $TEMP_DIR/$GEOLITECOUNTRY_FILE ]; then
    curl -s -L -o ${TEMP_DIR}/${GEOLITECOUNTRY_FILE}.gz $GEOLITECOUNTRY_URL
    cd  $TEMP_DIR
    gunzip ${TEMP_DIR}/${GEOLITECOUNTRY_FILE}.gz > /dev/null
fi

GEOCOUNTRY_LITE_PATH="$TEMP_DIR/${GEOLITECOUNTRY_FILE}"
set-env "GEOCOUNTRY_LITE_PATH" $GEOCOUNTRY_LITE_PATH
puts "GeoIP Country Database is available at:${GEOCOUNTRY_LITE_PATH}"
