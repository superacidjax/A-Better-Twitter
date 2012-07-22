class UsersController < ApplicationController

  expose(:user)

  def create
    if user.save
      flash[:success] = "Welcome to a Better Twitter!"
      redirect_to(user)
    else
      render :new
    end
  end

end
