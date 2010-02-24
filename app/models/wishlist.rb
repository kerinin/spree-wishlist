class Wishlist < ActiveRecord::Base
  belongs_to :user
  has_many :collection, :dependent => :destroy, :class_name => "WishedObject"
  has_many :wished_products, :through => :collection, :source => :object, :source_type => 'Product'
  
  before_create :set_access_hash
  
  def to_param
    self.access_hash
  end  

  def self.get_by_param(param)
    Wishlist.find_by_access_hash(param)
  end

  def can_be_read_by?(user)
    !self.is_private? || user == self.user
  end
  
  def is_default=(value)
    self['is_default'] = value
    if self.is_default?
      Wishlist.update_all({:is_default => false}, ["id != ? AND is_default = ? AND user_id = ?", self.id, true, self.user_id])
    end
  end
  
  private
  
  def set_access_hash
    # Only creates the access hash once - allows the list to be saved w/o resetting the URL
    self.access_hash = Digest::SHA1.hexdigest("--#{user_id}--#{user.salt}--#{Time.now}--") if self.access_hash.nil?
  end
end
