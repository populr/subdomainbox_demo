class ApplicationController < ActionController::Base
  protect_from_forgery
  around_filter :catch_exceptions

  default_subdomainbox 'app'

  # By default, Rails includes all helper files, which causes namespace
  # collisions between helper methods
  clear_helpers

  helper_method :published_doc_url, :star_doc_url

  class DocumentNotFound < StandardError
  end

  class RestrictedResource < StandardError
  end

  private

  def star_doc_url(doc)
    port = Rails.env.development? ? ':3000' : ''
    request.protocol + request.domain + port + "/docs/#{doc.id}/star"
  end

  def published_doc_url(doc)
    port = Rails.env.development? ? ':3000' : ''
    request.protocol + doc.subdomain + '.' + request.domain + port
  end

  def require_user
    return if user_signed_in?

    respond_to do |format|
      format.html do
        # only set intended_url if the request is a get or else the redirection will result in an error
        # because no route would exist for the specified URL requested by GET
        session[:intended_url] = request.url if request.get?
        redirect_to new_user_session_url
      end

      format.json { render(:json => {}, :status => 401) }
    end
  end

  def catch_exceptions
    yield
  rescue RestrictedResource
    respond_to do |format|
      format.html do
        flash[:alert] = 'Restricted'
        redirect_to root_url
      end

      format.json { render(:json => {}, :status => 403) }
    end
  rescue DocumentNotFound, ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html do
        flash[:alert] = 'Missing'
        redirect_to root_url
      end

      format.json { render(:json => {}, :status => 404) }
    end
  end

end
