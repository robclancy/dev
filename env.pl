#!/usr/bin/env perl

use strict;
use warnings;
use File::Path qw(remove_tree make_path);
use File::Copy::Recursive qw(dircopy);
use Cwd qw(getcwd abs_path);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir catfile);
use Getopt::Long;

my $dry_run = 0;
GetOptions(
    "dry|dry-run" => \$dry_run
) or die "Error in command line arguments\n";

sub copy_files {
    my ($from, $to) = @_;
    print "\033[35mcopying files: $from -> $to\033[0m\n";

    my $original_dir = getcwd();

    opendir(my $dh, $from) or die "Cannot open directory $from: $!";
    my @configs = grep { -d "$from/$_" && !($_ eq '.' || $_ eq '..') } readdir($dh);
    closedir($dh);

    print "Configs found: @configs\n";

    foreach my $config (@configs) {
        my $dir = catdir($to, $config);

        print "removing: rm -rf $dir\n";
        if ($dry_run) {
            print "[DRY RUN] Would remove: $dir\n";
        } else {
            if (-e $dir) {
                remove_tree($dir) or warn "Could not remove $dir: $!";
            }
        }

        print "copying: cp -r $from/$config $dir\n";
        if ($dry_run) {
            print "[DRY RUN] Would copy: $from/$config to $dir\n";
        } else {
            dircopy("$from/$config", $dir) or die "Could not copy $config to $dir: $!";
        }
    }
}

sub main {
    if ($dry_run) {
        print "\033[33m[DRY RUN MODE] - No changes will be made\033[0m\n";
    }

    my $xdg_config_home;

    if (exists $ENV{XDG_CONFIG_HOME} && $ENV{XDG_CONFIG_HOME}) {
        $xdg_config_home = $ENV{XDG_CONFIG_HOME};
        print "using $xdg_config_home\n";
    } else {
        print "XDG_CONFIG_HOME not set\n";
        my $home = $ENV{HOME} || die "HOME environment variable not set";
        $xdg_config_home = catdir($home, ".config");
        print "using $xdg_config_home\n";

        if ($dry_run) {
            print "[DRY RUN] Would set XDG_CONFIG_HOME=$xdg_config_home\n";
        } else {
            $ENV{XDG_CONFIG_HOME} = $xdg_config_home;
        }
    }

    copy_files("./env/.config", $xdg_config_home);

    my $rocks_src = abs_path("./env/.config/nvim/rocks.toml");
    my $rocks_dst = catfile($xdg_config_home, "nvim", "rocks.toml");
    my $rocks_dst_dir = dirname($rocks_dst);

    print "symlinking: ln -sf $rocks_src $rocks_dst\n";

    if ($dry_run) {
        print "[DRY RUN] Would ensure directory exists: $rocks_dst_dir\n";
    } else {
        make_path($rocks_dst_dir) unless -d $rocks_dst_dir;
    }

    if ($dry_run) {
        print "[DRY RUN] Would remove if exists: $rocks_dst\n";
    } else {
        unlink($rocks_dst) if -e $rocks_dst;
    }

    if ($dry_run) {
        print "[DRY RUN] Would create symlink: $rocks_src -> $rocks_dst\n";
    } else {
        symlink($rocks_src, $rocks_dst) or die "Could not create symlink: $!";
    }

    print "Reloading hyprctl...\n";
    if ($dry_run) {
        print "[DRY RUN] Would execute: hyprctl reload\n";
    } else {
        system("hyprctl reload");
        die "hyprctl reload failed with status $?" if $? != 0;
    }
}

main();
