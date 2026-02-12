class Lookup < ApplicationRecord
  before_create { self.lookup_id ||= SecureRandom.hex(8) }

  def to_h
    {
      "url" => url,
      "status" => status,
      "title" => title.to_s,
      "description" => description.to_s,
      "image" => image.to_s,
      "og_url" => og_url.to_s,
      "type" => og_type.to_s,
      "site_name" => site_name.to_s,
      "error" => error.to_s
    }
  end
end
