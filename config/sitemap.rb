# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://ericmulligan.ca'
SitemapGenerator::Sitemap.sitemaps_path = 'system/'

SitemapGenerator::Sitemap.create do
  add about_path
  add contact_path
  add sign_in_path, priority: 0.0
  add coding_path, changefreq: 'daily'
  add music_path, changefreq: 'daily'
  add other_path, changefreq: 'daily'

  Post.where(published: true).find_each do |post|
    add show_post_path(post.slug), lastmod: post.updated_at
  end
end
