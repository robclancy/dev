#!/usr/bin/env perl
use strict;
use warnings;

my $dry = !grep { $_ eq '--apply' } @ARGV;

if ($dry) {
    print "DRY RUN - use --apply to execute\n";
} else {
    print "EXECUTING\n";
    print "Requesting sudo access...\n";
    system("sudo -v") == 0 or die "Failed to get sudo access\n";

    print "Syncing package databases...\n";
    system("sudo pacman -Sy") == 0 or die "Failed to sync repos\n";

    # Keep sudo alive in background
    my $pid = fork();
    if ($pid == 0) {
        while (1) {
            sleep 60;
            system("sudo -n -v");
        }
    }

    # Kill background process on exit
    $SIG{INT} = $SIG{TERM} = sub { kill 9, $pid; exit; };
    END { kill 9, $pid if $pid; }
}

my $runners_dir = "./runners";

unless (-d $runners_dir) {
    die "Error: $runners_dir directory not found\n";
}

opendir(my $dh, $runners_dir) or die "Cannot open $runners_dir: $!";
my @runners = sort grep { !/^\./ && -f "$runners_dir/$_" } readdir($dh);
closedir($dh);

for my $runner (@runners) {
    my $path = "$runners_dir/$runner";
    print "\n\e[35mRunning: $runner\e[0m\n";

    if ($dry) {
        print "would execute: $path\n";
    } else {
        system($path);
        my $exit_code = $? >> 8;

        if ($exit_code == 0) {
            print "\e[32m✓ $runner completed\e[0m\n";
        } else {
            print "\e[31m✗ $runner failed with exit code $exit_code\e[0m\n";
            exit($exit_code);
        }
    }
}

print "\n\e[32mAll runners completed\e[0m\n";
