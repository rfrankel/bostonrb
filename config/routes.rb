ActionController::Routing::Routes.draw do |map|
  map.resources :jobs, :collection => {:old => :get}

  map.resources :presentations
  map.resources :projects
  map.resources :apps
  map.resources :events
  map.resources :pages
  map.resources :places
  map.resources :passwords
  map.resources :companies

  map.resources :users do |users|
    users.resource :password,     :controller => 'passwords'
    users.resource :confirmation, :controller => 'confirmations'
  end

  map.resource :session

  map.root :controller => 'home', :action => 'index'

  map.sign_up  'sign_up', :controller => 'users',    :action => 'new'
  map.sign_in  'sign_in', :controller => 'sessions', :action => 'new'
  map.sign_out 'sign_out',
    :controller => 'sessions',
    :action     => 'destroy',
    :method     => :delete
end

