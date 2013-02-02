Huetiful::Application.routes.draw do
  root :to => 'core#index'

  resources :bridges do
    get 'discover', :on => :collection
  end

  resources :groups

  resources :lights

end
