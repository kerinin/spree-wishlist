class WishedObjectController < ApplicationController
  resource_controller

  # I'm sorry for this hack, but it is simplest way to make adding to wishlist after user logged in,
  # because redirect_to can not make POST requests
  def index
    create
  end

  create.before do
    @wished_object.wishlist = current_user.wishlist
  end
  
  create.response do |wants|
    wants.html { redirect_to @wished_object.wishlist }
  end

  update.response do |wants|
    wants.html { redirect_to @wished_object.wishlist }
  end
  
  destroy.response do |wants|
    wants.html { redirect_to @wished_object.wishlist }
  end
end
