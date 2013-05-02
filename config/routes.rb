SubdomainboxDemo::Application.routes.draw do


  constraints lambda{ |req| !(req.host =~ /^subdomainbox\.com$/ ||
                         req.host =~ /^(admin|account|app|docs|edit|preview|star|trash)(-[^.]+)?\.subdomainbox\.com$/ ||
                         req.host =~ /^www\.subdomainbox\.com$/ ||
                         req.host =~ /^talkdemo\.com$/ ||
                         req.host =~ /^(admin|account|app|docs|edit|preview|star|trash)(-[^.]+)?\.talkdemo\.com$/ ||
                         req.host =~ /^www\.talkdemo\.com$/ ||
                         req.host =~ /^lvh\.me$/ ||
                         req.host =~ /^(admin|account|app|docs|edit|preview|star|trash)(-[^.]+)?\.lvh\.me$/ ||
                         req.host =~ /^localhost$/ ||
                         req.host =~ /.dev$/ ||
                         req.host =~ /localtunnel.com$/ ||
                         req.host =~ /^www.example\.com$/ ||
                         req.path =~ /^\/assets\//) } do
    match '*slug' => 'published_docs#show', :via => :get, :format => false
    match '/' => 'published_docs#show', :via => :get, :format => false
  end



  resources :docs do
    member do
      post :star
    end
    resources :doc_privileges, :only => [:new, :create, :destroy]
  end

  devise_for :users, :path => 'users', :controllers => { :sessions => 'sessions' }

  match '/docs' => 'pages#home', :as => :user_root
  match 'starframe/:doc_id' => 'pages#starframe', :via => :get
  root :to => 'pages#home'
end
