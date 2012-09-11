Given /^a user visits the signin page$/ do
  visit signin_path
end

When /^user submits invalid signin information$/ do
  click_button "Sign in"
end

Then /^he should see an error message$/ do
  page.should have_selector('div.alert.alert-error')
end

Given /^the user has an account$/ do
  @user = User.create(name: "superacidjax", first_name: "Brian", last_name: "Dear",
                      zip_code: "77088", email: "user@example.com",
                      password: "password",
                      password_confirmation: "password")
end

Given /^the user submits valid signin information$/ do
  fill_in "email",    with: @user.email
  fill_in "password", with: @user.password
  click_button "Sign in"
end

Then /^he should see his home page$/ do
  page.should have_content(@user.name)
end

Then /^he should see a signout link$/ do
  page.should have_link('sign out', href: signout_path)
end