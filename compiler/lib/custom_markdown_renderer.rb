require "redcarpet"

class CustomMarkdownRender < Redcarpet::Render::HTML
  def link(link, title, content)
    link_content = link
    if prod?
      link_content = link_content.gsub("../../", "#{website}/")
      link_content = link_content.gsub("./", "#{website}/")
      link_content = link_content.gsub(".html", "")
    end

    external_link_contents = nil
    if external_link?(link)
      external_link_contents = "rel='noreferrer' target='_blank'"
    end

    "<a href=#{link_content} #{external_link_contents}>#{content}</a>"
  end

  private

  def website
    ENV["WEBSITE"]
  end

  def prod?
    !!ENV["PROD"]
  end

  def external_link?(link)
    internal_link = link.include?("./") || link.include?(website)
    !internal_link
  end
end
