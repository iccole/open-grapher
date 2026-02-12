require "faraday"
require "faraday/follow_redirects"
require "faraday/cookie_jar"
require "open_graph_reader"

class OpenGraphFetcher
  Result = Data.define(:title, :description, :image, :url, :type, :site_name, :error)

  def self.call(url)
    new(url).call
  end

  def initialize(url)
    @url = url
  end

  def call
    conn = Faraday.new do |f|
      f.use Faraday::FollowRedirects::Middleware
      f.use :cookie_jar
      f.adapter Faraday.default_adapter
    end

    response = conn.get(@url) do |req|
      req.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
      req.options.timeout = 10
      req.options.open_timeout = 5
    end

    og = OpenGraphReader.parse!(response.body, @url)

    Result.new(
      title: og.og.title,
      description: og.og.description,
      image: og.og.image&.url,
      url: og.og.url,
      type: og.og.type,
      site_name: og.og.site_name,
      error: nil
    )
  rescue => e
    Result.new(
      title: nil, description: nil, image: nil,
      url: @url, type: nil, site_name: nil,
      error: e.message
    )
  end
end
