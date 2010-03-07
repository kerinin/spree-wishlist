require File.dirname(__FILE__) + '/../test_helper'

class ProductsControllerTest < ActionController::TestCase
  context "given data" do
    setup do
      @user = Factory :user

      @product1 = Factory :product
      @product2 = Factory :product
      @product3 = Factory :product
      @product4 = Factory :product

      @list1 = Factory :wishlist, :name => 'list 1', :wished_products => [@product1, @product2], :user => @user
      @list2 = Factory :wishlist, :name => 'list 2', :wished_products => [@product2, @product3], :user => @user, :is_private => true
      @list3 = Factory :wishlist, :name => 'list 3', :wished_products => [@product4], :user => @user
    end

    teardown do
      User.delete_all
      Product.delete_all
      Wishlist.delete_all
    end

    context "on PUT to :wish_for" do
      setup do
        put :wish_for, {:id => @product1.to_param, :wishlist_ids => [@list2.id, @list3.id]}
      end
      should_respond_with :redirect
      should_redirect_to('product#show') { product_url(@product) }
    end
  end
end

