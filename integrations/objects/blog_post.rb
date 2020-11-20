module Integrations
  module Objects
    class BlogPost
      attr_reader :title, :published_at, :source_url, :content_html

      def initialize(title:, published_at:, source_url:, content_html: nil)
        @title = title
        @published_at = published_at
        @source_url = source_url
        @content_html = content_html
      end
    end
  end
end
