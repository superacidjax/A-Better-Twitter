Given /^a user visits the signup page$/ do
  visit signup_path
end

When /^user submits invalid signup information$/ do
  click_button "Create my account"
end

Given /^the user submits valid login information$/ do
  fill_in "Name",     with: 'Brian Dear'
  fill_in "Email",    with: 'brian@example.com'
  fill_in "Password", with: 'password'
  fill_in "Confirmation", with: 'password'
  click_button "Create my account"
end

Then /^he should see a welcome message$/ do
  page.should have_selector('div.alert.alert-success')
end