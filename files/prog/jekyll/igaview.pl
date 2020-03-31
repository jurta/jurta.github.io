#!/usr/bin/perl
# Add -wT ?
#
# See the bottom of this file for the POD documentation.
# Search for the string '=head'.

# http://www.jurta.org/cgi-bin/igaview.pl?../tanja/2004/20040720_Punane.jpg

use strict;
use CGI qw(:standard);

$| = 1;   # enable autoflush

use vars qw(
 $DEBUGGING_IP $charset $im $imw $imh $imname
);

BEGIN {
  if (defined($ENV{'DOCUMENT_ROOT'})) {
    $charset = "iso-8859-1"; # "koi8-r"
    print "Content-Type: text/html; charset=$charset\n\n";
    # print "Content-Type: text/plain; charset=$charset\n\n";
    sub html_show_error {
      my ($text) = shift;
# TODO: if $ENV{'REMOTE_ADDR'} =~ $DEBUGGING_IP { }
#       if ($DEBUGGING_IP) {
#         $text = cleanup_input($text);
#       } else {
#         $text = "";
#       }
#       my ( $pack, $file, $line, $sub ) = caller(0);
#       my ($id ) = $file =~ m%([^/]+)$%;
#       return undef if $file =~ /^\(eval/;
      print "\n";
      print <<HERE;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>500 - Server error!</title>
<meta http-equiv="Content-Type" content="text/html; charset=$charset" />
</head>
<body bgcolor="#cdc2b2">
<h1>ERROR 500 - Server error!</h1>
<p>
The server encountered an internal error and was
unable to complete your request.
</p>
<pre>
$text
</pre>
</body>
</html>
HERE
      die @_;
    };

    $SIG{__DIE__} = \&html_show_error;

    delete @ENV{qw(ENV BASH_ENV IFS PATH)};
#     my $query = new CGI;
#     print $query->header();
#     print "<pre>";

    $im = $ENV{'QUERY_STRING'};
    $im =~ tr/+/ /;
    $im =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;
  } elsif (defined $ARGV[0]) {
    $im = $ARGV[0];
  }
  if (!$im) {
    die "ERROR: Please specify image file as program argument\n";
  } else {
    $im =~ s(/$)();
  }
}

if ($im =~ m(/([^/]+)$)) {
  $imname = $1
} else {
  $imname = $im
}

if (`identify $im` =~ m((\d+)x(\d+))) {
  ($imw, $imh) = ($1, $2)
} else {
  ($imw, $imh) = (0, 0)
}

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta http-equiv="Content-Language" content="en" />
<title>$imname</title>
<link rel="stylesheet" type="text/css" href="../jurta.css" />
<script language="JavaScript" type="text/javascript" src="../jurta_iga.js"></script>
<script type="text/javascript">
  var iga = { marginLeft: 16, marginTop: 32, images: [
  {src:"$im",width:$imw,height:$imh}]};
</script>
</head>
<body>
<!-- <a href="javascript:igaReturn()"><img alt="[up]" src="$im"></a>&nbsp; -->
<a href="javascript:igaImageFitToWindow()">[Fit to window]</a>&nbsp;
<a href="javascript:igaImageFullSize()">[Full size]</a>&nbsp;
<a href="javascript:igaImageSetSize(800,600)">[800x600]</a>&nbsp;
<a href="javascript:igaImageSetSize(1024,768)">[1024x768]</a>&nbsp;<br />
<img src="$im"
     id="igaImage" width="128" height="96" onload="igaImageFitToWindow()">
</body>
</html>
EOF

1;

__END__

=head1 NAME

igaview - view image files

=head1 SYNOPSIS

    igaview image-file
    http://host/cgi-bin/igaview.pl?image-file

=head1 DESCRIPTION

B<igaview> displays images.

=head2 OPTIONS

    image-file : the name of a image file.

=head1 NOTES

B<igaview> can be run stand-alone or from CGI.
When B<igaview> is used under CGI, it outputs a content-type header.
B<igaview> detects the fact that it is called under CGI by inspecting
the presense of the value of the 'DOCUMENT_ROOT' environment variable.

=head1 SEE ALSO

B<regenerate>

=head1 AUTHOR

Juri Linkov E<lt>juri@jurta.org>

=head1 COPYRIGHT

Copyright (C) 2006 Juri Linkov.  All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself or GPL.

;;; Local Variables:
;;; coding: koi8-r
;;; End:

=cut
