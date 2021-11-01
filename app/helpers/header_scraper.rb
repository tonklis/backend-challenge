class HeaderScraper

  def self.get_headers(url)
    begin
      html_content = URI.open(url).read
      doc = Nokogiri::HTML(html_content)

      # Creating and populating headers array
      headers = doc.search('h1').map { |element| element.text.strip }
      headers += doc.search('h2').map { |element| element.text.strip }
      headers += doc.search('h3').map { |element| element.text.strip }

      return headers
    rescue StandardError
      # There was a faulty url or probably a network error, see if this
      # needs to be logged or separated in the future
      return []
    end
  end

end
