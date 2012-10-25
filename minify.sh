#!/bin/bash

usage() {
    echo -e "\nminify.sh FILE..."
    echo "Minify all JavaScripts."
}

function compress {
	echo "Processing: $1"
	java -jar ${COMPRESSOR} --js $1 --js_output_file ./min/$1
}

# Find Google Compiler
if ! [ `find ~/. -type f -name compiler\*.jar` ]
then
    echo "Unable to locate the Google Compiler jar file!"
    exit 1
else 
    COMPRESSOR=`find ~/. -type f -name compiler\*.jar`
fi

# Minify JavaScripts

# Fetch external dependencies, like jQuery
echo -e "\nFetching a copy of jQuery v1.4.2..."
rm -rf "jqueryTemp.js"
wget -O "jqueryTemp.js" --progress=dot http://code.jquery.com/jquery-1.4.2.min.js

if [ -d "min" ];then
    rm -rf "min"
    echo "removed existing min directory"
fi

mkdir min
echo "created min directory"

echo -e "\nMinifying JavaScripts..."
jslist=`find . -type f -name \*.js`

for jsfile in $jslist
do
    if [ -d "$jsfile" ];then
        echo "dir: $jsfile"
    elif [ -f "$jsfile" ]; then
        echo "Processing: $jsfile"
		_time="min."
		new=$(echo ${jsfile} | sed "s/\(.*\)\(..\)/\1${_time}\2/")
		cp -fr ${jsfile} ${new}
		compress ${new}
        echo "New File: $jsfile"
    fi
done