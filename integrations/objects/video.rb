module Integrations
  module Objects
    class Video
      attr_reader :id, :title, :description, :published_at, :content_html

      def initialize(id:, title:, description:, published_at:, content_html:)
        @id = id
        @title = title
        @description = description
        @published_at = published_at
        @content_html = content_html.gsub("src=\"//", "src=\"https://")
      end

      def url
        "https://www.youtube.com/watch?v=#{@id}"
      end
    end
  end
end
