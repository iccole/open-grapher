class LookupsController < ApplicationController
  def index
    @lookups = store.all_for_session(session_id)
  end

  def create
    url = params[:url].to_s.strip
    if url.empty?
      redirect_to root_path
      return
    end

    url = "https://#{url}" unless url.match?(%r{\Ahttps?://})

    @lookup_id, @lookup = store.create_pending(session_id, url)

    FetchOpenGraphJob.perform_later(session_id, @lookup_id, url)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def session_id
    session[:lookup_session_id] ||= SecureRandom.hex(16)
  end

  def store
    LookupStore.backend
  end
end
