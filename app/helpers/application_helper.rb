module ApplicationHelper
  def mark_it_down(markeddown)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, prettify: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(markeddown)
  end
end
