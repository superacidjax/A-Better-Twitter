class UsersController < ApplicationController

  expose(:user)

  def create
    if user.save
      sign_in user
      flash[:success] = "Welcome to a Better Twitter!"
      redirect_to(user)
    else
      render :new
    end
  end

end
