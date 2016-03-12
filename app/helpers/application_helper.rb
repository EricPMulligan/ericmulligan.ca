module ApplicationHelper
  def alert_type(key)
    case key
      when 'alert'
        'danger'
      when 'notice'
        'success'
      else
        'success'
    end
  end

  def author(user)
    if user.name.present?
      user.name
    else
      user.email
    end
  end

  def mark_it_down(markeddown)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, prettify: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(markeddown)
  end

  def title(name = nil)
    if name.present?
      "#{name} - Eric Mulligan's Blog".html_safe
    else
      "Eric Mulligan's Blog".html_safe
    end
  end
end
