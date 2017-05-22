xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @cms_site.pages.published.each do |page|
    xml.url do
      xml.loc [request.protocol.gsub('//', ''), page.url].join
      xml.priority 0.4
      xml.lastmod page.updated_at.strftime('%Y-%m-%d')
    end
  end
end
