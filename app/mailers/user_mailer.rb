class UserMailer < ActionMailer::Base

  default from: "do-not-reploy@zebras.me"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"

    mail to: "to@example.org"
  end
end
