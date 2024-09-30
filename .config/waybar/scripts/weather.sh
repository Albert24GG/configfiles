#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# requires fontawesome-fonts, moon.py

PROG=$(basename "$0")

usage() {
	echo "nocache"
	echo "raw (implies nocache)"
	echo "read or r/w"
	echo "provider <BOM/OPENWEATHER/WEATHER/VISUAL>"
	echo "<city> (implies nocache)"
}

PRINT_RAW=""
WARNING=""

# customisation:
# set the interval in ~/.config/waybar/config so we don't call this too often -
# OPENWEATHER allows up to 1000 api calls / day
OPENWEATHER_APIKEY="$(<~/.config/openweather-api)"
CITY="Bucharest"
ALARMING_MIN_TEMP=10
ALARMING_MAX_TEMP=30
ALARMING_WIND=30
CACHE_USE="r/w"
PROVIDER=OPENWEATHER
CACHE=~/.config/waybar/$PROG.cache
CONFIG=~/.config/waybar/$PROG.config
# shellcheck disable=SC1090
[[ -r $CONFIG ]] && source "$CONFIG"
# end of customisations

# CLI over-rides:
CLI_CITY=""
while [[ "$1" ]]; do
	case "$1" in
	"nocache")
		CACHE_USE="ignore"
		shift
		;;
	"raw")
		PRINT_RAW="set"
		CACHE_USE="ignore"
		shift
		;;
	"read"*)
		CACHE_USE="reader"
		shift
		;;
	"r/w"*)
		CACHE_USE="r/w"
		shift
		;;
	"prov"*)
		PROVIDER="$2"
		shift 2
		;;
	*help* | usage | *-h*)
		usage
		exit 0
		;;
	"") : ;;
	*)
		CLI_CITY="$1"
		CACHE_USE="ignore"
		shift
		;;
	esac
done

[[ "$CACHE_USE" != "ignore" ]] && {
	# shellcheck disable=SC1090
	[[ -r $CACHE ]] && source "$CACHE"
}

DIR_ARRAY=(N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW N)

# NOTES ON BOM:
# config file boilerplate (see ~/.config/waybar/$PROG.config)
# To get Station Id, go to
# http://www.bom.gov.au/qld/observations/qldall.shtml and right click
# on the station eg for QFRJ North Tamborine:
# http://www.bom.gov.au/products/IDQ60801/IDQ60801.99123.shtml
#BOM_PRODUCT="IDQXXXXX/IDQXXXXX.YYYYY.json"
#BOM_URL="http://reg.bom.gov.au/fwo/$BOM_PRODUCT"
#BOM_JSON=$( wget -qO- "$BOM_URL" ) || exit 1 # slow!

for req in jq wget; do
	which $req >/dev/null 2>&1 || {
		notify-send "$PROG: Program '$req' is required but it is not installed.  Aborting."
		exit 1
	}
done

TODAY=$(date +%F)
if [[ "$CACHE_USE" != "reader" ]]; then

	# reset min & max if it's a new day:
	RESET_LIMITS=""
	[[ "$DATE" != "$TODAY" ]] && RESET_LIMITS="set"
	[[ -z "$MIN_TEMP" || "$RESET_LIMITS" ]] && MIN_TEMP=1000
	[[ -z "$MAX_TEMP" || "$RESET_LIMITS" ]] && MAX_TEMP=-1000

	# get data:
	[[ "$CLI_CITY" ]] && CITY="$CLI_CITY"
	# shellcheck disable=SC2034
	OPENWEATHER_URL="http://api.openweathermap.org/data/2.5/weather?q=${CITY}&units=metric&APPID=${OPENWEATHER_APIKEY}"
	# shellcheck disable=SC2034
	VISUAL_URL="https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/${CITY}/$(date +%s)?include=current&unitGroup=metric&key=${VISUAL_APIKEY}&contentType=json"
	# shellcheck disable=SC2034
	BOM_URL="http://reg.bom.gov.au/fwo/$BOM_PRODUCT"

	# shellcheck disable=SC2034
	WEATHER_URL="https://api.weather.com/v2/pws/observations/current?apiKey=${WEATHER_KEY}&stationId=${WEATHER_STATION}&numericPrecision=decimal&format=json&units=s" # units=e for Fahrenheit

	URL=${PROVIDER}_URL
	JSON=$(wget -qO- "${!URL}") || {
		PROVIDER=OPENWEATHER # fallback as BOM's PORTABLE_QFRJ is not too reliable
		URL=${PROVIDER}_URL
		JSON=$(wget -qO- "${!URL}") || exit 1
	}

	[[ "$PRINT_RAW" ]] && {
		echo "$PROVIDER: URL=${!URL}"
		echo "============"
		echo "$JSON" | jq .
		exit 0
	}

	# calculations:
	case "$PROVIDER" in
	OPENWEATHER)                                                                # free tier is up to 1,000,000 points/month ie ~22 per minute
		TEMP=$(echo "$JSON" | jq '.main.temp + 0.5|floor')                         # round to degree
		WIND_SPEED=$(echo "$JSON" | jq '.wind.speed * 60 * 60 / 1000 + 0.5|floor') # wind.speed is m/s
		WIND_GUST=0
		WIND_DIR=$(echo "$JSON" | jq '( .wind.deg % 360 / 22.5 ) + 0.5|floor')
		WIND_DIR=${DIR_ARRAY[WIND_DIR]}
		OPENWEATHER_JSON="$JSON"
		;;
	BOM)
		TEMP=$(echo "$JSON" | jq '.observations.data[0].air_temp + 0.5|floor') # round to degree
		WIND_SPEED=$(echo "$JSON" | jq '.observations.data[0].wind_spd_kmh')
		WIND_GUST=$(echo "$JSON" | jq '.observations.data[0].gust_kmh')
		WIND_DIR=$(echo "$JSON" | jq -r '.observations.data[0].wind_dir')
		# BOM does not provide sunrise/set
		;;
	WEATHER)
		TEMP=$(echo "$JSON" | jq '.observations[0].metric_si.temp + 0.5|floor')
		WIND_SPEED=$(echo "$JSON" | jq '.observations[0].metric_si.windSpeed + 0.5|floor')
		WIND_GUST=$(echo "$JSON" | jq '.observations[0].metric_si.windGust + 0.5|floor')
		WIND_DIR=$(echo "$JSON" | jq '( .observations[0].winddir % 360 / 22.5 ) + 0.5|floor')
		WIND_DIR=${DIR_ARRAY[WIND_DIR]}
		# weather.com does not provide sunrise/set, at least in this api:
		;;
	VISUAL) # free tier is up to 1000 points/day ie max of about every 2mins
		TEMP=$(echo "$JSON" | jq '.currentConditions.temp + 0.5|floor')
		WIND_SPEED=$(echo "$JSON" | jq '.currentConditions.windspeed + 0.5|floor')
		WIND_GUST=$(echo "$JSON" | jq '.currentConditions.windgust + 0.5|floor')
		WIND_DIR=$(echo "$JSON" | jq '(.currentConditions.winddir % 360 / 22.5) + 0.5|floor')
		SUNRISE=$(echo "$JSON" | jq '.currentConditions.sunriseEpoch')
		SUNSET=$(echo "$JSON" | jq '.currentConditions.sunsetEpoch')
		WEATHER_CONDITION=$(echo "$JSON" | jq '.currentConditions.conditions')
		WIND_DIR=${DIR_ARRAY[WIND_DIR]}
		;;
	esac

	if [[ "$SUNRISE" && "$SUNSET" && "$WEATHER_CONDITION" ]]; then
		:
	else
		[[ "$OPENWEATHER_JSON" ]] ||
			OPENWEATHER_JSON=$(wget -qO- "${OPENWEATHER_URL}") || exit 1
		WEATHER_CONDITION=$(echo "$OPENWEATHER_JSON" | jq -r '.weather[0].main')
		SUNRISE=$(echo "$OPENWEATHER_JSON" | jq '.sys.sunrise')
		SUNSET=$(echo "$OPENWEATHER_JSON" | jq '.sys.sunset')
	fi

	if [[ ("$WIND_GUST" -gt 0) ]]; then
		WIND_RANGE="$WIND_SPEED-$WIND_GUST"
	else
		WIND_RANGE="$WIND_SPEED"
	fi
	case ${WEATHER_CONDITION,,} in
	*'cloud'*)
		WEATHER_ICON=" "
		;;
	*'rain'*)
		WEATHER_ICON=" "
		;;
	*'snow'*)
		WEATHER_ICON=" "
		;;
	*)
		WEATHER_ICON="󰖨 "
		;;
	esac

	# no longer working?
	# MOON_URL="https://api.usno.navy.mil/moon/phase?date=today&nump=1"
	# MOON_URL="https://aa.usno.navy.mil/api/moon/phases/date?date=8/6/2022&nump=1"
	# MOON_JSON=$( wget -qO- --no-check-certificate "$MOON_URL" )
	#MOON_PHASE_NAME=$( echo "$MOON_JSON" | jq -r .phasedata[0].phase )
	#
	#case "$MOON_PHASE_NAME" in
	#    "Full Moon")     MOON_PHASE=$'\U1F311' ;;
	#    "Last Quarter")  MOON_PHASE=$'\U1F313' ;;
	#    "New Moon")      MOON_PHASE=$'\U1f315' ;;
	#    "First Quarter") MOON_PHASE=$'\U1F317' ;;
	#    *)               MOON_PHASE=''
	#esac
	# echo "Moon phase = '$MOON_PHASE_NAME' = '$MOON_PHASE'" >&2

	# if these don't display on waybar, then another font is obscuring
	# them. Check UTF codepoints eg 0x1f314. 'emoji' fonts are
	# particularly bad eg google-noto-emoji-color-fonts-*

	((MIN_TEMP > TEMP)) && MIN_TEMP=$TEMP
	((MAX_TEMP < TEMP)) && MAX_TEMP=$TEMP

fi

NOW=$(date +%s)

# sanity check for SUNRISE/SET (could be an old cache):
midnight_am=$(date --date "00:00" +%s)
midnight_pm=$(date --date "23:59:59" +%s)
noon=$(date --date "12:00" +%s)
[[ "$SUNRISE" ]] && {
	((SUNRISE < midnight_am || SUNRISE > noon)) && SUNRISE=
}
[[ "$SUNSET" ]] && {
	((SUNSET < noon || SUNSET > midnight_pm)) && SUNSET=
}

[[ "$SUNRISE" ]] || SUNRISE=$(date --date '6am today' +%s)
[[ "$SUNSET" ]] || SUNSET=$(date --date '6pm today' +%s)

if ((NOW > SUNSET || NOW < SUNRISE)); then
	DARK_MODE="dark"
else
	DARK_MODE="light"
fi
dark-mode $DARK_MODE &>/dev/null

# output:
SUNRISE_S="$(date -d @"$SUNRISE" '+%H:%M')"
SUNSET_S="$(date -d @"$SUNSET" '+%H:%M')"

TEXT="${WEATHER_ICON}${TEMP}°C"
TOOLTIP="${WEATHER_ICON} ${MIN_TEMP}&lt;${TEMP}&lt;${MAX_TEMP}°C\n${WIND_DIR} ${WIND_RANGE}kph\n $SUNRISE_S $SUNSET_S \nL:Weather R:Refresh (signal 12)"
CLASS=""
((TEMP < ALARMING_MIN_TEMP || TEMP > ALARMING_MAX_TEMP || WIND_SPEED > ALARMING_WIND)) && CLASS="warning"

cat <<EOF
{"text": "$TEXT", "tooltip": "$TOOLTIP", "class": "$CLASS" }
EOF

# cache results locally for other programs to use eg mylock via .config/nwg-wrapper/timezones.sh:
{
	if [[ "$CACHE_USE" != "reader" ]]; then
		echo "SOURCE=${!URL}"
	else
		echo "SOURCE=$CACHE_FILE"
	fi
	echo "DATE=$TODAY"
	echo "TIME=$(date +%R)"
	echo "CITY_NAME=$CITY"
	echo "WEATHER_ICON=${WEATHER_ICON}"
	echo "TEMP=${TEMP}"
	echo "MIN_TEMP=${MIN_TEMP}"
	echo "MAX_TEMP=${MAX_TEMP}"
	echo "WIND_DIR=${WIND_DIR}"
	echo "WIND_RANGE=${WIND_RANGE}"
	echo "SUNRISE=$SUNRISE"
	echo "SUNSET=$SUNSET"
	echo "HOST_PROVIDER=${HOSTNAME}/$PROVIDER"
} >~/".config/waybar/$PROG.cache"

exit 0

# Local Variables:
# eval: (add-hook 'after-save-hook (lambda nil (shell-command "pkill --signal RTMIN+12 waybar")) nil 'local)
# End:
