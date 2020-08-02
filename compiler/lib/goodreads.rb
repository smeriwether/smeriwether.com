require_relative "./goodreads_api_wrapper"

Book = Struct.new(:name, :link, :authors, :image_url)

class Goodreads
  def initialize
    @api_wrapper = GoodreadsAPIWrapper.new
  end

  def currently_reading!
    books = @api_wrapper.fetch_currently_reading!
    books.map do |book|
      Book.new(
        book[:book_title],
        book[:book_link],
        book[:book_authors],
        book[:book_image_url],
      )
    end
  end

  def previously_read!
    books = @api_wrapper.fetch_previously_read!
    books.map do |book|
      Book.new(
        book[:book_title],
        book[:book_link],
        book[:book_authors],
        book[:book_image_url],
      )
    end
  end
end
