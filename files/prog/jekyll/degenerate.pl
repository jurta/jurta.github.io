#!/usr/bin/perl -w
# -*- Perl -*-
# $Revision$

# perl c:/home/www/cgi-bin/degenerate.pl "d:/Programs/Apache Group/Apache/www"

use strict;
use File::Find;

my ($root);

if (defined $ARGV[0] && -d $ARGV[0]) {
  $root = $ARGV[0];
} else {
  print "Please specify start-dir as first program argument\n";
  exit(1);
}

# update HTML files

undef $/;

find(\&html_file_update, $root);

sub html_file_update {
  if (/\.html$/i) {
    my ($file, $text) = ($_);
    if (open(FILE, "<$_")) {
      $text = <FILE>;
      close(FILE);
      for ($text) {
        s((?<=<!-- sidebarleft -->).*(?=<!-- /sidebarleft -->))()is;
        s((?<=<!-- sidebarright -->).*(?=<!-- /sidebarright -->))()is;
        s((?<=<!-- \+ sidebar left -->).*(?=<!-- \- sidebar left -->))()is;
        s((?<=<!-- \+ sidebar right -->).*(?=<!-- \- sidebar right -->))()is;
        s((?<=<!-- \+ navbar left -->).*(?=<!-- \- navbar left -->))()is;
        s((?<=<!-- \+ navbar right -->).*(?=<!-- \- navbar right -->))()is;
      }
    } else {
      print "can't read $_\n";
    }
    if (open(FILE, ">$_")) {
      print FILE "$text";
      close(FILE);
    } else {
      print "can't write $_\n";
    }

  }
}
