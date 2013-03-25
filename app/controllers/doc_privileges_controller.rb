class DocPrivilegesController < ApplicationController


  before_filter :require_user
  before_filter :find_containing_resource
  before_filter :new_resource, :only => [:new, :create]

  respond_to :html, :json


  def create
    if @doc_privilege.save
      redirect_to docs_url
    else
      render(:new)
    end
  end

  def new
    respond_with(@doc_privilege)
  end

  private

  def find_containing_resource
    @doc = Doc.find(params[:doc_id])
    raise RestrictedResource.new unless @doc.owner?(current_user)
  end

  def new_resource
    collaborator_email = params[:doc_privilege] && params[:doc_privilege][:collaborator_email]
    @doc_privilege = @doc.doc_privileges.new(:privilege => 'w', :collaborator_email => collaborator_email)
  end

end
