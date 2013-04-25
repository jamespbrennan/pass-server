FactoryGirl.define do

  sequence(:email) {|n| "user#{n}@example.com" }

  factory :user do |f|
    f.email { generate(:email) }
    f.password 'secret'
  end

  factory :service do |f|
    f.url 'https://example.com'
  end

  factory :session do |f|
    service
  end

  factory :device do |f|
    f.name 'My device'
    user
  end
  
  factory :device_account do |f|
    f.public_key Crypto::PrivateKey.generate.public_key
  end

  factory :api_token do |f|
  end

  factory :callback do |f|
    service
    f.address 'https://www.example.com'
  end
end