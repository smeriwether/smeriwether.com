require "open-uri"
require "nokogiri"
require_relative "./objects/book"

class GoodreadsError < StandardError; end

module Integrations
  class Goodreads
    API_URL = "https://www.goodreads.com"
    USER_ID = ENV["GOODREADS_USER_ID"]
    API_KEY = ENV["GOODREADS_API_KEY"]
    CURRENTLY_READING_SHELF = "currently-reading"
    PREVIOUSLY_READ_SHELF = "read"

    def run!
      reviews = fetch_reviews!
      [currently_reading(reviews), previously_read(reviews)].flatten.map do |object|
        Integrations::Objects::Book.new(
          title: object[:book_title],
          authors: object[:book_authors],
          cover_image_url: object[:book_image_url],
          source_url: object[:book_url],
          active: object[:shelf] == CURRENTLY_READING_SHELF,
        )
      end
    end

    private

    def currently_reading(reviews)
      reviews.filter { |review| review[:shelf] == CURRENTLY_READING_SHELF }
    end

    def previously_read(reviews)
      reviews.filter { |review| review[:shelf] == PREVIOUSLY_READ_SHELF }
    end

    def fetch_reviews!
      @reviews ||= fetch_reviews_uncached!
    end

    def fetch_reviews_uncached!
      begin
        reviews = []
        iteration = 1

        loop do
          response_doc = Nokogiri::XML(URI.open("#{API_URL}/review/list/#{USER_ID}.xml?v=2&key=#{API_KEY}&page=#{iteration}"))
          raise GoodreadsError, response_doc.errors.map(&:message).join(", ") if response_doc.errors.any?
          reviews = [*reviews, *response_doc.xpath("//review")]
          break if response_doc.xpath("//review").empty? || iteration > 100 # safe gaurd if something goes terrible
          iteration = iteration + 1
        end

        reviews.map do |review|
          book_title = review.xpath(".//book/title").text
          book_authors = review.xpath(".//book/authors").map { |author| author.xpath("author/name").text }
          book_link = review.xpath(".//book/link").text
          book_image_url = review.xpath(".//book/image_url").text
          shelf = review.xpath(".//shelves").first.at_xpath("shelf/@name").text

          {
            book_title: book_title,
            book_authors: book_authors,
            book_url: book_link,
            book_image_url: book_image_url,
            shelf: shelf
          }
        end
      rescue OpenURI::HTTPError => e
        raise GoodreadsError, e.message
      end
    end
  end
end
