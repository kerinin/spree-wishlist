# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class WishlistExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/wishlist"

  # Please use wishlist/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    User.class_eval do
      has_many :wishlists
      
      def wishlist
        default_wishlist = self.wishlists.first(:conditions => ["is_default = ?", true]) 
        default_wishlist ||= self.wishlists.first
        default_wishlist ||= self.wishlists.create(:name => "My wishlist", :is_default => true)
        default_wishlist.update_attribute(:is_default, true) unless default_wishlist.is_default?
        default_wishlist
      end
    end

    ProductsController.class_eval do    
      def wish_for
        load_object
        load_data
        
        handle_wishlists
        
        respond_to do |format|
          format.html { redirect_to product_url(@product) }
          format.js { render :action => :wish_for }
        end
      end
      
      private
      
      def handle_wishlists
        if params[:wishlist_ids]
          current_user.wishlists.map{ |l| l.wished_products.delete(@product) }
          wishlists = params[:wishlist_ids].map { |id| Wishlist.user_id_equals( current_user.id ).find( id ) }
          wishlists.map { |l| l.wished_products << @product }
        end
      end
    end
  end
end
