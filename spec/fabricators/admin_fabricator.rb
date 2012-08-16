Fabricator(:admin, from: :user) do
  email { sequence(:email) { |i| "brian#{i}@example.com" } }
  name { sequence(:name) { |i| "superacidjax#{i}" } }
  first_name { sequence(:name) { |i| "Brian-#{i}" } }
  last_name { sequence(:name) { |i| "Dear-#{i}" } }
  zip_code 77088
  password 'password'
  password_confirmation 'password'
  admin true
end