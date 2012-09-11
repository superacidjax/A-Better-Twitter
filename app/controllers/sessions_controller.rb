class SessionsController < ApplicationController

expose(:sessions)

  def new
    render :layout => 'signup'
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:error] = "I'm sorry, your email/password is incorrect!"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
