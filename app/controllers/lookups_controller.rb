class LookupsController < ApplicationController
  def index
    @lookups = load_lookups
  end

  def create
    url = params[:url].to_s.strip
    if url.empty?
      redirect_to root_path
      return
    end

    url = "https://#{url}" unless url.match?(%r{\Ahttps?://})

    lookup_id = SecureRandom.hex(8)

    redis.hset("session:#{session_id}:lookup:#{lookup_id}",
      "url", url,
      "status", "pending"
    )
    redis.expire("session:#{session_id}:lookup:#{lookup_id}", 86400)
    redis.rpush("session:#{session_id}:lookups", lookup_id)
    redis.expire("session:#{session_id}:lookups", 86400)

    FetchOpenGraphJob.perform_later(session_id, lookup_id, url)

    @lookup_id = lookup_id
    @lookup = redis.hgetall("session:#{session_id}:lookup:#{lookup_id}")

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def session_id
    session[:lookup_session_id] ||= SecureRandom.hex(16)
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
  end

  def load_lookups
    lookup_ids = redis.lrange("session:#{session_id}:lookups", 0, -1)
    lookup_ids.map do |id|
      [id, redis.hgetall("session:#{session_id}:lookup:#{id}")]
    end.reject { |_, data| data.empty? }
  end
end
