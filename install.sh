#!/usr/bin/env bash
cd "$(dirname "$0")"
export base="$(pwd)"
source ./scriptdata/environment-variables
source ./scriptdata/functions

#####################################################################################
if ! command -v pacman >/dev/null 2>&1; then 
  printf "\e[31m[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...\e[0m\n"
  exit 1
fi
prevent_sudo_or_root

startask () {
  printf "\e[34m[$0]: Hi there! Before we start:\n"
  printf 'This script 1. only works for ArchLinux and Arch-based distros.\n'
  printf '            2. does not handle system-level/hardware stuff like Nvidia drivers\n'
  printf "\e[31m"
  
  printf "Would you like to create a backup for \"$XDG_CONFIG_HOME\" and \"$HOME/.local/\" folders?\n[y/N]: "
  read -p " " backup_confirm
  case $backup_confirm in
    [yY][eE][sS]|[yY])
      backup_configs
      ;;
    *)
      echo "Skipping backup..."
      ;;
  esac
  

  printf '\n'
  printf 'Do you want to confirm every time before a command executes?\n'
  printf '  y = Yes, ask me before executing each of them. (DEFAULT)\n'
  printf '  n = No, just execute them automatically.\n'
  printf '  a = Abort.\n'
  read -p "====> " p
  case $p in
    n) ask=false ;;
    a) exit 1 ;;
    *) ask=true ;;
  esac
}

case $ask in
  false)sleep 0 ;;
  *)startask ;;
esac

set -e
#####################################################################################
printf "\e[36m[$0]: 1. Get packages and setup user groups/services\n\e[0m"

# Issue #363
case $SKIP_SYSUPDATE in
  true) sleep 0;;
  *) v sudo pacman -Syu;;
esac

remove_bashcomments_emptylines ./scriptdata/dependencies.conf ./cache/dependencies_stripped.conf
readarray -t pkglist < ./cache/dependencies_stripped.conf

# Use yay. Because paru does not support cleanbuild.
# Also see https://wiki.hyprland.org/FAQ/#how-do-i-update
if ! command -v yay >/dev/null 2>&1;then
  echo -e "\e[33m[$0]: \"yay\" not found.\e[0m"
  exit 1
fi

# Install extra packages from dependencies.conf as declared by the user
if (( ${#pkglist[@]} != 0 )); then
	if $ask; then
		# execute per element of the array $pkglist
		for i in "${pkglist[@]}";do v yay -S --needed $i;done
	else
		# execute for all elements of the array $pkglist in one line
		v yay -S --needed --noconfirm ${pkglist[*]}
	fi
fi

# https://github.com/end-4/dots-hyprland/issues/581
# yay -Bi is kinda hit or miss, instead cd into the relevant directory and manually source and install deps
install-local-pkgbuild() {
	local location=$1
	local installflags=$2

	x pushd $location

	source ./PKGBUILD
	x yay -S $installflags --asdeps "${depends[@]}"
	x makepkg -Asi --noconfirm

	x popd
}

# Install core dependencies from the meta-packages
metapkgs=(./arch-packages/illogical-impulse-{audio,python,backlight,basic,fonts-themes,gnome,gtk,portal,screencapture,widgets})
metapkgs+=(./arch-packages/illogical-impulse-agsv1-git)
metapkgs+=(./arch-packages/illogical-impulse-hyprland)
metapkgs+=(./arch-packages/illogical-impulse-microtex-git)
metapkgs+=(./arch-packages/illogical-impulse-oneui4-icons-git)
[[ -f /usr/share/icons/Bibata-Modern-Classic/index.theme ]] || \
  metapkgs+=(./arch-packages/illogical-impulse-bibata-modern-classic-bin)

for i in "${metapkgs[@]}"; do
	metainstallflags="--needed"
	$ask && showfun install-local-pkgbuild || metainstallflags="$metainstallflags --noconfirm"
	v install-local-pkgbuild "$i" "$metainstallflags"
done

# These python packages are installed using uv, not pacman.
showfun install-python-packages
v install-python-packages

v sudo usermod -aG video,i2c,input "$(whoami)"
v bash -c "echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf"
v systemctl --user enable ydotool --now
v sudo systemctl enable bluetooth --now
v gsettings set org.gnome.desktop.interface font-name 'Rubik 11'
v gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


#####################################################################################
printf "\e[36m[$0]: 2. Copying + Configuring\e[0m\n"

# In case some folders does not exists
v mkdir -p $XDG_BIN_HOME $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME

# MISC (For .config/* but not AGS, not Hyprland)
case $SKIP_MISCCONF in
  true) sleep 0;;
  *)
    for i in $(find .config/ -mindepth 1 -maxdepth 1 ! -name 'ags' ! -name 'hypr' -exec basename {} \;); do
      echo "[$0]: Found target: .config/$i"
      v ln -s "$XDG_CONFIG_HOME/$i/" ".config/$i/"
      fi
    done
    ;;
esac

# For AGS
v ln -s "$XDG_CONFIG_HOME"/ags/ .config/ags/

# For Hyprland
v ln -s "$XDG_CONFIG_HOME"/hypr/ .config/hypr/


# some foldes (eg. .local/bin) should be processed separately to avoid `--delete' for rsync,
# since the files here come from different places, not only about one program.
v rsync -av ".local/bin/" "$XDG_BIN_HOME"

# Prevent hyprland from not fully loaded
sleep 1
try hyprctl reload


#####################################################################################
printf "\e[36m[$0]: Finished. See the \"Import Manually\" folder and grab anything you need.\e[0m\n"
printf "\n"
printf "\e[36mIt is recommended to check out\n"
printf "https://end-4.github.io/dots-hyprland-wiki/en/i-i/01setup/#post-installation \n"
printf "for hints on launching Hyprland.\e[0m\n"
printf "\n"
printf "\e[36mIf you are already running Hyprland,\e[0m\n"
printf "\e[36mPress \e[30m\e[46m Ctrl+Super+T \e[0m\e[36m to select a wallpaper\e[0m\n"
printf "\e[36mPress \e[30m\e[46m Super+/ \e[0m\e[36m for a list of keybinds\e[0m\n"
printf "\n"
