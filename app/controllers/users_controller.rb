class UsersController < ApplicationController

  expose(:user)

  def create
    if user.save
      redirect_to(user)
    else
      render :new
    end
  end

end
