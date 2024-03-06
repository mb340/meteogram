#!/bin/bash

VERSION="$(jq -r '.KPlugin.Version' package/metadata.json)"
echo "version: ${VERSION}"

FILENAME="com.github.mb340.meteogram-${VERSION}.plasmoid"
echo "filename: ${FILENAME}"

if [[ -f ${FILENAME} ]]; then
	rm ${FILENAME}
fi

pushd package/
zip -q  -r ../${FILENAME} ./ --exclude "contents/tests/*"
popd
