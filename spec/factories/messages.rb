FactoryGirl.define do
  factory :message do
    sequence(:body) { Faker::Lorem.sentence }
    image File.open("#{Rails.root}/public/uploads/no_image.jpg")
    user
    group
    created_at {Faker::Time.between(2.days.ago, Time.now, :all)}
  end
end
