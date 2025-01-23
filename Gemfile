# frozen_string_literal: true

source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(::URI.open('https://pages.github.com/versions.json').read)
gem 'github-pages', versions['github-pages']

group :jekyll_plugins do
  gem 'jekyll-redirect-from'
  gem 'jekyll-feed'
  gem 'jekyll-seo-tag'
  gem 'jekyll-sitemap'
end
