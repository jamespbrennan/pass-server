FactoryGirl.define do

  factory :user do |f|
    f.sequence(:email) { |n| "foo#{n}@example.com" }
    f.password "secret"
  end

  factory :service do |f|
    f.sequence(:url) { |n| "test{n}.example.com" }
  end

  factory :session do |f|
    service
  end

  factory :device do |f|
    user
  end
  
  factory :device_account do |f|
  end
end