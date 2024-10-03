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

WEATHER_SYMBOL = {
    "Unknown": "\uf07b",
    "Cloudy": "\uf013",
    "Fog": "\uf014",
    "HeavyRain": "\uf019",
    "HeavyShowers": "\uf01a",
    "HeavySnow": "\uf01b",
    "HeavySnowShowers": "\uf01b",
    "LightRain": "\uf01c",
    "LightShowers": "\uf01c",
    "LightSleet": "\uf0b5",
    "LightSleetShowers": "\uf0b5",
    "LightSnow": "\uf01b",
    "LightSnowShowers": "\uf01b",
    "PartlyCloudy": "\uf041",
    "Sunny": "\uf00d",
    "ThunderyHeavyRain": "\uf01e",
    "ThunderyShowers": "\uf01e",
    "ThunderySnowShowers": "\uf01d",
    "VeryCloudy": "\uf013",
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
class WeatherInfo:
    temp: Temp
    wind: Wind
    humidity: str  # percentage
    uv_index: str
    desc: str
    code: str
    icon: str


data = requests.get("https://wttr.in/?format=j1").json()
cur_hour = datetime.datetime.now().hour

day_info = data["weather"][0]

cur_info = day_info["hourly"][math.floor(cur_hour / 3)]

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
    desc=cur_info["weatherDesc"][0]["value"].strip(),
    code=cur_info["weatherCode"],
    icon=WEATHER_SYMBOL[WWO_CODE[cur_info["weatherCode"]]],
)


tooltip_text = f"""
\t<span size="xx-large" weight="ultrabold" font_family="Weather Icons">{ f"{weather_info.icon} {weather_info.temp.current}°C ".center(14) }</span>
\t<span size="xx-large" weight="ultrabold">{weather_info.desc.center(14)}</span>
\t<span size="small" weight="ultrabold">{ f"Feels like {weather_info.temp.feels_like}°C".center(32)}</span>

<span weight="bold">Min: {weather_info.temp.min}°C\t\tMax: {weather_info.temp.max}°C</span>
<span weight="bold">RH: {weather_info.humidity}%\t\tUV: {weather_info.uv_index}</span>
<span weight="bold">{f"Wind: {weather_info.wind.direction} {weather_info.wind.speed} km/h"}</span>
"""

# print waybar module data
out_data = {
    "text": f'<span font_family="Weather Icons">{weather_info.icon}</span> {weather_info.temp.current}°',
    "alt": weather_info.desc,
    "tooltip": tooltip_text,
    "class": weather_info.code,
}

print(json.dumps(out_data))
