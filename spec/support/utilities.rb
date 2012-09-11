include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error')
  end
end

def sign_in(user)
  visit signin_path
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara
  cookies[:remember_token] = user.remember_token
end