wallpaper() {
    killall hyprpaper
    sleep 0.1
    hyprpaper &
    sleep 0.2

    wallpaper_dir="$HOME/wallpaper"

    setopt nullglob
    for file in $wallpaper_dir/*.{png,jpg,jpeg}; do
        echo "preloading $file"
        hyprctl hyprpaper preload $file
    done
    unsetopt nullglob

    sleep 0.5 

    while true; do
        chosen=$(find $wallpaper_dir -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)
        for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
            echo "setting wallpaper $chosen"
            hyprctl hyprpaper wallpaper "$monitor,$chosen"
        done

        sleep 3600
    done
}
