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
    f.public_key OpenSSL::PKey::RSA.generate(2048).public_key.to_pem
  end

  factory :api_token do |f|
  end

  factory :callback do |f|
    service
    f.address 'https://www.example.com'
  end
end