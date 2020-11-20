require "open-uri"
require_relative "./objects/blog_post"

class MicroBlogError < StandardError; end

module Integrations
  class MicroBlog
    FEED_URL = "https://smeriwether.micro.blog/feed.json"

    def run!
      blog_posts = fetch_blog_posts!
      blog_posts.map do |blog_post|
        Integrations::Objects::BlogPost.new(
          title: blog_post[:title],
          published_at: blog_post[:published_at],
          source_url: blog_post[:url],
        )
      end
    end

    protected

    def fetch_blog_posts!
      begin
        response_json = JSON.parse(URI.open(FEED_URL).read)
        response_json["items"].map do |micro_blog_item|
          {
            title: micro_blog_item["title"],
            content_html: micro_blog_item["content_html"],
            published_at: DateTime.parse(micro_blog_item["date_published"]),
            url: micro_blog_item["url"],
          }
        end
      rescue OpenURI::HTTPError => e
        raise MicroBlogError, e.message
      rescue JSON::ParserError => e
        raise MicroBlogError, e.message
      rescue ArgumentError => e
        raise MicroBlogError, e.message
      end
    end
  end
end
