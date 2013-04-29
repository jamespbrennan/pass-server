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
    f.public_key Crypto::PrivateKey.generate.public_key.to_s.unpack("H*").first
  end

  factory :api_token do |f|
  end

  factory :callback_type do |f|
    name 'Foo'
  end

  factory :callback do |f|
    service
    callback_type
    f.address 'https://www.example.com'
  end
end