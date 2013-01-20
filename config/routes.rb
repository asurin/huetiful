Huetiful::Application.routes.draw do
  faye_server '/faye', :timeout => 25

  root :to => 'core#index'

  resources :bridges do
    get 'discover', :on => :collection
    resources :groups do
      resources :lights
    end
  end

end
