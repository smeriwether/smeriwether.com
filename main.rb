require "dotenv/load"
require "erubis"
require "fileutils"
require "pry"
require_relative "./integrations/goodreads"
require_relative "./integrations/micro_blog"
require_relative "./integrations/now"
require_relative "./integrations/podcast"
require_relative "./integrations/twitter"
require_relative "./integrations/youtube"

puts "Starting website build!"

@blog_posts = Integrations::MicroBlog.new.run!
@books = Integrations::Goodreads.new.run!
@now_posts = Integrations::Now.new.run!
@podcast_posts = Integrations::Podcast.new.run!
@tweets = Integrations::Twitter.new.run!
@youtube_videos = Integrations::Youtube.new.run!

def write_page(page_name)
  @template = Erubis::EscapedEruby.new(File.read("views/#{page_name}.html.erb")).result(binding())
  page = Erubis::Eruby.new(File.read("views/index.html.erb")).result(binding())
  file = "#{ENV['SITE_DIR']}/#{page_name}.html"
  if ENV["PRODUCTION"]
    page = page.gsub("index.html", "/")
    page.scan(/.+\.html/).each do |link|
      if !link.include?("http")
        fixed_link = link.gsub(".html", "")
        page.gsub!(link, fixed_link)
      end
    end
    file = "#{ENV['SITE_DIR']}/#{page_name}"
  end
  FileUtils.mkdir_p(File.dirname(file)) unless Dir.exists?(File.dirname(file))
  File.open(file, "w") { |file| file.puts(page) }
end

write_page("home")
write_page("blog")
write_page("books")
write_page("podcasts")
write_page("youtube")
write_page("now")
write_page("tweets")
write_page("404")

FileUtils.cp_r("public/assets/.", "#{ENV['SITE_DIR']}/")

puts "Finished website build!"
