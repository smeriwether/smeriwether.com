require "active_support/core_ext/string"
require "dotenv/load"
require "erb"
require "fileutils"
require "pry"
require "redcarpet"

require_relative "./lib/goodreads"
require_relative "./lib/page"

ENV["WEBSITE"] = "https://smeriwether.com"

FileUtils.rm_rf Dir.glob("./site/*")

## Setup
# Some pages (like books) pull in information from others sources.
# In order for the templates to work, that information needs to be
# set on the page before `page.create!` is called.
puts "Downloading info from goodreads..."
goodreads = Goodreads.new
currently_reading_books = goodreads.currently_reading!
previously_read_books = goodreads.previously_read!

money_statements = Dir["content/archives/statements/*"].map do |filename|
  File.basename(filename, ".*")
end

writing_archives = Dir["content/archives/writing/*"].map do |filename|
  File.basename(filename, ".*")
end

now_archives = Dir["content/archives/now/*"].map do |filename|
  File.basename(filename, ".*")
end

sitemap_pages = Dir["content/*"].map do |filename|
  filename = File.basename(filename)
  if filename == "home"
    ""
  elsif filename == "archive" || filename == "footer" || filename == "archives"
    nil
  else
    filename
  end
end.compact

page = Page.new
page.set_currently_reading_books(currently_reading_books)
page.set_previously_read_books(previously_read_books)
page.set_money_statements(money_statements)
page.set_writing_archives(writing_archives)
page.set_now_archives(now_archives)
page.set_sitemap_pages(sitemap_pages)

puts "Creating pages..."
page.create!("home")
page.create!("now")
page.create!("books")
page.create!("podcasts")
page.create!("money")
page.create!("archive")
page.create!("404")

money_statements.each do |statement_filename|
  page.create!(
    "archives/statements",
    content_filename: "#{statement_filename}.md",
    site_page_name: "archives/statements/#{statement_filename}",
  )
end

writing_archives.each do |archive_filename|
  page.create!(
    "archives/writing",
    content_filename: "#{archive_filename}.md",
    site_page_name: "archives/writing/#{archive_filename}",
  )
end

now_archives.each do |archive_filename|
  page.create!(
    "archives/now",
    content_filename: "#{archive_filename}.md",
    site_page_name: "archives/now/#{archive_filename}",
  )
end

page.create_without_content!("sitemap", site_page_name: "sitemap.xml")

puts "Copying assets..."
FileUtils.cp_r('compiler/assets/.', 'site/')

puts "Done!"
