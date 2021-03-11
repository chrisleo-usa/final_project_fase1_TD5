FactoryBot.define do
  factory :employee do
    email { "chris@campuscode.com" }
    password  { "123456" }
    admin { 1 }
  end
end