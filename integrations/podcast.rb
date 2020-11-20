require_relative "./micro_blog"
require_relative "./objects/blog_post"

module Integrations
  class Podcast < Integrations::MicroBlog
    def run!
      podcast_posts = fetch_podcast_posts!
      podcast_posts.map do |podcast_post|
        Integrations::Objects::BlogPost.new(
          title: podcast_post[:title],
          content_html: podcast_post[:content_html],
          published_at: podcast_post[:published_at],
          source_url: podcast_post[:url],
        )
      end
    end

    private

    def fetch_podcast_posts!
      blog_posts = fetch_blog_posts!
      blog_posts.filter do |blog_post|
        blog_post[:title].include?("🎙Podcast")
      end
    end
  end
end
