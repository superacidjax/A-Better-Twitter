class SessionsController < ApplicationController

expose(:sessions)

  def new
    render :layout => 'signup'
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if params[:remember_me]
      cookies.permanent[:remember_token] = user.remember_token
      else
        cookies[:remember_token] = user.remember_token
      end
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = "I'm sorry, your email/password is incorrect!"
      render 'new'
    end
  end

  def destroy
    cookies.delete(:remember_token)
    sign_out
    redirect_to root_path
  end

end
