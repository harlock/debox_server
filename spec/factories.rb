FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "user#{n}@indeos.es"}
    password 'secret'
  end

  factory :admin, parent: :user  do
    admin true
  end

  factory :app do
    sequence(:name) {|n| "app[#{n}]"}
  end

  factory :recipe do
    sequence(:name) {|n| "recipe[#{n}]"}
    content "#recipe_content"
  end

  factory :permission do
    user { build_stubbed :user }
    recipe { build_stubbed :recipe }
    action 'cap'
  end

end
