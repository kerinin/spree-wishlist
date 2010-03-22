class WishlistsController < ApplicationController
  resource_controller
  helper :products
  belongs_to :user
  
  create.before do
    @wishlist.user = current_user
  end

  update.wants.js { 
    flash[:notice] = nil
    render :js => "alert('#{t :updated_successfully}');"
  }
  
  private

    def collection
      if current_user
        end_of_association_chain.find(:all, :conditions => ['wishlists.is_private = ? OR wishlists.user_id = ?', false, current_user.id])
      else
        end_of_association_chain.find(:all, :conditions => ['wishlists.is_private = ?', false] )
      end
    end
    
    def object
      @object ||= end_of_association_chain.find_by_access_hash(param)
      @object ||= current_user.wishlist if current_user
      @object
    end

    def can_read?
      object && object.can_be_read_by?(current_user)
    end
end
