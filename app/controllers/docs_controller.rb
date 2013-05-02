class DocsController < ApplicationController

  subdomainbox 'edit-%{id}', :only => [:edit, :update]
  subdomainbox 'preview-%{id}', :only => :show
  subdomainbox 'star', :only => :star

  before_filter :require_user
  before_filter :find_resources, :only => :index
  before_filter :new_resource, :only => [:new, :create]
  before_filter :find_resource, :except => [:index, :new, :create, :star]

  respond_to :html, :json

  def star
    doc = Doc.find(params[:id])
    current_user.star!(doc)
    redirect_to(published_doc_url(doc))
  end

  def create
    @doc.save
    @doc.add_owner!(current_user)
    respond_with(@doc) do |format|
      format.html { redirect_to edit_doc_url(@doc) }
    end
  end

  def show
    raise RestrictedResource.new unless @doc.editor?(current_user)
    respond_with(@doc)
  end

  def edit
    raise RestrictedResource.new unless @doc.editor?(current_user)
    respond_with(@doc)
  end

  def update
    raise RestrictedResource.new unless @doc.editor?(current_user)
    @doc.update_attributes(params[:doc])
    respond_with(@doc)
  end

  def destroy
    raise RestrictedResource.new unless @doc.owner?(current_user)
    @doc.destroy
    respond_with(@doc) do |format|
      format.html { redirect_to docs_url }
    end
  end

  private

  def find_resources
    @owned_docs = current_user.owned_docs
    @editor_docs = current_user.editor_docs
  end

  def new_resource
    @doc = Doc.new(params[:doc])
  end

  def find_resource
    @doc = current_user.docs.find(params[:id])
  end


end
