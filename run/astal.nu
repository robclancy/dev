def "main arch" [] {
	paru -S libastal-io-git libastal-4-git libastal-lua-git --noconfirm --sudoloop 
}
 
def "main" [] {
	print "No OS supplied. Supported: arch"
}

