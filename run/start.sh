#!/bin/bash

if [ ! -f /config/settings.ini ]; then
  cp /plexanisync/settings.ini.example /config/settings.ini
fi
echo "Updating settings.ini"
python settingsupdater.py

echo "Looking for custom mapping"

if [ ! -z "${CUSTOM_MAPPINGS}" ]
then
  if test -f "${CUSTOM_MAPPINGS}"; then
    echo "Found local custom mapping file and importing: ${CUSTOM_MAPPINGS}"
    cp ${CUSTOM_MAPPINGS} /plexanisync/custom_mappings.ini
  else
    echo "Found remote custom mapping file and importing: ${CUSTOM_MAPPINGS}"
    wget -O /plexanisync/custom_mappings.ini ${CUSTOM_MAPPINGS}
  fi
else
  echo "No custom mapping specified"
fi

while true
do
  (cd /plexanisync && python PlexAniSync.py /config/settings.ini)
  sleep ${INTERVAL}
done
