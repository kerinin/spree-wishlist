class WishedObject < ActiveRecord::Base
  belongs_to :object, :polymorphic => true
  belongs_to :wishlist
  
  acts_as_list :scope => :wishlist
end
