#!/usr/bin/perl -w
use strict;

my $bat_file = $ARGV[0];

open (FILE, $bat_file) or die "cannot open file";
$bat_file =~s/__//;
open(OUTPUT, ">$bat_file\n") or die "cannot open file";

my $count=0;
while (my $txt = <FILE>) {
    chomp $txt;
    
    $count++;
    
    if($count==4){
        print OUTPUT "\nmodule load r\nexport DISPLAY=:99\nXvfb :99 -screen 0 1024x768x24 &\n\n";
    }else{
        print OUTPUT "$txt\n";
    }
    
    
}


