
This is the source for the site [jurta.org](https://jurta.github.io/)
generated with [Jekyll](https://jekyllrb.com/) static site generator.

Initially, my site was already in plain text files converted to HTML with
my own home-grown static site generator (basically just a set of scripts).

But in 2008 I migrated the site to Drupal 6, because I enjoyed using Drupal.
This is what I wrote about Drupal at that time:

> Like Emacs, Drupal is the advanced, extensible, customizable, self-documenting system.
> “Customizable” means that you can easily alter its behavior in simple ways.
> “Extensible” means that you can go beyond simple customization and easily
> create new modules (like packages in Emacs) and implement new functionality
> using a set of predefined hooks and well-thought-out core API.
> The unfortunate fact of using PHP as its implementation language
> doesn’t diminish the excellence of Drupal as a system.

But over time Drupal became a burden.  With every new release of a minor
version (about every month) with fixes of security vulnerabilities it
required upgrading the site.  Often automatic upgrades failed for various
reasons that required manual intervention to fix the problems.
After a few upgrades this process became too boring and disappointing,
and my excitement about Drupal vanished.  Also I tried to upgrade the major
version from Drupal 6 to Drupal 7, but the whole process took so much time,
so that eventually I asked myself “Why should I do this?” and abandoned the
attempt.  All these problems is what is called _technical debt_ - implied
cost of additional maintenance.  More complexity, more moving parts, more maintenance.

Here's a list of directories that contained the backups of the database and
site root directory that was required to backup before every upgrade.  The name
of directories is the same as the date of the upgrade.  Every upgrade took about
1 hour :(

20081214
20081224
20090125
20090128
20090207
20090215
20090222
20090423
20090501
20090702
20090723
20090808
20090901
20090929
20091027
20100102
20100116
20100207
20100210
20100306
20100315
20100417
20100518
20100520
20100709
20140622

I regret the time spent needlessly for such meaningless activity.

So now I had to move the site content back to plain text files
and use a static site generator again, this time not my own
(that was quite limited in functionality), but a well-maintained
generator with a lot of available features.

The clear benefit of the static site generators is the easiness with which
I can push content to the repository and forget about the nightmare of
handling databases, caching, upgrades, etc.
