#!/usr/bin/env python3

import requests
import datetime
from dataclasses import dataclass
import math
import json
import os
import base64

WWO_CODE = {
    "113": "Sunny",
    "116": "PartlyCloudy",
    "119": "Cloudy",
    "122": "VeryCloudy",
    "143": "Fog",
    "176": "LightShowers",
    "179": "LightSleetShowers",
    "182": "LightSleet",
    "185": "LightSleet",
    "200": "ThunderyShowers",
    "227": "LightSnow",
    "230": "HeavySnow",
    "248": "Fog",
    "260": "Fog",
    "263": "LightShowers",
    "266": "LightRain",
    "281": "LightSleet",
    "284": "LightSleet",
    "293": "LightRain",
    "296": "LightRain",
    "299": "HeavyShowers",
    "302": "HeavyRain",
    "305": "HeavyShowers",
    "308": "HeavyRain",
    "311": "LightSleet",
    "314": "LightSleet",
    "317": "LightSleet",
    "320": "LightSnow",
    "323": "LightSnowShowers",
    "326": "LightSnowShowers",
    "329": "HeavySnow",
    "332": "HeavySnow",
    "335": "HeavySnowShowers",
    "338": "HeavySnow",
    "350": "LightSleet",
    "353": "LightShowers",
    "356": "HeavyShowers",
    "359": "HeavyRain",
    "362": "LightSleetShowers",
    "365": "LightSleetShowers",
    "368": "LightSnowShowers",
    "371": "HeavySnowShowers",
    "374": "LightSleetShowers",
    "377": "LightSleet",
    "386": "ThunderyShowers",
    "389": "ThunderyHeavyRain",
    "392": "ThunderySnowShowers",
    "395": "HeavySnowShowers",
}

WEATHER_SYMBOL_DAY = {
    "Unknown": "\uf07b",
    "Cloudy": "\uf002",
    "Fog": "\uf003",
    "HeavyRain": "\uf008",
    "HeavyShowers": "\uf009",
    "HeavySnow": "\uf00a",
    "HeavySnowShowers": "\uf00a",
    "LightRain": "\uf00b",
    "LightShowers": "\uf00b",
    "LightSleet": "\uf0b2",
    "LightSleetShowers": "\uf0b2",
    "LightSnow": "\uf00a",
    "LightSnowShowers": "\uf00a",
    "PartlyCloudy": "\uf00c",
    "Sunny": "\uf00d",
    "ThunderyHeavyRain": "\uf010",
    "ThunderyShowers": "\uf00e",
    "ThunderySnowShowers": "\uf06b",
    "VeryCloudy": "\uf013",
}

WEATHER_SYMBOL_NIGHT = {
    "Unknown": "\uf07b",
    "Cloudy": "\uf086",
    "Fog": "\uf04a",
    "HeavyRain": "\uf028",
    "HeavyShowers": "\uf029",
    "HeavySnow": "\uf02a",
    "HeavySnowShowers": "\uf02a",
    "LightRain": "\uf02b",
    "LightShowers": "\uf02b",
    "LightSleet": "\uf0b4",
    "LightSleetShowers": "\uf0b4",
    "LightSnow": "\uf02a",
    "LightSnowShowers": "\uf02a",
    "PartlyCloudy": "\uf081",
    "Sunny": "\uf02e",
    "ThunderyHeavyRain": "\uf02d",
    "ThunderyShowers": "\uf02c",
    "ThunderySnowShowers": "\uf06d",
    "VeryCloudy": "\uf013",
}

WIND_ICON = {
    "N": "<\uf044",
    "NNE": "\uf043",
    "NE": "\uf043",
    "ENE": "\uf043",
    "E": "\uf048",
    "ESE": "\uf087",
    "SE": "\uf087",
    "SSE": "\uf087",
    "S": "\uf058",
    "SSW": "\uf057",
    "SW": "\uf057",
    "WSW": '<span size="large">\uf057</span>',
    "W": "\uf04d",
    "WNW": "\uf088",
    "NW": "\uf088",
    "NNW": "\uf088",
}


def load_svg_icon(icon_name: str, icon_dir: str) -> str:
    icon_path = os.path.join(icon_dir, f"{icon_name}.svg")
    if os.path.exists(icon_path):
        with open(icon_path, "r") as icon_file:
            return icon_file.read()
    return ""  # Return empty string if icon not found


def load_png_icon(icon_name: str, icon_dir: str) -> str:
    icon_path = os.path.join(icon_dir, f"{icon_name}.png")
    if os.path.exists(icon_path):
        with open(icon_path, "rb") as icon_file:
            return base64.b64encode(icon_file.read()).decode("utf-8")
    return ""  # Return empty string if icon not found


@dataclass
class Temp:  # in celsius
    current: str
    feels_like: str
    min: str
    max: str


@dataclass
class Wind:
    speed: str  # kmph
    direction: str  # 16 point


@dataclass
class Astronomy:
    sunrise: str  # 24 hour format
    sunset: str  # 24 hour format


@dataclass
class WeatherInfo:
    temp: Temp
    wind: Wind
    humidity: str  # percentage
    uv_index: str
    precipMM: str
    pressure: str  # in mmHg
    astronomy: Astronomy
    desc: str
    code: str
    icon: str


data = requests.get("https://wttr.in/?format=j1").json()

day_info = data["weather"][0]

cur_info = day_info["hourly"][math.floor(datetime.datetime.now().hour / 3)]

WEATHER_SYMBOL = (
    WEATHER_SYMBOL_DAY
    if datetime.datetime.strptime(
        day_info["astronomy"][0]["sunrise"], "%I:%M %p"
    ).time()
    < datetime.datetime.now().time()
    < datetime.datetime.strptime(day_info["astronomy"][0]["sunset"], "%I:%M %p").time()
    else WEATHER_SYMBOL_NIGHT
)

weather_info = WeatherInfo(
    temp=Temp(
        current=cur_info["tempC"],
        feels_like=cur_info["FeelsLikeC"],
        min=day_info["mintempC"],
        max=day_info["maxtempC"],
    ),
    wind=Wind(
        speed=cur_info["windspeedKmph"],
        direction=cur_info["winddir16Point"],
    ),
    humidity=cur_info["humidity"],
    uv_index=cur_info["uvIndex"],
    precipMM=cur_info["precipMM"],
    pressure=cur_info["pressure"],
    astronomy=Astronomy(
        sunrise=datetime.datetime.strptime(
            day_info["astronomy"][0]["sunrise"], "%I:%M %p"
        ).strftime("%H:%M"),
        sunset=datetime.datetime.strptime(
            day_info["astronomy"][0]["sunset"], "%I:%M %p"
        ).strftime("%H:%M"),
    ),
    desc=cur_info["weatherDesc"][0]["value"].strip(),
    code=cur_info["weatherCode"],
    icon=WEATHER_SYMBOL[WWO_CODE[cur_info["weatherCode"]]],
)


temp_low_high = f"Low: {weather_info.temp.min}°C\t\t\tHigh: {weather_info.temp.max}°C"
rh_uv = f"\uf07a : {weather_info.humidity}%\t\t\t\tUV: {weather_info.uv_index}"
wind_pressure = f"\uf050 : {WIND_ICON[weather_info.wind.direction]} {weather_info.wind.speed} km/h\t\t\uf079 : {weather_info.pressure} mmHg"
astronomy = f"\uf051 : {weather_info.astronomy.sunrise}\t\t\t\uf052 : {weather_info.astronomy.sunset}"

tooltip_normal_text_width = max(
    [
        len(temp_low_high.expandtabs(4)),
        len(rh_uv.expandtabs(4)),
        len(wind_pressure.expandtabs(4)),
        len(astronomy.expandtabs(4)),
    ]
)

nbsp = "&#160;"

icon_temp = f"{weather_info.icon} {weather_info.temp.current}°C"
weather_desc = weather_info.desc
feels_like = f"Feels like {weather_info.temp.feels_like}°C"

tooltip_text = f"""
<span font_family="Weather Icons"><span size="xx-large" weight="ultrabold">{icon_temp}</span>
<span size="xx-large" weight="ultrabold">{weather_desc}</span>
<span size="small" weight="ultrabold">{feels_like}</span>

<span weight="bold">{temp_low_high}</span>
<span weight="bold">{rh_uv}</span>
<span weight="bold">{wind_pressure}</span>
<span weight="bold">{astronomy}</span></span>
"""

# print waybar module data
out_data = {
    "text": f'<span font_family="Weather Icons">{weather_info.icon}</span> {weather_info.temp.current}°',
    "alt": weather_info.desc,
    "tooltip": tooltip_text,
    "class": weather_info.code,
}

print(json.dumps(out_data))
