// Key Odin syntax patterns:
//
// :: declares constants, procedures, and types
// := declares and initializes variables
// : declares variables without initialization
// {} creates slices/arrays
// or_else handles error cases
// defer runs code when procedure exits
// Multiple return values with comma separation

package main  // Declares this file belongs to the 'main' package (entry point for executable)

// Import statements - bring in standard library modules
import "core:os"           // Operating system interface (files, env vars, processes)
import "core:fmt"          // Formatted printing (like printf)
import "core:strings"      // String manipulation functions
import "core:path/filepath" // File path operations (join, abs, etc.)

// Main procedure - entry point of the program (like main() in C)
main :: proc() {
    // Variable declaration with type inference - creates boolean set to false
    dry := false

    // Variable declaration without initialization - will be assigned later
    xdg_config_home: string

    // os.lookup_env returns (value, exists_bool) - multiple return values
    // 'if' with initialization - declares env_val in the if scope
    if env_val, exists := os.lookup_env("XDG_CONFIG_HOME"); exists {
        fmt.println("using", env_val)  // Print multiple values separated by spaces
        xdg_config_home = env_val      // Assign to our variable
    } else {
        fmt.println("XDG_CONFIG_HOME not set")

        // os.get_env returns just the value (panics if not found)
        home := os.get_env("HOME")

        // filepath.join takes a slice of strings {...} and joins them with path separator
        config_path := filepath.join({home, ".config"})

        // fmt.printf - formatted printing like C's printf
        fmt.printf("using %s\n", config_path)
        xdg_config_home = config_path

        // Set environment variable for current process
        os.set_env("XDG_CONFIG_HOME", config_path)
    }

    // Call our custom procedure with two string arguments
    copy_files("./env/.config", xdg_config_home)

    // filepath.abs returns (absolute_path, error) - 'or_else' handles the error case
    rocks_src := filepath.abs("./env/.config/nvim/rocks.toml") or_else ""

    // Join path components into a single path string
    rocks_dst := filepath.join({xdg_config_home, "nvim/rocks.toml"})

    // Formatted print with multiple arguments
    fmt.printf("symlinking: ln -sf %s %s\n", rocks_src, rocks_dst)

    // Remove existing file/symlink (ignores errors if file doesn't exist)
    os.remove(rocks_dst)

    // Create symlink - 'if' with error checking pattern
    if err := os.link(rocks_src, rocks_dst); err != nil {
        // %v is generic format specifier for any type
        fmt.printf("Error creating symlink: %v\n", err)
    }

    // Execute shell command and wait for completion
    os.system("hyprctl reload")
}

// Procedure definition - takes two string parameters, returns nothing
copy_files :: proc(from: string, to: string) {
    // ANSI escape codes for colored terminal output (purple text, then reset)
    fmt.printf("\x1b[35mcopying files: %s -> %s\x1b[0m\n", from, to)

    // Get current working directory to restore later
    old_dir := os.get_current_directory()

    // 'defer' executes this statement when the procedure exits (like finally)
    defer os.set_current_directory(old_dir)

    // Change to the source directory
    os.set_current_directory(from)

    // Read directory contents - returns (entries_array, error)
    entries, err := os.read_dir(".")

    // Check if error occurred during directory reading
    if err != nil {
        fmt.printf("Error reading directory: %v\n", err)
        return  // Exit procedure early
    }

    // 'for-in' loop - iterate over each entry in the entries array
    for entry in entries {
        // Check if this entry is a directory (not a file)
        if entry.is_dir {
            // Build destination path by joining components
            dir_path := filepath.join({to, entry.name})

            fmt.printf("removing: rm -rf %s\n", dir_path)
            // Remove directory and all contents recursively
            os.remove_all(dir_path)

            fmt.printf("copying: cp -r ./%s %s\n", entry.name, dir_path)
            // Call our recursive copy procedure
            copy_recursive(entry.name, dir_path)
        }
    }
}

// Recursive procedure to copy files and directories
copy_recursive :: proc(src: string, dst: string) {
    // Get file/directory information - returns (file_info, error)
    src_info, src_err := os.stat(src)

    // Check for errors getting file info
    if src_err != nil {
        fmt.printf("Error stating source: %v\n", src_err)
        return
    }

    // Check if source is a directory
    if src_info.is_dir {
        // Create the destination directory
        os.make_directory(dst)

        // Read contents of source directory
        entries, err := os.read_dir(src)
        if err != nil {
            fmt.printf("Error reading directory %s: %v\n", src, err)
            return
        }

        // Recursively copy each item in the directory
        for entry in entries {
            // Build full paths for source and destination
            src_path := filepath.join({src, entry.name})
            dst_path := filepath.join({dst, entry.name})
            // Recursive call to copy this item
            copy_recursive(src_path, dst_path)
        }
    } else {
        // Source is a file - read entire file into memory
        // Returns (byte_array, success_bool)
        data, read_ok := os.read_entire_file(src)

        if !read_ok {  // '!' is logical NOT operator
            fmt.printf("Error reading file %s\n", src)
            return
        }

        // 'defer delete(data)' - free the memory when procedure exits
        defer delete(data)

        // Write the data to destination file - returns success_bool
        write_ok := os.write_entire_file(dst, data)
        if !write_ok {
            fmt.printf("Error writing file %s\n", dst)
        }
    }
}
