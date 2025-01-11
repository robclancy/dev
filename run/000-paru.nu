def "main arch" [] {
	sudo pacman -S --needed base-devel --noconfirm

	let dir = "/opt/paru"
	if ($"($dir)/.git" | path exists) {
		cd $dir 
		git pull
	} else {
		if not ($dir | path exists) {
			sudo mkdir $dir
			sudo chown $"($env.USER):($env.USER)" $dir
			ls $dir | select name user
		}

		git clone https://aur.archlinux.org/paru.git $dir
		cd $dir
	}

	makepkg -si --noconfirm
}
 
def "main" [] {
	print "No OS supplied. Supported: arch"
}

