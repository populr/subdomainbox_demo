SubdomainboxDemo::Application.routes.draw do

  resources :docs do
    resources :doc_privileges, :only => [:new, :create, :destroy]
  end

  devise_for :users, :path => 'users', :controllers => { :sessions => 'sessions' }

  match '/docs' => 'pages#home', :as => :user_root
  root :to => 'pages#home'
end
