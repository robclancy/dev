#!/usr/bin/env nu

def main [] {
	let $dry = false
	mut $os = false

	print --no-newline "OS: " $nu.os-info.kernel_version "\n"
	$os = detect_os $nu.os-info.kernel_version

	if $os == false {
		error make {
			msg: "No valid OS found.",
			help: $nu.os-info.kernel_version
		}
	}

	print --no-newline "Detected " $os "\n"
	run_scripts ./run $os
}

def detect_os [kernel] {
	if $kernel =~ "arch" {
		return "arch"
	}

	return false
}

def run_scripts [dir, os] {
	cd $dir

	let scripts = ls
	print $scripts

	for $script in $scripts {
		print $"run: nu ($dir)/($script.name) ($os)"
		nu $script.name $os
	}
}
