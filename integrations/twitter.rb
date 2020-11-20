require "twitter"
require_relative "./objects/tweet"

class TwitterError < StandardError; end

module Integrations
  class Twitter
    def initialize
      @client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_API_KEY"]
        config.consumer_secret = ENV["TWITTER_API_SECRET"]
        config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end
    end

    def run!
      tweets = fetch_favorited_tweets!
      tweets.map do |tweet|
        Integrations::Objects::Tweet.new(
          user_name: tweet.user.name,
          user_screen_name: tweet.user.screen_name,
          user_image_url: tweet.user.profile_image_url.to_s,
          text: tweet.full_text,
          created_at: tweet.created_at,
          url: tweet.uri,
        )
      end
    end

    private

    def fetch_favorited_tweets!
      begin
        @client.favorites({ tweet_mode: "extended" })
      rescue StandardError => e
        raise TwitterError, e.message
      end
    end
  end
end
