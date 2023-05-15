This are the dotfiles that I currently use in my arch build.

# Hyprland
## Screenshots

<div align="center">
  <img src="./screenshots/hyprland.png" alt="Image 1">
</div>

## Installation

1. Install the dependencies using `paru`:
```sh
paru -S hyprland hyprshot dunst waybar-hyprland-git kitty swaybg swaylock-effects swayidle brightnessctl pamixer playerctl imv rofi-emoji ttf-sourcecodepro-nerd ttf-noto-nerd noto-fonts-emoji blueman network-manager-applet wl-clipboard wtype wlr-randr nwg-look redshift-wayland-git xdg-desktop-portal-hyprland udisks2 gvfs polkit-gnome 
```
2. Clone the repo 
```sh 
git clone https://github.com/Albert24GG/configfiles
```
3. Copy the config files 
```sh
cd ./configfiles/.config
cp -r dunst hypr kitty swaylock rofi waybar ~/.config
```

# AwesomeWm
## Screenshots

<div align="center">
  <img src="./screenshots/awesome1.png" alt="Image 1">
  <img src="./screenshots/awesome2.png" alt="Image 2">
</div>

## Installation
1. Clone the repo 
```sh
git clone https://github.com/Albert24GG/configfiles
```

2. You may first want to take a look and edit `.config/awesome/configuration/user-variables.lua`. For the current configuration, these are all the dependencies: 

```sh
paru -S awesome-git kitty rofi picom-ibhagwan-git thunar x11-emoji-picker xidlehook gnome-calculator firefox networkmanager ttf-sourcecodepro-nerd nerd-fonts-liberation-mono blueman xss-lock papirus-icon-theme alsa-utils playerctl brightnessctl i3lock-color betterlockscreen maim xclip polkit-gnome redshift udev-notify-git udisks2 gvfs
```

3. Copy the config files
```sh
cd ./configfiles/.config
cp -r awesome kitty picom rofi ~/.config
```

4. Optional packages that I would recommend using:
- arandr and autorandr 
- easyeffects/pavucontrol 
- lxappearance-gtk3
- mpv
- nvidia-settings (also enable **_Force Composition Pipeline_** if there is any screen tearing - save the config in `/etc/X11/xorg.conf.d/20-nvidia-antitear.conf` and add the following line to the Section "Device"(the one that contains the name of the gpu)
`Option "RegistryDwords" "EnableBrightnessControl=1"`)

**Gtk theme**: Orchis-dark

**Display manager**:
- LightDM with a webkit2 theme ([glorious theme](https://github.com/manilarome/lightdm-webkit2-theme-glorious) or [litarvan theme](https://github.com/Litarvan/lightdm-webkit-theme-litarvan)).
- SDDM with the [sugar-candy theme](https://store.kde.org/p/1312658/)

# Gnome

## Screenshots

<div align="center">
  <img src="./screenshots/gnome1.png" alt="Image 1">
  <img src="./screenshots/gnome2.png" alt="Image 2">
</div>

## Theme
- Orchis-dark

## Icons
- Papirus

## Font
- Interface text: Roboto Medium
- Monospace text: Liberation Mono Regular
- Terminal: Source Code Pro Semibold / Jetbrains Mono

## Gnome-Extensions
- AppIndicator and KStatusNotifierItem Support
- Applications Menu
- ArcMenu
- Auto Move Windows
- Blur my Shell
- Dash to Panel
- Launch new instance 
- Native Window Placement
- Panel Date Format
- Unite
- Vitals
