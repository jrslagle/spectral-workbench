Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with 'rake routes'

  get '/local/:login' => 'sessions#local'
  get '/logout' => 'sessions#logout'
  get '/login' => 'sessions#login'
  get '/session/new' => 'sessions#new'
  get '/session' => 'session#create', :conditions => { :method => :get }

  get '/register' => 'users#create'
  get '/signup' => 'users#new'
  get '/contributors' => 'users#contributors'
  get '/contributors/top' => 'users#top_contributors'
  get '/offline' => 'users#offline'

  # countertop spectrometer and device paths
  get '/key/:id' => 'device#create_key'
  get '/lookup' => 'device#lookup'
  get '/device/claim' => 'device#claim'

  get '/capture' => 'capture#index'
  get '/capture/recent_calibrations' => 'capture#recent_calibrations'

  # Registered user pages:
  get '/profile/(:id)', to: 'users#show', :as => 'profile'

  get '/macro/edit/:id' => 'macros#edit'
  get '/macro/update/:id' => 'macros#update'
  get '/macro/:author/:id' => 'macros#show'
  get '/macro/:author/:id.:format' => 'macros#show'
  get '/macros' => 'macros#index'

  get '/dashboard' => 'users#dashboard'
  get '/popular' => 'likes#index'
  get '/popular/recent' => 'likes#recent'

  get '/upload' => 'spectrums#new'

  resources :users
  resources :macros
  resources :session
  resources :tags
  resources :sets
  resources :comments, :belongs_to => :spectrums
  resources :spectrums do
    resources :comments
    member do
      get :clone_search
      get :compare_search
      get :set_search
    end
  end

  post '/message' => 'users#message'
  get '/stats' => 'spectrums#stats'

  # legacy; permanent redirect:
  get '/analyze/spectrum/:id', to: redirect('/spectrums/%{id}')
  get '/analyze/spectrum/:id.:format', to: redirect('/spectrums/%{id}.%{format}')
  get '/spectra/show/:id.:format', to: redirect('/spectrums/%{id}.%{format}')
  get '/spectra/show/:id', to: redirect('/spectrums/%{id}')
  get '/sets/show/:id.:format', to: redirect('/sets/%{id}.%{format}')
  get '/sets/show/:id', to: redirect('/sets/%{id}')

  get '/spectra/assign' => 'spectrums#assign'
  get '/spectra/feed' => 'spectrums#rss', defaults: { format: 'xml' }
  get '/spectra/search' => 'spectrums#search'
  post '/spectra/calibrate/:id' => 'spectrums#calibrate'
  get '/spectra/anonymous' => 'spectrums#anonymous'
  get '/spectra/search/:id' => 'spectrums#search'
  get '/search/:id' => 'spectrums#search'
  get '/spectra/plotsfeed' => 'spectrums#plots_rss', defaults: { format: 'xml' }
  get '/spectra/feed/:author' => 'spectrums#rss', defaults: { format: 'xml' }
  get '/spectra/:id' => 'spectrums#show'
  get '/spectra/:action/:id' => 'spectrums'

  # Here comes the matching controller
  get '/match/livesearch' => 'match#livesearch'
  get '/match/:id' => 'match#index'

  # cache_interval is how often the cache is recalculated
  # but if nothing changes, the checksum will not change
  # and the manifest will not trigger a re-download
  offline = Rack::Offline.configure :cache_interval => 120 do
    cache ActionController::Base.helpers.asset_path("application.css")
    cache ActionController::Base.helpers.asset_path("application.js")
    cache ActionController::Base.helpers.asset_path("capture.css")
    cache ActionController::Base.helpers.asset_path("capture.js")
    cache ActionController::Base.helpers.asset_path("analyze.js")

    cache "/capture"
    #cache "/capture/offline"
    cache "/offline"

    cache "/images/spectralworkbench.png"
    cache "/images/example-sky.jpg"
    cache "/images/example-cfl.jpg"
    cache "/images/calibration-example.png"
    cache "/images/logo.png"
    cache "/lib/junction/webfonts/junction-regular.eot"
    cache "/lib/junction/webfonts/junction-regular.woff"
    cache "/lib/junction/webfonts/junction-regular.ttf"
    cache "/lib/junction/webfonts/junction-regular.svg"
    cache "/lib/fontawesome/css/font-awesome.min.css"

    network "/"
    fallback "/" => "/offline"
    fallback "/dashboard" => "/offline"
  end
  match "/index.manifest" => offline

  root to: 'spectrums#index'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  # See how all your routes lay out with 'rake routes'
  match ':controller/:action'
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'

end
