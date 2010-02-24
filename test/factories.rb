Factory.define :wishlist do |l|
  l.name "My List"
  l.is_private false
  l.user {|u| u.association(:user) }
end

Factory.define :product do |p|
  p.name "Product Name"
  p.description "Description"
  p.price 100
  p.count_on_hand 1
  p.available_on Time.gm '1990'
end

Factory.define :role do |r|
end

Factory.define :user do |u|
  u.sequence(:email) { |n| "person#{n}@email.com" }
  u.sequence(:login) { |n| "login#{n}" }
  u.password "A really long password1234"
  u.password_confirmation "A really long password1234"
  u.roles { [Role.find_by_name("user") || Factory(:user_role) ] }
end

Factory.define(:user_role, :parent => :role) do |r|
  r.name "user"
end

Factory.define(:admin_role, :parent => :role) do |r|
  r.name "admin"
end

Factory.define(:seller_role, :parent => :role) do |r|
  r.name "seller"
end

Factory.define(:seller, :parent => :user) do |u|
  u.roles { [Role.find_by_name("seller") || Factory(:seller_role)]}
end

Factory.define(:admin_user, :parent => :user) do |u|
  u.roles { [Role.find_by_name("admin") || Factory(:admin_role)]}
end

