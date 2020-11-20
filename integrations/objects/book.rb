module Integrations
  module Objects
    class Book
      attr_reader :title, :authors, :cover_image_url, :source_url, :active

      def initialize(title:, authors:, cover_image_url:, source_url:, active:)
        @title = title
        @authors = authors
        @cover_image_url = cover_image_url
        @source_url = source_url
        @active = active
      end

      def inactive
        !@active
      end
    end
  end
end
