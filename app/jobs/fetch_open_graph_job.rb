class FetchOpenGraphJob < ApplicationJob
  queue_as :default

  def perform(session_id, lookup_id, url)
    result = OpenGraphFetcher.call(url)

    data = LookupStore.backend.save_result(session_id, lookup_id, url, result)

    html = ApplicationController.render(
      partial: "lookups/lookup",
      locals: { lookup_id: lookup_id, lookup: data }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "lookups_#{session_id}",
      target: "lookup_#{lookup_id}",
      html: html
    )
  end
end
