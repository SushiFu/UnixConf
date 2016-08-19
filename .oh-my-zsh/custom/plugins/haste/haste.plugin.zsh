URL=
HTTP_USERNAME=
HTTP_PASSWORD=

haste() {
    if [ -t 0  ]; then
        if [ "$*" ]; then
            if [ -f "$*" ]; then
                echo Uploading the contents of "$*"... >&2
                a=$(cat "$*");
            else
                echo Uploading the text: \""$*"\"... >&2
                a=$(echo "$*");
            fi
		else
			echo "Upload text to hastebin from $URL \nUsage: \n $0 file \n $0 text \n piped | $0 \n haste < file" >&2
            return 0;
		fi
	else
        echo Using input from a pipe or STDIN redirection... >&2
        a=$(cat)
    fi
    curl -u $HTTP_USERNAME:$HTTP_PASSWORD -X POST -s -d "$a" https://$URL/documents \
        | awk -F '"' '{print "https://$URL/"$4}';
}
