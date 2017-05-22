require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = ENV['SELF_URL']
SitemapGenerator::Sitemap.default_host ||= 'https://www.brookgreensupply.com'
SitemapGenerator::Sitemap.include_root = false
SitemapGenerator::Sitemap.create do
  add '/', changefreq: 'weekly', priority: 1.0
  add '/help', changefreq: 'monthly', priority: 0.3
  add '/quotes/new', changefreq: 'monthly', priority: 0.7
  add_to_index '/cms/sitemap.xml', lastmod: nil
end
