#!/usr/bin/sh

DEFAULT_BROWSER=$(xdg-settings get default-web-browser)

for p in ${XDG_DATA_DIRS//:/ }; do
    APP_PATH="$p/applications"
    if [ -d $("APP_PATH") ]; then
        BROWSER=$(find $APP_PATH -name $DEFAULT_BROWSER)
        if [ -n "$BROWSER" ]; then
            break
        fi
    fi
done


echo $BROWSER
