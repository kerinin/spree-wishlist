# Put your extension routes here.

map.resources :wishlists
map.resources :wished_products
map.default_wishlist '/wishlist', :controller => :wishlists, :action => 'show'

map.resources :products, :member => {:wish_for => :put}
