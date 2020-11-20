require "yt"
require_relative "./objects/video"

Yt.configure do |config|
  config.api_key = ENV["YOUTUBE_API_KEY"]
end

module Integrations
  class Youtube
    CHANNEL_ID = ENV["YOUTUBE_SMERIWETHER_CHANNEL_ID"]

    def run!
      videos = fetch_videos!
      videos.map do |video|
        Integrations::Objects::Video.new(
          id: video[:id],
          title: video[:title],
          description: video[:description],
          published_at: video[:published_at],
          content_html: video[:content_html],
        )
      end
    end

    private

    def fetch_videos!
      yt_channel = Yt::Channel.new(id: CHANNEL_ID)
      yt_channel.videos.where(order: "date").map do |yt_video|
        {
          id: yt_video.id,
          title: yt_video.title,
          description: yt_video.description,
          published_at: yt_video.published_at,
          content_html: yt_video.player.embed_html,
        }
      end
    end
  end
end

