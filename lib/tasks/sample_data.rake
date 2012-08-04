namespace :db do
  desc "Fill database with sample users"
  task populate: :environment do
    User.create!(name: "Jason Bourne",
                  email: "jason@example.com",
                  password: "password",
                  password_confirmation: "password" )
    501.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password = "password"
      User.create!(name: name, email: email, password: password,
                    password_confirmation: password)
    end
  end
end