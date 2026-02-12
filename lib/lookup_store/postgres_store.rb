module LookupStore
  module PostgresStore
    module_function

    def create_pending(session_id, url)
      record = Lookup.create!(session_id: session_id, url: url, status: "pending")
      [record.lookup_id, record.to_h]
    end

    def save_result(session_id, lookup_id, _url, result)
      record = Lookup.find_by!(session_id: session_id, lookup_id: lookup_id)
      record.update!(
        status: result.error ? "error" : "complete",
        title: result.title,
        description: result.description,
        image: result.image,
        og_url: result.url,
        og_type: result.type,
        site_name: result.site_name,
        error: result.error
      )
      record.to_h
    end

    def find(session_id, lookup_id)
      record = Lookup.find_by(session_id: session_id, lookup_id: lookup_id)
      record&.to_h || {}
    end

    def all_for_session(session_id)
      Lookup.where(session_id: session_id).order(:created_at).map do |record|
        [record.lookup_id, record.to_h]
      end
    end
  end
end
