xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title "Eric Mulligan's Blog"
    xml.description 'A blog about coding, music among other things.'
    xml.link root_url
    xml.lastBuildDate @posts[0].created_at.to_s(:rfc822)
    xml.language 'en-ca'
    xml.copyright "Copyright #{@posts[0].created_at.strftime('%Y')}, Eric Mulligan"
    xml.managingEditor 'eric.pierre.mulligan@gmail.com (Eric Mulligan)'
    xml.webMaster 'eric.pierre.mulligan@gmail.com (Eric Mulligan)'

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link show_post_url(post.slug)
        xml.guid post_url(post)
        post.categories.each do |category|
          xml.category category.name
        end
        xml.author 'eric.pierre.mulligan@gmail.com (Eric Mulligan)'
      end
    end
  end
end
