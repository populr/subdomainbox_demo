class PublishedDocsController < ApplicationController

  before_filter :find_resource

  private

  def find_resource
    @doc = Doc.where('subdomain=?', request.subdomains.first).first
    raise DocumentNotFound.new unless @doc

  rescue DocumentNotFound
    render(:missing, :status => 404, :layout => @layout)
  end

end