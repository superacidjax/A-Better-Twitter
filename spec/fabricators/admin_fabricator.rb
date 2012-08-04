Fabricator(:admin, from: :user) do
  email { sequence(:email) { |i| "brian#{i}@example.com" } }
  name { sequence(:name) { |i| "Brian Dear-#{i}" } }
  password 'password'
  password_confirmation 'password'
  admin true
end