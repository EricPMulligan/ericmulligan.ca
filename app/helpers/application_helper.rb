module ApplicationHelper
  def mark_it_down(markeddown)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, prettify: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(markeddown)
  end

  def title(name = nil)
    if name.present?
      "#{name} - Eric Mulligan's Blog"
    else
      "Eric Mulligan's Blog"
    end
  end

  def author(user)
    if user.name.present?
      user.name
    else
      user.email
    end
  end
end
