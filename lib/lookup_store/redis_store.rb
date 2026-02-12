module LookupStore
  module RedisStore
    module_function

    def create_pending(session_id, url)
      lookup_id = SecureRandom.hex(8)
      data = { "url" => url, "status" => "pending" }

      redis.hset(key(session_id, lookup_id), data)
      redis.expire(key(session_id, lookup_id), 86400)
      redis.rpush(list_key(session_id), lookup_id)
      redis.expire(list_key(session_id), 86400)

      [lookup_id, data]
    end

    def save_result(session_id, lookup_id, url, result)
      data = {
        "url" => url,
        "status" => result.error ? "error" : "complete",
        "title" => result.title.to_s,
        "description" => result.description.to_s,
        "image" => result.image.to_s,
        "og_url" => result.url.to_s,
        "type" => result.type.to_s,
        "site_name" => result.site_name.to_s,
        "error" => result.error.to_s
      }

      redis.hset(key(session_id, lookup_id), data)
      redis.expire(key(session_id, lookup_id), 86400)

      data
    end

    def find(session_id, lookup_id)
      redis.hgetall(key(session_id, lookup_id))
    end

    def all_for_session(session_id)
      ids = redis.lrange(list_key(session_id), 0, -1)
      ids.map { |id| [id, redis.hgetall(key(session_id, id))] }
         .reject { |_, data| data.empty? }
    end

    def redis
      @redis ||= Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
    end

    def key(session_id, lookup_id)
      "session:#{session_id}:lookup:#{lookup_id}"
    end

    def list_key(session_id)
      "session:#{session_id}:lookups"
    end
  end
end
