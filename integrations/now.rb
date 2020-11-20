require_relative "./micro_blog"
require_relative "./objects/blog_post"

module Integrations
  class Now < Integrations::MicroBlog
    def run!
      now_posts = fetch_now_posts!
      now_posts.map do |now_post|
        Integrations::Objects::BlogPost.new(
          title: now_post[:title],
          content_html: now_post[:content_html],
          published_at: now_post[:published_at],
          source_url: now_post[:url],
        )
      end
    end

    private

    def fetch_now_posts!
      blog_posts = fetch_blog_posts!
      blog_posts.filter do |blog_post|
        blog_post[:title].include?("⏰ Now")
      end
    end
  end
end
