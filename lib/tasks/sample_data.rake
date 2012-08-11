namespace :db do
  desc "Fill database with sample users"
  task populate: :environment do
    make_users
    make_notes
    make_relationships
  end
end

def make_users
  admin = User.create!(name: "Brian Dear",
                         email: "superacidjax@me.com",
                         password: "password",
                         password_confirmation: "password" )
  admin.toggle!(:admin)
  51.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password = "password"
    User.create!(name: name, email: email, password: password,
                  password_confirmation: password)
  end
end

def make_notes
  users = User.all(limit: 6)
  51.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.notes.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[3..51]
  followers      = users[2..38]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end