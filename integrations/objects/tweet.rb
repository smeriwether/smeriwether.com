module Integrations
  module Objects
    class Tweet
      attr_reader :user_name, :user_screen_name, :user_image_url, :text, :created_at, :url

      def initialize(user_name:, user_screen_name:, user_image_url:, text:, created_at:, url:)
        @user_name = user_name
        @user_screen_name = user_screen_name
        @user_image_url = user_image_url
        @text = text.gsub("\n", "<br />")
        @created_at = created_at
        @url = url
      end
    end
  end
end
