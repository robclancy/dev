package main

import "core:fmt"
import "core:os"
import "core:path/filepath"

dry := true

printf :: proc(format: string, args: ..any) {
	if dry {
		fmt.printf("[DRY] ")
	}
	fmt.printf(format, ..args)
}

apply :: proc(action: proc()) {
	if !dry {
		action()
	}
}

main :: proc() {
	for arg in os.args[1:] {
		if arg == "--apply" {
			dry = false
		}
	}

	xdg_config_home: string

	if env_val, exists := os.lookup_env("XDG_CONFIG_HOME"); exists {
		fmt.println("using", env_val)
		xdg_config_home = env_val
	} else {
		fmt.println("XDG_CONFIG_HOME not set")

		home := os.get_env("HOME")
		config_path := filepath.join({home, ".config"})

		fmt.printf("using %s\n", config_path)
		xdg_config_home = config_path

		os.set_env("XDG_CONFIG_HOME", config_path)
	}

	copy_files("./env/.config", xdg_config_home)

	if dry {
		fmt.printf("\nTo apply these changes, run:\n")
		fmt.printf("  %s --apply\n", os.args[0])
	}
}

remove_recursive :: proc(path: string) {
	info, err := os.stat(path)
	if err != 0 {
		return
	}

	if info.is_dir {
		f, open_err := os.open(path)
		if open_err == 0 {
			defer os.close(f)

			fis, read_err := os.read_dir(f, -1)
			if read_err == 0 {
				defer delete(fis)
				for fi in fis {
					entry_path := filepath.join({path, fi.name})
					remove_recursive(entry_path)
				}
			}
		}
		os.remove_directory(path)
	} else {
		os.remove(path)
	}
}

copy_files :: proc(from: string, to: string) {
	printf("\x1b[35mcopying files: %s -> %s\x1b[0m\n", from, to)

	old_dir := os.get_current_directory()
	defer os.set_current_directory(old_dir)

	os.set_current_directory(from)

	f, err := os.open(".")
	if err != 0 {
		printf("Error opening directory: %v\n", err)
		return
	}
	defer os.close(f)

	entries, read_err := os.read_dir(f, -1)
	if read_err != 0 {
		printf("Error reading directory: %v\n", read_err)
		return
	}
	defer delete(entries)

	for entry in entries {
		if entry.is_dir {
			// Must copy BEFORE creating closures
			name := entry.name
			path := filepath.join({to, name})

			printf("removing: rm -rf %s\n", path)
			{
				p := path
				apply(proc() {
					remove_recursive(p)
				})
			}

			printf("copying: cp -r ./%s %s\n", name, path)
			{
				n := name
				p := path
				apply(proc() {
					copy_recursive(n, p)
				})
			}
		}
	}
}

copy_recursive :: proc(src: string, dst: string) {
	src_info, src_err := os.stat(src)
	if src_err != 0 {
		fmt.printf("Error stating source: %v\n", src_err)
		return
	}

	if src_info.is_dir {
		os.make_directory(dst)

		f, open_err := os.open(src)
		if open_err != 0 {
			fmt.printf("Error opening directory %s: %v\n", src, open_err)
			return
		}
		defer os.close(f)

		entries, read_err := os.read_dir(f, -1)
		if read_err != 0 {
			fmt.printf("Error reading directory %s: %v\n", src, read_err)
			return
		}
		defer delete(entries)

		for entry in entries {
			src_path := filepath.join({src, entry.name})
			dst_path := filepath.join({dst, entry.name})
			copy_recursive(src_path, dst_path)
		}
	} else {
		data, read_ok := os.read_entire_file(src)
		if !read_ok {
			fmt.printf("Error reading file %s\n", src)
			return
		}
		defer delete(data)

		write_ok := os.write_entire_file(dst, data)
		if !write_ok {
			fmt.printf("Error writing file %s\n", dst)
		}
	}
}
