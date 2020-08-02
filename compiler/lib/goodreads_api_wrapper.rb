require "open-uri"
require "nokogiri"

class GoodreadsError < StandardError; end

class GoodreadsAPIWrapper
  API_URL = "https://www.goodreads.com"
  USER_ID = ENV["GOODREADS_USER_ID"]
  API_KEY = ENV["GOODREADS_API_KEY"]
  CURRENTLY_READING_SHELF = "currently-reading"
  PREVIOUSLY_READ_SHELF = "read"

  def fetch_currently_reading!
    reviews = fetch_reviews!
    reviews.filter { |review| review[:shelf] == CURRENTLY_READING_SHELF }
  end

  def fetch_previously_read!
    reviews = fetch_reviews!
    reviews.filter { |review| review[:shelf] == PREVIOUSLY_READ_SHELF }
  end

  private

  def fetch_reviews!
    @reviews ||= fetch_reviews_uncached!
  end

  def fetch_reviews_uncached!
    begin
      response_doc = Nokogiri::XML(URI.open("#{API_URL}/review/list/#{USER_ID}.xml?v=2&key=#{API_KEY}"))
      reviews = response_doc.xpath("//review").map do |review|
        book_title = review.xpath(".//book/title").text
        book_authors = review.xpath(".//book/authors").map { |author| author.xpath("author/name").text }
        book_link = review.xpath(".//book/link").text
        book_image_url = review.xpath(".//book/image_url").text
        shelf = review.xpath(".//shelves").first.at_xpath("shelf/@name").text

        {
          book_title: book_title,
          book_authors: book_authors,
          book_link: book_link,
          book_image_url: book_image_url,
          shelf: shelf
        }
      end
    rescue OpenURI::HTTPError => e
      raise GoodreadsError, e.message
    end
  end
end
