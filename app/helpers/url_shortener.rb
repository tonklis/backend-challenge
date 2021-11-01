class UrlShortener

  SHORTEN_V4_URL = "https://api-ssl.bitly.com/v4/shorten"

  def self.shorten_url(long_url)
    begin
      self.call_bitly_api(long_url)
    # If there is an error, returns the original URL
    rescue StandardError
      return long_url
    end
  end

  # Calls the bitly API
  def self.call_bitly_api(long_url)
    uri = URI.parse(SHORTEN_V4_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri,
      { 'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{Rails.application.secrets.bitly_key}"
      }
    )
    request.body = {long_url: long_url}.to_json
    res = http.request(request)
    if res.is_a?(Net::HTTPSuccess)
      JSON.parse(res.body)["link"]
    else
      raise 'There was an error shortening the URL'
    end
  end
end
