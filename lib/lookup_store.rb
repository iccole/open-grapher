module LookupStore
  def self.backend
    @backend ||= if ENV["LOOKUP_STORE"] == "postgres"
      PostgresStore
    else
      RedisStore
    end
  end
end
