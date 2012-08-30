namespace :db do
  desc "Fill database with sample users"
  task populate: :environment do
    make_users
    make_notes
    make_relationships
    make_groups
  end
end

def make_users
  admin = User.create!(first_name: "Brian",
                        last_name: "Dear",
                        zip_code: "07304",
                        email: "superacidjax@me.com",
                        password: "password",
                        password_confirmation: "password",
                        name: "superacidjax")
  admin.toggle!(:admin)
  51.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password = "password"
    zip = "10010#{n+1}"
    first_name = "Brian+#{n+1}"
    last_name = "Dear+#{n+1}"
    User.create!(name: name, first_name: first_name, last_name: last_name,
                email: email, password: password, zip_code: zip,
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

def make_groups
  users = User.all(limit: 6)
  5.times do
    content = Faker::Lorem.words(1)
    desc    = Faker::Lorem.sentence(10)
    cat     = "Pets"
    users.each { |user| user.groups.create!(name: content, description: desc,
      category: cat) }
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