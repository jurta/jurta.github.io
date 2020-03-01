
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
reasons.  After a few upgrades this process became too boring, and my
excitement about Drupal went away.  Also I tried to upgrade the major
version from Drupal 6 to Drupal 7, but the whole process took so much time,
so that eventually I asked myself “Why should I do this?” and abandoned the
attempt.  All these problems is what is called _technical debt_ - implied
cost of additional maintenance.

So now I had to move the site content back to plain text files
and use a static site generator again, this time not my own
(that was quite limited in functionality), but a well-maintained
generator with a lot of available features.

The clear benefit of the static site generator is the easiness with which
I can push content to the repository and forget about the nightmare of
handling databases, caching, upgrades, etc.
