require "erubis"

def build_page(template_path, contents = nil)
  @content = if contents
               contents
             else
               Erubis::EscapedEruby.new(File.read(template_path)).result(binding())
             end
  Erubis::Eruby.new(File.read("./index.html.erb")).result(binding())
end

def prepare_page_for_production(page_contents)
  updated_page = page_contents.gsub("index.html", "/")
  updated_page.scan(/.+\.html/).each do |link|
    if !link.include?("http")
      fixed_link = link.gsub(".html", "")
      updated_page = updated_page.gsub(link, fixed_link)
    end
  end
  updated_page
end

def write_file(file_contents, file_name)
  file = "./site/#{file_name}.html"
  FileUtils.mkdir_p(File.dirname(file)) unless Dir.exists?(File.dirname(file))
  File.open(file, "w") { |file| file.puts(file_contents) }
end

def create_page(
  template_name = nil,
  page_name = template_name,
  contents = nil,
  template_path = "./#{template_name}.html.erb"
)
  page_contents = build_page(template_path, contents)
  page_contents = prepare_page_for_production(page_contents)
  write_file(page_contents, page_name)
end

create_page("home", "index")
create_page("404")
