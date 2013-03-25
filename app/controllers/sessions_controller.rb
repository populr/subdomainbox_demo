class SessionsController < Devise::SessionsController

  remove_default_subdomainbox :only => :destroy

end