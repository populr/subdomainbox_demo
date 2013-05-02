class PagesController < ApplicationController

  subdomainbox 'star', :only => :starframe

  def starframe
    @doc = Doc.find(params[:doc_id])
    render(:starframe, :layout => nil)
  end

end
