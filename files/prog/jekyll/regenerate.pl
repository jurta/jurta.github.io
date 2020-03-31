#!/usr/bin/perl
# Add -wT ?
#
# $Revision: 1.15 $
#
# See the bottom of this file for the POD documentation.
# Search for the string '=head'.

# http://www.jurta.org/cgi-bin/regenerate.pl?/var/www/virtual/jurta.org/www
# wget -nv -O - http://www.jurta.org/cgi-bin/regenerate.pl

# TODO: generate images HEIGHT and WIDTH

# TODO: make relative path in navbar index, e.g.: ../../emacs/index.en.html
# TODO: navigation by up,next,prev buttons

# TODO: board
# TODO: flock

use strict;
use CGI qw(:standard);
use File::Find;
use Data::Dumper;
$Data::Dumper::Indent = 1;

undef $/; # enable slurp mode
$| = 1;   # enable autoflush

use vars qw(
 $DEBUGGING_IP $root $charset
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
    # BAD:
    # $root = $ENV{'QUERY_STRING'};
    # $root =~ tr/+/ /;
    # $root =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;
    # GOOD: when used under CGI root path should be hard-coded
    $root = "/home/jurta/jurta.org";
  } elsif (defined $ARGV[0]) {
    $root = $ARGV[0];
  }
  if (!($root && -d $root)) {
    die "ERROR: Please specify start-dir as program argument\n";
  } else {
    $root =~ s(/$)();
  }
}

# Tables

# Translations
my $trs = {
    'en' => {
        'sitemap' => 'Site Map',
        'contents' => 'Page Contents',
        'search' => 'Search this site:',
        'addcomment' => 'Add comment',
        'viewcomments' => 'View comments',
        'en' => 'english', # 'eng',
        'ru' => 'no-pyccku', # 'pycckuu', 'pyc', '&#x0420;&#x0443;&#x0441;&#x0441;&#x043a;&#x0438;&#x0439;'
        'uk' => 'ykpaihcbka', # 'ykp', '&#x0423;&#x043a;&#x0440;&#x0430;&#x0457;&#x043d;&#x0441;&#x044c;&#x043a;&#x0430;',
    },
    'ru' => {
        'sitemap' => 'Карта сайта',
        'contents' => 'Содержание страницы',
        'search' => 'Поиск по сайту:',
        'addcomment' => 'Добавить комментарий',
        'viewcomments' => 'Читать комментарии',
        'en' => 'english', # 'eng',
        'ru' => 'русский', # 'pyc',
        'uk' => 'украiнська', # 'укр',
    },
};

# Photo database

my $phototext;
my %photos;
if (open(FIN, "<foto.eet")) {
  $phototext = <FIN>;
  close(FIN);
  %photos = map {
    my ($f, $ft, $fw, $tite, $titr, $gps);
    $f    = $1 if (m(^File: (.*)$)m);
    $ft   = $1 if (m(^FileT: (.*)$)m);
    $fw   = $1 if (m(^FileW: (.*)$)m);
    $tite = $1 if (m(^Title\[en\]: (.*)$)m);
    $titr = $1 if (m(^Title\[ru\]: (.*)$)m);
    $gps  = $1 if (m(^GPS-URL: (.*)$)m);
    ($ft, [$f, $fw, $tite, $titr, $gps])
  } split(/\f/,$phototext)
}

# print Dumper(%photos);
# print Dumper($photos{'/home/juri/.thumbnails/normal/e84726eb0207c47df013c47220bd8565.png'});

# Global variables

my $file_level; # level of current file relative to the dir tree root
my $file_ups;   # a string like "../../.." to reach the dir tree root
my $file_lang;  # language of current file extracted from file name suffix

# 1. create sidebar index
# 1.1. extract information (filenames and HTML titles) from HTML files

my $ctree; # category tree
my %files;
my %boards;
my %lj_boards = (
    'index.en.html' => '641',
    'index.ru.html' => '484',
    'about.en.html' => '1117',
    'about.ru.html' => '983',
    'tanja/index.ru.html' => '1315',
);

find({ wanted => \&html_file_get_info, no_chdir => 1 }, $root);

sub html_file_get_info {
  if (m(\.html(?:\.en|\.ru)?$)i and !m(/(?:s?cgi-bin|errors|forum|stat)/)i) {
    my ($fileabs, $filerel, $filename) = ($File::Find::name) x 3;
    my ($fileabsdir, $filereldir) = ($File::Find::dir) x 2;
    my ($filelang);
    $filerel =~ s(^$root/)();
    $filename =~ s(^$fileabsdir/)();
    $filereldir =~ s(^$root)();
    $filelang = $1 if $filename =~ m(\.([a-z]{2,3})\.html$);

    my $text;
    if (open(FIN, "<$fileabs")) {
      $text = <FIN>;
      close(FIN);

      # $text =~ s(<!--.*?-->)()g;

      # TODO: check for <!-- pid: /index.ru.html -->
      if ($fileabs =~ m(/board/)i and
          $text =~ m(<h1>.*<a href="../(.+)">)i) {
        $boards{$1} = $filename;
        print "$1 = $filename<br />\n";
      }
      if ($text =~ m(<title>(.*?)</title>)i) {
        my ($title, $h1, $catpath) = ($1, "", $filerel);
        $title =~ s(( - ЮРТА)*)()g;
        $title =~ s(( - JURTA)*)()g;
        $catpath =~ s(/?index\.[^/]+$)();
        if ($text =~ m(<h1>(.*?)</h1>)i) { $h1 = $1; $h1 =~ s(<[^>]*>)()g; }

        $text =~ s((?<=<!-- sidebarleft -->).*(?=<!-- /sidebarleft -->))()isg;
        $text =~ s((?<=<!-- sidebarright -->).*(?=<!-- /sidebarright -->))()isg;
        my ($li,$links) = (0);
        while ($text =~ m(href="(\.\.?/)*([^"]+)")g) { $links->{$2} = $li++; } # " Hi,Emacs!

        $ctree->{$filelang} = file2ctree($catpath, $filerel, $filereldir, $title, $h1,
                                         $ctree->{$filelang},$links);
        $files{$filerel} = {'t' => $title};
      }
    }
  }
}

sub file2ctree {
  my ($catpath, $filerel, $filereldir, $title, $h1, $ctree, $links) = @_;
  if ($catpath eq '') {
    $ctree->{'d'} = $filereldir;
    $ctree->{'f'} = $filerel;
    $ctree->{'t'} = $title;
    $ctree->{'h'} = $h1;
    $ctree->{'links'} = $links if defined $links;
    return $ctree;
  }
  my ($cfirst, $crest) = ($catpath =~ m(^([^/]+)/?(.*)));
  $ctree->{'chash'}->{$cfirst} = file2ctree($crest, $filerel, $filereldir, $title, $h1,
                                            $ctree->{'chash'}->{$cfirst}, $links);
  $ctree
}

# 1.2. sort category tree

sub ctreesort {
  my ($ctree) = @_;
  my ($str) = "";
  return if !exists $ctree->{'chash'};
  my (@chashes) = map {
    $ctree->{'chash'}->{$_}->{'c'} = $_;
    $ctree->{'chash'}->{$_}
  } sort {

    # print "$ctree->{'f'},$a,$ctree->{'chash'}->{$a}->{'f'},$ctree->{'links'}->{$a}\n";
    # print "$ctree->{'f'},$b,$ctree->{'chash'}->{$b}->{'f'},$ctree->{'links'}->{$b}\n";

    exists($ctree->{'links'}->{$ctree->{'chash'}->{$a}->{'f'}}) &&
    exists($ctree->{'links'}->{$ctree->{'chash'}->{$b}->{'f'}}) &&
    $ctree->{'links'}->{$ctree->{'chash'}->{$a}->{'f'}} <=>
    $ctree->{'links'}->{$ctree->{'chash'}->{$b}->{'f'}} ||
    exists($ctree->{'links'}->{$ctree->{'chash'}->{$a}->{'f'}}) && -1 ||
    exists($ctree->{'links'}->{$ctree->{'chash'}->{$b}->{'f'}}) &&  1 ||
    !exists($ctree->{'chash'}->{$a}->{'t'}) &&  1 ||
    !exists($ctree->{'chash'}->{$b}->{'t'}) && -1 ||
    $ctree->{'chash'}->{$a}->{'d'} cmp $ctree->{'chash'}->{$b}->{'d'} ||
    $ctree->{'chash'}->{$a}->{'t'} cmp $ctree->{'chash'}->{$b}->{'t'}
  } keys %{$ctree->{'chash'}};
  $ctree->{'carray'} = \@chashes if @chashes;
  for (@chashes) { ctreesort($_) }
}

for my $lang (keys %$ctree) {
  ctreesort($ctree->{$lang});
}

# print Dumper($ctree);

sub ctree2str {
  my ($ctree, $level, $file_ups, $filerel, $catpath) = @_;
  my ($cfirst, $crest) = ($catpath =~ m(^([^/]+)/?(.*)));
  my ($class) = (($ctree->{'carray'} # || $ctree->{'chash'}
                 )
                 ? ($catpath eq '' ? 'ctclosed' : 'ctopen')
                 : 'ctbullet');
  my ($str) = "";

  $str .= "\n<span class=\"$class\">";
  $str .= '&nbsp;' x $level;
  $str .= '<span class="bullet"'
       . ($class eq 'ctopen' || $class eq 'ctclosed'
          ? ' onclick="toggleTree(this);"' : '')
       . '>&nbsp;</span>'
       . ($filerel eq $ctree->{'f'}
          ? "<b>$ctree->{'t'}</b>"
          : "<a href=\"$file_ups/$ctree->{'f'}\" title=\"$ctree->{'h'}\">$ctree->{'t'}</a>")
       . '<br />';
  if (exists $ctree->{'carray'}) {
    for (@{$ctree->{'carray'}}) {
      $str .= ctree2str($_, $level+1, $file_ups, $filerel,
                        ($cfirst eq $_->{'c'} ? $crest : ""));
    }
  }
#   elsif (exists $ctree->{'chash'}) {
#     for (keys %{$ctree->{'chash'}}) {
#       $str .= ctree2str($ctree->{'chash'}->{$_}, $level+1, $file_ups, $filerel, $crest);
#     }
#   }
  $str .= '</span>';
  $str
}

# 2. update HTML files
# 2.1. read every HTML file fully into string variable
# 2.2. add missing tags into this HTML string
# 2.3. add left and right sidebars
# 2.4. write result HTML string back into the same file

find({ wanted => \&html_file_update, no_chdir => 1 }, $root);

sub html_file_update {
  return unless -f;
  unless (m(\.html(?:\.en|\.ru)?$)i and !m(/(?:s?cgi-bin|errors|forum|stat)/)i) {
    print "NO: $_ - skipped<br />\n";
    return;
  }
  my ($fileabs, $filerel) = ($File::Find::name, $File::Find::name);
  $filerel =~ s(^$root/)();

  $file_level = scalar(() = $filerel =~ m(/)g);
  $file_ups = ($file_level > 0 ? ("../" x $file_level) : "./");
  $file_ups =~ s(/$)();

  if ($fileabs =~ m((?:\.ru\.html|\.html\.ru)$)) {
    $file_lang = 'ru';
  } elsif      ($fileabs =~ m((?:\.en\.html|\.html\.en)$)) {
    $file_lang = 'en';
  } else {
    $file_lang = 'en';
  }

  my ($text, $fcharset);
  unless (open(FIN, "<$fileabs")) {
    print "NO: $fileabs - can't open<br />\n";
    return;
  }
  $text = <FIN>;
  close(FIN);
  unless ($text =~ m(<title>(.*?)</title>)i) {
    print "NO: $fileabs - no title<br />\n";
    return;
  }
  for ($text) {
    #!m(<html)i &&
    #  ($_="<html>\n$_</html>\n");
    #!m(<head>)i &&
    # s((?<=<html>))(\n<head>\n<title>JURTA</title>\n </head>)i;
    # next rule is bad, because no title means don't add to category tree
    #!m(<title>)i &&
    #  s((?<=<head>))(\n<title>JURTA</title>)i;
    $file_lang eq 'ru' &&
      m(</title>)i &&
      s(( - ЮРТА)*(?=</title>))( - ЮРТА)i;
    $file_lang eq 'en' &&
      m(</title>)i &&
      s(( - JURTA)*(?=</title>))( - JURTA)i;
    s(ЮРТА - ЮРТА(?=</title>))(ЮРТА)i;
    s(JURTA - JURTA(?=</title>))(JURTA)i;
    !m(<body>)i &&
      s((?<=</head>))(\n<body>)i &&
      s((?=</html>))(</body>\n)i;
    $file_lang eq 'ru' &&
      !m(<meta http-equiv="Content-Type" content="text/html; charset=) &&
       s((?= *</head>))(<meta http-equiv="Content-Type" content="text/html; charset=koi8-r" />\n)i;
    $file_lang eq 'ru' &&
      !m(<meta http-equiv="Content-Language" content=) &&
       s((?= *</head>))(<meta http-equiv="Content-Language" content="ru" />\n)i;
    $file_lang eq 'en' &&
      !m(<meta http-equiv="Content-Language" content=) &&
       s((?= *</head>))(<meta http-equiv="Content-Language" content="en" />\n)i;
    $fcharset = $1 if (m(<meta http-equiv="Content-Type" content="text/html; charset="([^"]+)"));
    $fcharset = $1 if (m(<\?xml version="[^"]+" encoding="([^"]+)"));
    $fcharset = "ISO-8859-1" if (!defined $fcharset);
    # !m(<meta name="keywords")i &&
    #  s((?= *</head>))("<meta name=\"keywords\" content=\"".collect_keywords($_)."\" />\n")ie;
    # TODO: meta name="categories"
    !m(<meta name="author") &&
     s((?= *</head>))(<meta name="author" content="Juri Linkov &lt;juri\@jurta.org&gt;" />\n)i;
    # !m(<link rel="made") &&
    #  s((?= *</head>))(<link rel="made" href="mailto:juri\@jurta.org" />\n)i;
    !m(<meta name="generator") &&
     s((?= *</head>))(<meta name="generator" content="regenerator" />\n)i;
    !m(<link rel="generator-home") &&
     s((?= *</head>))(<link rel="generator-home" href="http://www.jurta.org/prog/perl/regen/index.en.html" />\n)i;
    !m(<link rel="stylesheet".*jurta\.css) &&
     s((?= *</head>))(<link rel="stylesheet" type="text/css" href="$file_ups/jurta.css" />\n)i;
    !m(<link rel="icon") &&
     s((?= *</head>))(<link rel="icon" type="image/png" href="$file_ups/jurta.icon.png" />\n)i;
    !m(<link rel="shortcut icon") &&
     s((?= *</head>))(<link rel="shortcut icon" type="image/x-icon" href="$file_ups/favicon.ico" />\n)i;
    !m(<script .*javascript.*jurta\.js) &&
     s((?= *</head>))(<script language="JavaScript" type="text/javascript" src="$file_ups/jurta.js"></script>\n)i;

    s((^<img src="[^"]*" />\n?)+)(create_gallery($&))iemsg;

# TODO: change <!-- sidebarleft --> to <!--sidebarleft-->
# TODO: change <!-- /sidebarleft --> to <!--/sidebarleft-->
    !m(<!-- sidebarleft -->)i &&
      s((?<=<body>))("\n<!-- sidebarleft -->".sidebar_left($filerel)."<!-- /sidebarleft -->\n")ie
    ||s((?<=<!-- sidebarleft -->).*(?=<!-- /sidebarleft -->))(sidebar_left($filerel))ies;
    !m(<!-- sidebarright -->)i &&
      s((?=\s*</body>))("\n<!-- sidebarright -->".sidebar_right($_,$filerel,$fcharset)."<!-- /sidebarright -->")ie
    ||s((?<=<!-- sidebarright -->).*(?=<!-- /sidebarright -->))(sidebar_right($_,$filerel,$fcharset))ies;

    !m(google-analytics\.com/ga\.js) &&
     s((?=\s*</body>))(
<script type="text/javascript">
var gaJsHost = \(\("https:" == document.location.protocol\) ? "https://ssl." : "http://www."\);
document.write\(unescape\("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"\)\);
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker\("UA-3440956-1"\);
pageTracker._initData\(\);
pageTracker._trackPageview\(\);
</script>)i;
  }

  # untaint filename and then open it
  if ($fileabs =~ m|^($root/[-\w/.]+)$|) {
    if (open(FOUT, ">$1")) {
      print FOUT $text;
      print "OK: $fileabs($file_ups $filerel) $file_level<br />\n";
      close(FOUT);
    } else {
      print "NO: $fileabs - open failed $!<br />\n";
    }
  } else {
    print "NO: $fileabs - insecure filename<br />\n";
  }
}

sub create_gallery {
  my ($images) = @_;
  my $images2 = $images;

  $images =~ s(\n+)()g;
  $images =~ s((<img src="[^"]*" />)(<img src="[^"]*" />)?(<img src="[^"]*" />)?(<img src="[^"]*" />)?)(<tr>\n<td align="left" valign="top" width="25%">$1</td>\n<td align="left" valign="top" width="25%">$2</td>\n<td align="left" valign="top" width="25%">$3</td>\n<td align="left" valign="top" width="25%">$4</td>\n</tr>\n)imsg;
  $images =~ s((<img src="[^"]*" />))(create_image($&))iemsg; # " Hi,Emacs!

#   $images =~ s(^\n+)(); $images =~ s(\n+$)();
#   my @images = split('\n', $images);
#   my $rows = ($#images+1)/4;
#   print "{", $images, "}\n";
#   print "<", @images, ">\n";
#   print "<", join(":",@images), ">\n";
#   return $images2;

  return<<GALLERY;
<table>
$images
</table>
GALLERY
}

sub create_image {
  my ($image) = @_;
  my $image_file = $1 if $image =~ m(src="(.*)");
  my $photo = $photos{$image_file};
  my ($f, $fw, $tite, $titr, $gps, $gpsurl) = ("", "", "", "", "");

#   print Dumper($image);
#   print Dumper($image_file);
#   print Dumper($photo);

  if (defined $photo) {
    $fw   = $photo->[1] if defined $photo->[1];
    $tite = $photo->[2] if defined $photo->[2];
    $titr = $photo->[3] if defined $photo->[3];
    $gpsurl = $photo->[4] if defined $photo->[4];
    if (defined $gpsurl) {
      if ($gpsurl =~ m(ll=([0-9]+\.[0-9]{1,2})[0-9]*,([0-9]+\.[0-9]{1,2})[0-9]*)) {
        $gps = "[<a href=\"".$photo->[4].""."\">$1,$2</a>]";
      } else {
        $gps = "[<a href=\"".$photo->[4].""."\">GPS</a>]";
      }
    }

    my ($reldir, $fname, $fext) = ($1, $2, $3)
      if ($fw =~ m((.*)/([^/]+)\.([^/]+)$));
    my $thumb = "$reldir/$fname.t.$fext";
    if ($reldir and $fname and $fext) {
      $image =~ s((<img src="[^"]*" />))(<a href="$file_ups/$fw"><img src="$file_ups/$thumb" alt="$titr" title="$titr" border="0" /></a>)i;
    } else {
      $image =~ s((<img src="[^"]*" />))(<img src="$fw" alt="$titr" title="$titr" border="0" />)i;
    }
  }

  $tite =~ s(\.?$)(<br />) if $tite;
  $titr =~ s(\.?$)(<br />) if $titr;

#   print Dumper($titr);
#   <tr><td>$titr\[<a href="full-size">2304x1728</a>\]$gps</td></tr>
  return<<IMAGE;
  <table>
   <tr><td>$image</td></tr>
   <tr><td>$titr\[<a href="$file_ups/cgi-bin/igaview.pl?$file_ups/$fw">+</a>\]$gps</td></tr>
  </table>
IMAGE
}

# template for header and left sidebar
sub sidebar_left {
  my ($filerel) = @_;
  my $index2 = ctree2str($ctree->{$file_lang}, 0, $file_ups, $filerel, $filerel);

  # TODO: make a separate function and use it to generate:
  # <link rel="alternate" type="text/html" href="index.ru.html" hreflang="ru" lang="ru" />
  my $lang_switch = "";
  my $basefile = $filerel;
  $basefile =~ s((?:\.$file_lang\.html)$)();
  $basefile =~ s((?:\.html\.$file_lang)$)();
  my @translations = sort {
    $a->[0] cmp $b->[0]
  } grep {
    $_
  } map {
    m(^$basefile\.([a-z]{2,3})\.html$)
    ? [$1, $_]
    : (m(^$basefile\.html\.([a-z]{2,3})$)
    ? [$1, $_]
    : 0);
  } keys %files;
  if ($#translations > 0) {
    # $lang_switch .= "Language:";
    for (@translations) {
      if ($_->[0] eq $file_lang) {
        $lang_switch .= ' [<b>'
                     . ($trs->{$file_lang}->{$_->[0]} || $_->[0])
                     . '</b>]<br />';
      } else {
        $lang_switch .= " [<a href=\"$file_ups/$_->[1]\">"
                     . ($trs->{$file_lang}->{$_->[0]} || $_->[0])
                     . '</a>]<br />';
      }
    }
  }

  return<<SIDEBAR_LEFT;

  <table border="0" cellpadding="0" cellspacing="0" width="100%">
   <tr>
    <td class="corner" align="center" valign="middle">
     <center>
      <a href="http://www.jurta.org/"><img src="$file_ups/jurta.png" alt="JURTA HOME" width="115" height="115" border="0" /></a>
     </center>
    </td>
    <td class="header">&nbsp;</td><!-- resizable space filler (spacer) cell --><!-- width="10%" -->
    <td class="header" align="center" valign="middle">
      <a href="http://www.jurta.org/"><img src="$file_ups/jurta.$file_lang.png" alt="JURTA TEXT" border="0" /></a>
    </td>
    <td class="header">&nbsp;</td><!-- resizable space filler (spacer) cell -->
    <td class="corner" align="center" valign="middle">
<table><tr>
<td bgcolor="#ffffff" onclick="changeBodyColor('#000000','#ffffff');"><font color="#000000">A</font></td>
<td bgcolor="#cdc2b2" onclick="changeBodyColor('#000000','#cdc2b2');"><font color="#000000">A</font></td>
<td bgcolor="#000000" onclick="changeBodyColor('#ffffff','#000000');"><font color="#ffffff">A</font></td>
</tr></table>
$lang_switch
    </td>
   </tr>
   <tr>
    <td class="sidebar-left" align="left" valign="top">
$trs->{$file_lang}->{'sitemap'}:<br />
<span class="ctree">$index2
</span>
    </td>
    <td>&nbsp;</td><!-- resizable space filler (spacer) cell -->
    <td class="main" valign="top">
SIDEBAR_LEFT
}

# template for right sidebar and footer
sub sidebar_right {
  my ($text, $filerel, $fcharset) = @_;
  my ($index2, $discussion) = ("", "");

  while ($text =~ m(<h([1-6])[^>]*>(.*)</h[1-6]>)ig) {
    my ($level, $header, $href) = ($1, $2);
    ($header =~ m((?:name|id)="([^"]+)")) && ($href = $1);
    $header =~ s(<[^>]+>)()g;
    $index2 .= "&nbsp;"x$level."-&nbsp;".($href?"<a href=\"#$href\">$header</a>":"$header")."<br />\n";
  }

  if ($index2 ne "") { $index2 = "$trs->{$file_lang}->{'contents'}:<br />\n" . $index2; }

  if ($boards{$filerel}) {
    $discussion = "[ <a href=\"/board/$boards{$filerel}\">Discuss this page</a> ]";
  } elsif ($lj_boards{$filerel}) {
    $discussion = "("
    . "<a href=\"http://jurta-org.livejournal.com/\">"
    . "<img src=\"$file_ups/lj_community.png\" border=\"0\" /></a> "
    . "<a href=\"http://community.livejournal.com/jurta_org/$lj_boards{$filerel}.html\">"
    . "$trs->{$file_lang}->{'viewcomments'}</a> | "
    . "<a href=\"http://community.livejournal.com/jurta_org/$lj_boards{$filerel}.html?mode=reply\">"
    . "$trs->{$file_lang}->{'addcomment'}</a>)<br /><br />";
  }

  if ($filerel =~ m(^board/)i) {
    $index2 .= "<!-- messagelog -->\n<!-- /messagelog -->\n";
  }

#  TODO: Copyright &copy; 2003-2005 <a href="http://www.jurta.org/juri/">Juri Linkov</a> <a href="mailto:juri\@jurta.org?subject=http://www.jurta.org/?body=http://www.jurta.org/">&lt;juri\@jurta.org&gt;</a>
# <!--Updated: 2002-09-29 by <a href="http://www.jurta.org/juri/">juri</a> using <a href="/emacs">emacs</a><br />
# Regenerated: 2002-09-29 by <a href="/">jurta</a> using <a href="/perl/regenerator">regenerator</a><br />-->
# <!-- <div class="logs"><span class="header">Change Log:</span><div class="log"><span class="time">2002-09-29</span><span class="author"></span><span class="comments">added story about BlackWhite</span></div></div> -->

  my $current_year = (((localtime)[5])+1900);
  return<<SIDEBAR_RIGHT;

    </td>
    <td>&nbsp;</td><!-- resizable space filler (spacer) cell -->
    <td class="sidebar-right" align="left" valign="top">
$index2
    </td>
   </tr>
   <tr>
    <td class="sidebar-left">&nbsp;</td>
    <td>&nbsp;</td><!-- resizable space filler (spacer) cell -->
    <td align="right" valign="top">$discussion</td>
    <td>&nbsp;</td><!-- resizable space filler (spacer) cell -->
    <td class="sidebar-right">&nbsp;</td><!-- resizable space filler (spacer) cell -->
   </tr>
   <tr>
    <td align="center" valign="top"><!-- TODO: class="corner-sw" -->
<!-- Google CSE Search Box Begins  -->
<form action="http://www.jurta.org/search.en.html" id="searchbox_007814313286053995309:tcvsfe_sh2u">
  <input type="hidden" name="cx" value="007814313286053995309:tcvsfe_sh2u" />
  <input type="hidden" name="cof" value="FORID:9" />
  <input type="text" name="q" size="15" />
  <input type="submit" name="sa" value="Search" />
</form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_007814313286053995309%3Atcvsfe_sh2u&lang=en"></script>
<!-- Google CSE Search Box Ends -->
    </td>
    <td class="footer" colspan="3" valign="top">
<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td valign="top">
<a href="$file_ups/about.$file_lang.html#copyright">Copyright</a> &copy; 2002-$current_year <a href="http://www.jurta.org/juri/">Juri Linkov</a> <a href="mailto:juri\@jurta.org">&lt;juri\@jurta.org&gt;</a>
</td></tr></table>
    </td>
    <td class="corner-se" align="center" valign="top">
     <br />
      <!-- <a href="http://validator.w3.org/check/referer"><img
         src="$file_ups/valid-xhtml10.png"
         alt="Valid XHTML 1.0!" height="31" width="88" border="0" /></a> -->
         <!-- <a class="right" href="http://jigsaw.w3.org/css-validator"><img src="http://jigsaw.w3.org/css-validator/images/vcss" alt="Valid CSS!" /></a> -->
    </td><!-- resizable space filler (spacer) cell -->
   </tr>
  </table>
SIDEBAR_RIGHT
}

# TODO: use linguistic module for Russian inflections
# TODO: make separate module from next function
sub collect_keywords {
  return ""; # not implemented
  my $text = shift;
  my (%fr);
  $text =~ s/<!--.+?-->//sig;
  $text =~ s/<[^>]+>//ig;
  $text =~ s/&\w+;//ig;
  $text =~ tr/a-zA-Z0-9\200-\377/ /cs;
  $text =~ tr/A-Z/a-z/;
  for (split(/ /, $text)) { $fr{$_}++; }
  join ", ", (map {
    $_->[0]
  } sort {
    $b->[1] <=> $a->[1]
  } map {
    [$_, $fr{$_}]
  } keys %fr);#[0..3];
}

1;

__END__

=head1 NAME

regenerate - update HTML files with data collected from HTML tree

=head1 SYNOPSIS

    regenerate start-dir
    http://host/cgi-bin/regenerate.pl
    http://host/cgi-bin/regenerate.pl?host-start-dir (NOW DISABLED)

=head1 DESCRIPTION

B<regenerate> updates all HTML files from subdirectories under the
given start directory.  It updates HTML files by adding missing parts
(navbars, sidebars, indexes) with data collected from the same HTML
tree under the given start directory.  This program iterates HTML tree
in two passes.  At first step it collects needed information from HTML
tree by looking for HTML titles from every HTML file.  From this
information it builds the sidebar index string.  At second step this
program updates each HTML files under the start directory: it reads
every HTML file into string variable, adds missing tags into this HTML
string, adds left and right sidebars and writes result HTML string back
into the same file.

=head2 OPTIONS

    start-dir : the name of a directory under which all HTML files
                should be updated. If this script is executed under CGI,
                then start-dir can be the value of 'DOCUMENT_ROOT'.
                But to avoid undesirable results start-dir
                should be specified explicitely.

=head1 NOTES

B<regenerate> can be run stand-alone or from CGI.
When B<regenerate> is used under CGI, it outputs a content-type header.
B<regenerate> detects the fact that it is called under CGI by inspecting
the presense of the value of the 'DOCUMENT_ROOT' environment variable,
but it don't use this value.

=head1 SEE ALSO

B<degenerate>

=head1 AUTHOR

Juri Linkov E<lt>juri@jurta.org>

=head1 COPYRIGHT

Copyright (C) 2002-2006 Juri Linkov.  All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself or GPL.

;;; Local Variables:
;;; coding: koi8-r
;;; End:

=cut
