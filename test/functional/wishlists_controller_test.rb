require File.dirname(__FILE__) + '/../test_helper'

class WishlistsControllerTest < ActionController::TestCase
  context "wishlists with no user session" do
    setup do
      @session_user = Factory :user
      @user1 = Factory :user
      @user2 = Factory :user

      @list1 = Factory :wishlist, :user => @user1, :is_private => false
      @list2 = Factory :wishlist, :user => @user1, :is_private => true
      @list3 = Factory :wishlist, :user => @user2, :is_private => false
      @list4 = Factory :wishlist, :user => @user2, :is_private => true
    end

    teardown do
      User.delete_all
      Wishlist.delete_all
    end

    context "on GET to :index" do
      setup do
        get :index
      end
      should_assign_to :wishlists
      should_respond_with :success
      
      should "include public lists" do
        assert assigns['wishlists'].include? @list1
        assert assigns['wishlists'].include? @list3
      end
      
      should "exclude private lists" do
        assert !( assigns['wishlists'].include? @list2 )
        assert !( assigns['wishlists'].include? @list4 )
      end
    end
  end

  context "wishlists with user session" do
    setup do
      @user1 = Factory :user
      @user2 = Factory :user
      UserSession.create(@user1)

      @list1 = Factory :wishlist, :user => @user1, :is_private => false
      @list2 = Factory :wishlist, :user => @user1, :is_private => true
      @list3 = Factory :wishlist, :user => @user2, :is_private => false
      @list4 = Factory :wishlist, :user => @user2, :is_private => true
    end

    teardown do
      User.delete_all
      Wishlist.delete_all
    end

    context "on GET to :index" do
      setup do
        get :index
      end
      should_assign_to :wishlists
      should_respond_with :success
      
      should "include public lists" do
        assert assigns['wishlists'].include? @list1
        assert assigns['wishlists'].include? @list3
      end
      
      should "include private lists for current_user" do
        assert assigns['wishlists'].include? @list2
      end
      
      should "exclude private lists for other users" do
        assert !( assigns['wishlists'].include? @list4 )
      end
    end 
    
    context "on GET to nested :index" do
      setup do
        get :index, {:user_id => @user1.id}
      end
      should_assign_to :user, :wishlists
      should_respond_with :success
      
      should "include user's lists" do
        assert assigns['wishlists'].include? @list1
        assert assigns['wishlists'].include? @list2
      end
      
      should "exclude non-owned lists" do
        assert !( assigns['wishlists'].include? @list3 )
        assert !( assigns['wishlists'].include? @list4 )
      end
    end
  end
end

