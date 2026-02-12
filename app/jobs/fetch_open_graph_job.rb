class FetchOpenGraphJob < ApplicationJob
  queue_as :default

  def perform(session_id, lookup_id, url)
    result = OpenGraphFetcher.call(url)

    redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
    redis.hset("session:#{session_id}:lookup:#{lookup_id}",
      "url", url,
      "status", result.error ? "error" : "complete",
      "title", result.title.to_s,
      "description", result.description.to_s,
      "image", result.image.to_s,
      "og_url", result.url.to_s,
      "type", result.type.to_s,
      "site_name", result.site_name.to_s,
      "error", result.error.to_s
    )
    redis.expire("session:#{session_id}:lookup:#{lookup_id}", 86400)

    html = ApplicationController.render(
      partial: "lookups/lookup",
      locals: { lookup_id: lookup_id, lookup: redis.hgetall("session:#{session_id}:lookup:#{lookup_id}") }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "lookups_#{session_id}",
      target: "lookup_#{lookup_id}",
      html: html
    )
  end
end
