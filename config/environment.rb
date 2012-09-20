# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BetterTwitter::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => "superacidjax",
  :password => "reuters00",
  :domain => "zebras.me",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}