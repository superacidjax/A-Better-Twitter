class SessionsController < ApplicationController

expose(:sessions)

  def create
    if params[:password]
      user = User.find_by_email(params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_to user
      else
        flash.now[:error] = "I'm sorry, your email/password is incorrect!"
        render 'new'
      end
    else
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Signed in!"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
