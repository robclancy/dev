#!/usr/bin/env perl
use strict;
use warnings;
use File::Path qw(remove_tree);
use File::Copy::Recursive qw(dircopy);
use File::Copy;
use File::Basename;

my $dry = !grep { $_ eq '--apply' } @ARGV;

if ($dry) {
    print "DRY RUN - use --apply to execute\n";
} else {
    print "EXECUTING\n";
}

my $config_home = $ENV{XDG_CONFIG_HOME};

if ($config_home) {
    print "using $config_home\n";
} else {
    print "XDG_CONFIG_HOME not set\n";
    $config_home = "$ENV{HOME}/.config";
    print "using $config_home\n";
    $ENV{XDG_CONFIG_HOME} = $config_home;
}

copy_files("./env/.config", $config_home);
copy_file("./env/.zshrc", $ENV{HOME});
copy_file("./env/.p10k.zsh", $ENV{HOME});

if ($dry) {
    print "would execute: hyprctl reload\n";
} else {
    system("hyprctl", "reload");
}

sub copy_file {
    my ($from, $to) = @_;

    my $filename = basename($from);
    my $dst = "$to/$filename";

    print "\n\e[35mcopying file: $from -> $dst\e[0m\n";

    if ($dry) {
        print "would execute: copy($from, $dst)\n";
    } else {
        copy($from, $dst) or die "Failed to copy $from: $!\n";
    }
}

sub copy_files {
    my ($from, $to) = @_;

    print "\n\e[35mcopying files: $from -> $to\e[0m\n";

    opendir(my $dh, $from) or die "Cannot open $from: $!";
    my @configs = sort grep { !/^\./ && -d "$from/$_" } readdir($dh);
    closedir($dh);

    print "Configs: @configs\n";

    for my $config (@configs) {
        my $dir = "$to/$config";

        print "removing: rm -rf $dir\n";
        if ($dry) {
            print "would execute: remove_tree($dir)\n";
        } else {
            remove_tree($dir) if -e $dir;
        }

        print "copying: cp -r $from/$config $dir\n";
        if ($dry) {
            print "would execute: dircopy($from/$config, $dir)\n";
        } else {
            dircopy("$from/$config", $dir) or die "Failed to copy $config: $!\n";
        }
    }
}
