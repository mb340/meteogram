#!/bin/bash
CURRDIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
DATADIR=$CURRDIR/package/contents/code/db
WORKDIR=$CURRDIR/tmp

if [ ! -d $WORKDIR ]; then
  mkdir $WORKDIR
fi
# rm -f $WORKDIR/*

# Download "Cities500.zip" file from Geonames.
# and Extract file from "Cities500.zip"
# wget -P "$WORKDIR" "https://download.geonames.org/export/dump/cities500.zip"
unzip -u "$WORKDIR/cities500.zip"  -d "$WORKDIR"
# wget -P "$WORKDIR" "https://timezonedb.com/files/timezonedb.csv.zip"
unzip -u "$WORKDIR/timezonedb.csv.zip" -d "$WORKDIR" *.csv

# Extract CountryCode, Area, PlaceName, Latitude, Longtitude, Altitude, TimeZone from cities500.txt into temporary file pass1.txt
echo "Processing Locations Database..."
cat "$WORKDIR/cities500.txt" | cut -f 2,5,6,9,11,17,18 | awk -F"\t" '{print $4,$5,$1,$2,$3,$6,$7}' OFS="\t" | sort > "$WORKDIR/pass1.txt"

# Extract Country Codes and Timezone Names into temporary files
sed "s/\"//g" "$WORKDIR/zone.csv" | cut -d"," -f2 | sort | uniq > "$WORKDIR/countrycodes.txt"
sed "s/\"//g" "$WORKDIR/zone.csv" | cut -d"," -f3 > "$WORKDIR/areas.txt"

readarray -t countrycodes < "$WORKDIR/countrycodes.txt"
readarray -t areas < "$WORKDIR/areas.txt"
echo "Done!"

echo "Shrinking Locations Database..."
# Convert Timezones in Pass1 into ID numbers
ID=0
for A in "${areas[@]}"
do
  echo -n "."
  sed -i "s|$A$|$ID|g" "$WORKDIR/pass1.txt"
  let ID+=1
done


echo "Done!"
echo "Splitting Locations Databases..."
# Finally, split the pass1.txt file into individual Country Code data files.
sed -i 's#\"#\\"#g' "$WORKDIR/pass1.txt"
for C in "${countrycodes[@]}"
do
#   echo "Creating Database \"$C.js\""
  FILENAME="$DATADIR/$C.js"

  IFS=$'\n'
  sortedlist=($(grep "^$C" "$WORKDIR/pass1.txt" | cut -f 2- | sort))

  if [ "${#sortedlist[@]}" -eq "0" ]; then
    continue
  fi

  echo "const CITIES = [" > $FILENAME
  for A in "${sortedlist[@]}"
  do
    echo -e "\t\"${A}\"," >> $FILENAME
  done
  echo "];" >> $FILENAME
done
echo "Done"

# Compile Timezone and DST Data.
echo "Creating Timezine and Daylight Savings Time Database..."
php -f "$CURRDIR/compile.php" "$CURRDIR"
echo "All Done!"

rm -f $WORKDIR/*