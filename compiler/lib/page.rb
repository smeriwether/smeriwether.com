require "erb"
require "fileutils"
require "redcarpet"
require "pry"

require_relative "./custom_markdown_renderer"

class Page
  def initialize
    @markdown = Redcarpet::Markdown.new(CustomMarkdownRender, fenced_code_blocks: true)
  end

  def create!(page_name, content_filename: nil, site_page_name: nil)
    set_relative_styles_link(page_name)

    footer = render_footer
    page = render_page(page_name, content_filename, footer)
    create_page(page, site_page_name || page_name)
  end

  def create_without_content!(page_name, site_page_name: nil)
    page = render_template(page_name)
    create_page(page, site_page_name || page_name)
  end

  def set_currently_reading_books(content)
    @currently_reading_books = content
  end

  def set_previously_read_books(content)
    @previously_read_books = content
  end

  def set_money_statements(content)
    @money_statements = content
  end

  def set_writing_archives(content)
    @writing_archives = content
  end

  def set_sitemap_pages(content)
    @sitemap_pages = content
  end

  protected

  def prod?
    !!ENV["PROD"]
  end

  private

  def render_footer
    md_content = File.read("content/footer/index.md")
    @markdown.render(md_content)
  end

  def render_page(page_name, content_filename, footer)
    md_content = File.read("content/#{page_name}/#{content_filename || "index.md"}")
    html_content = @markdown.render(md_content)

    @content = html_content
    template = render_template(page_name)

    @title = page_name.gsub("/", " / ").titleize
    @template_content = template
    @footer_content = footer
    render_template
  end

  def render_template(page_name = "")
    file_path = "compiler/templates/index.html.erb"
    if page_name
      file_path = "compiler/templates/#{page_name}/index.html.erb"
    end

    ERB.new(File.read(file_path), 0, "<>").result(binding)
  end

  def create_page(page, page_name)
    file = Link.create("site/#{page_name}.html")
    FileUtils.mkdir_p(File.dirname(file)) unless Dir.exists?(File.dirname(file))
    File.open(file, "w") do |file|
      file.puts(page)
    end
  end

  def set_relative_styles_link(page)
    if prod?
      @styles_link = "#{ENV["WEBSITE"]}/styles.css"
    else
      @styles_link = "#{File.dirname(__FILE__)}/../../site/styles.css"
    end
  end

  class Link
    def self.home
      if prod?
        "#{ENV["WEBSITE"]}"
      else
        "#{File.dirname(__FILE__)}/../../site/home.html"
      end
    end

    def self.money
      if prod?
        "#{ENV["WEBSITE"]}/money"
      else
        "#{File.dirname(__FILE__)}/../../site/money.html"
      end
    end

    def self.archive
      if prod?
        "#{ENV["WEBSITE"]}/archive"
      else
        "#{File.dirname(__FILE__)}/../../site/archive.html"
      end
    end

    def self.create(link)
      if prod?
        link.gsub("./", "#{ENV["WEBSITE"]}/").gsub(".html", "")
      elsif link.include?(".xml")
        link.gsub(".html", "")
      else
        link
      end
    end

    def self.prod?
      !!ENV["PROD"]
    end
  end
end
