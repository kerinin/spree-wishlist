require File.dirname(__FILE__) + '/../test_helper'

class WishlistTest < Test::Unit::TestCase
  context "A wishlist" do
    setup do
      @user = Factory :user
      
      @product1 = Factory :product
      @product2 = Factory :product
      @product3 = Factory :product
      
      @list1 = Factory :wishlist, :name => 'list 1', :wished_products => [@product1, @product2], :user => @user
      @list2 = Factory :wishlist, :name => 'list 2', :wished_products => [@product2, @product3], :user => @user, :is_private => true
    end

    teardown do
      User.delete_all
      Product.delete_all
      Wishlist.delete_all
    end

    should "have some values" do
      assert_equal 'list 1', @list1.name
      assert @list1.access_hash
      assert_equal @user, @list1.user
      assert_equal false, @list1.is_private?
      assert_equal true, @list2.is_private?
    end
    
    should "get and set url param" do
      assert_equal @list1.access_hash, @list1.to_param
      assert_equal @list1, Wishlist.get_by_param( @list1.to_param )
    end
    
    should "have items" do
      assert @list1.collection.map(&:object).include? @product1
      assert @list1.collection.map(&:object).include? @product2
      assert !( @list1.collection.map(&:object).include? @product3 )
      
      assert !( @list2.collection.map(&:object).include? @product1 )
      assert @list2.collection.map(&:object).include? @product2
      assert @list2.collection.map(&:object).include? @product3
    end
    
    should "act_as_list" do
      assert_equal @product1, @list1.collection.first.object
      
      @list1.collection.first.move_to_bottom
      assert_equal @product2, @list1.collection.first.object
    end
  end
end

