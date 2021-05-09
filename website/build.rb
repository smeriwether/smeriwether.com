require "date"
require "erubis"
require "kramdown"
require "pry"
require "rss"
require "yaml"

def build_page(template_path, contents = nil)
  @content = if contents
               contents
             else
               Erubis::EscapedEruby.new(File.read(template_path)).result(binding())
             end
  Erubis::Eruby.new(File.read("./website/index.html.erb")).result(binding())
end

def prepare_page_for_production(page_contents)
  updated_page = page_contents.gsub("index.html", "/")
  # I can't come up with the right regex to find the right
  # a tag in a line with multiple a tags.
  updated_page.scan(/.+\.html/).map do |link|
    link.split("<a")
  end.flatten.each do |link|
    if !link.include?("http") && link.include?(".html")
      fixed_link = link.gsub(".html", "")
      updated_page = updated_page.gsub(link, fixed_link)
    end
  end
  updated_page
end

def write_file(file_contents, file_name, file_type = "html")
  file = "./site/#{file_name}.#{file_type}"
  FileUtils.mkdir_p(File.dirname(file)) unless Dir.exists?(File.dirname(file))
  File.open(file, "w") { |file| file.puts(file_contents) }
end

def create_page(
  template_name = nil,
  page_name = template_name,
  contents = nil,
  template_path = "./website/#{template_name}.html.erb"
)
  page_contents = build_page(template_path, contents)
  if ENV["NODE_ENV"] == "production"
    page_contents = prepare_page_for_production(page_contents)
  end
  write_file(page_contents, page_name)
end

def load_posts
  config = YAML.load(File.read("./writings/index.yaml"))
  config.keys.map do |file_name|
    post_data = config[file_name]

    post = OpenStruct.new
    post.slug = post_data.dig("slug")
    post.title = post_data.dig("title")
    post.description = post_data.dig("description")
    post.published_date = Date.parse(post_data.dig("published_date"))
    post.html = Kramdown::Document.new(File.read("./writings/#{post.published_date.strftime("%Y%m%d")}-#{file_name}.md")).to_html
    post
  end
end

def create_writings
  @posts = load_posts
  @title = "My writings"
  create_page("writings")

  @posts.each do |post|
    @post = post
    @title = post.title
    @description = post.description
    create_page("post", @post.slug)
  end
end

def create_rss_feed
  posts = load_posts

  rss = RSS::Maker.make("atom") do |maker|
    maker.channel.author = "Stephen Meriwether"
    maker.channel.about = "https://stephen.fyi"
    maker.channel.title = "Stephen Meriwether's writings"
    maker.channel.description = "Hi 👋, I'm Stephen, welcome to my online home."
    maker.channel.link = "https://stephen.fyi"
    maker.channel.updated = Time.now

    posts.each do |post|
      maker.items.new_item do |item|
        item.link = "https://stephen.fyi/#{post.slug}"
        item.title = post.title
        item.description = post.description
        item.updated = post.published_date.to_s
      end
    end
  end

  write_file(rss.to_rss("2.0"), "feed", "rss")
end

create_page("home", "index")
create_page("404")
create_writings
create_rss_feed
